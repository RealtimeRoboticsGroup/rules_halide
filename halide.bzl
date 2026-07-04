"""Starlark rules for ahead-of-time (AOT) Halide compilation.

This module provides the `halide_library` symbolic macro to compile Halide generators
natively for the host platform, run them to produce AOT compiled code (header and object files)
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

def _halide_library_impl(name, visibility, src, function, args = ""):
    """Implementation function for the halide_library symbolic macro.

    Instantiates the native compile binary target (generator), the AOT generation target
    (genrule), and the public C++ library dependency target.
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
        name = name + "_generate",
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

halide_library = macro(
    doc = """Compiles a Halide generator ahead-of-time to a C++ library target.

    This macro defines a generator binary compiled for the host, runs it inside a genrule
    to produce optimized pipeline object and header files, and packages them as a C++ library.

    Args:
        src: The C++ source file containing the Halide generator definition.
        function: Name of the registered Halide generator to execute.
        args: Extra arguments to pass to the generator binary (e.g. 'scale=2.5').
    """,
    implementation = _halide_library_impl,
    attrs = {
        "src": attr.label(
            doc = "The C++ source file containing the Halide generator definition.",
            mandatory = True,
            allow_single_file = True,
            configurable = False,
        ),
        "function": attr.string(
            doc = "Name of the registered Halide generator to execute.",
            mandatory = True,
            configurable = False,
        ),
        "args": attr.string(
            doc = "Extra arguments to pass to the generator binary.",
            default = "",
            configurable = False,
        ),
    },
)
