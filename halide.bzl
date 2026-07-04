"""Starlark rules for ahead-of-time (AOT) Halide compilation.

This module provides `halide_library` to compile Halide generators natively
for the host platform, run them to produce AOT compiled code (header and object files)
compatible with target configurations, and expose them as standard C++ dependencies.
"""

load("@platforms//host:constraints.bzl", "HOST_CONSTRAINTS")
load("@rules_cc//cc:cc_binary.bzl", "cc_binary")
load("@rules_cc//cc:cc_library.bzl", "cc_library")

def _halide_target_select():
    """Returns the Halide target parameter matching the compilation configuration.

    This targets string instructs the Halide generator on which CPU/architecture and OS
    to compile optimized machine code for (e.g. `target=arm-64-linux` for cross-compiling).
    """
    return select({
        "@rules_halide//internal:macos_arm64": "target=arm-64-osx ",
        "@rules_halide//internal:linux_arm64": "target=arm-64-linux ",
        "@rules_halide//internal:linux_x86_64": "target=x86-64-linux ",
        "//conditions:default": "",
    })

def _halide_compatible_with():
    """Restricts the compatibility of Halide libraries to supported architectures.

    This prevents building Halide targets on unsupported configurations (such as Windows).
    """
    return select({
        "@rules_halide//internal:macos_arm64": [],
        "@rules_halide//internal:linux_arm64": [],
        "@rules_halide//internal:linux_x86_64": [],
        "//conditions:default": ["@platforms//:incompatible"],
    })

def halide_library(name, src, function, args, visibility = None):
    """Compiles a Halide generator ahead-of-time to a C++ library target.

    This macro defines three targets:
    1. `<name>_generator` (cc_binary): The native C++ generator binary compiled for
       the host. It compiles the Halide pipeline. Marked `target_compatible_with = HOST_CONSTRAINTS`
       so that wildcard builds don't compile it for target architectures (where libHalide is missing),
       but it remains compatible in the exec/host configuration to be run as a tool.
    2. `generate_<name>` (genrule): Runs the generator binary with the resolved target flags
       to output the header file (`<name>.h`), the object file (`<name>.o`), and the
       conceptual statement file (`<name>.stmt.html`).
    3. `<name>` (cc_library): Exposes the generated header and object files as a C++ library
       ready to be linked by other targets.

    Args:
        name: Name of the generated cc_library target.
        src: The C++ source file containing the Halide generator definition.
        function: Name of the registered Halide generator to execute.
        args: Extra arguments to pass to the generator binary (e.g., 'scale=2.5').
        visibility: Target visibility list.
    """
    cc_binary(
        name = name + "_generator",
        srcs = [
            src,
        ],
        deps = [
            "@rules_halide//:halide",
            "@rules_halide//:gengen",
        ],
        target_compatible_with = HOST_CONSTRAINTS,
    )
    native.genrule(
        name = "generate_" + name,
        outs = [
            name + ".h",
            name + ".o",
            name + ".stmt.html",
        ],
        cmd = "$(location :" + name + "_generator) -g '" + function + "' -o $(RULEDIR) -f " + name + " -e 'o,h,html' " + _halide_target_select() + args,
        tools = [
            ":" + name + "_generator",
        ],
        target_compatible_with = _halide_compatible_with(),
    )
    cc_library(
        name = name,
        srcs = [name + ".o"],
        hdrs = [name + ".h"],
        visibility = visibility,
        deps = [
            "@rules_halide//:runtime",
        ],
    )
