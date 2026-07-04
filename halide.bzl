"""Halide library rules"""

load("@halide_prebuilt_pkg//:host_info.bzl", "HOST_PLATFORM")
load("@rules_cc//cc:cc_binary.bzl", "cc_binary")
load("@rules_cc//cc:cc_library.bzl", "cc_library")

def _generator_compatible_with():
    compat_dict = {}

    # Check linux_arm64 target compatibility
    if HOST_PLATFORM == "linux-aarch64":
        compat_dict["@rules_halide//internal:linux_arm64"] = []
    else:
        compat_dict["@rules_halide//internal:linux_arm64"] = ["@platforms//:incompatible"]

    # Check macos_arm64 target compatibility
    if HOST_PLATFORM == "macos-arm64":
        compat_dict["@rules_halide//internal:macos_arm64"] = []
    else:
        compat_dict["@rules_halide//internal:macos_arm64"] = ["@platforms//:incompatible"]

    # Check linux_x86_64 target compatibility
    if HOST_PLATFORM == "linux-x86_64":
        compat_dict["@rules_halide//internal:linux_x86_64"] = []
    else:
        compat_dict["@rules_halide//internal:linux_x86_64"] = ["@platforms//:incompatible"]

    compat_dict["//conditions:default"] = []
    return select(compat_dict)

def _halide_target_select():
    """Returns the Halide target string based on platform."""
    return select({
        "@rules_halide//internal:macos_arm64": "target=arm-64-osx ",
        "@rules_halide//internal:linux_arm64": "target=arm-64-linux ",
        "@rules_halide//internal:linux_x86_64": "target=host ",
        "//conditions:default": "",
    })

def _halide_compatible_with():
    """Returns target_compatible_with based on platform."""
    return select({
        "@rules_halide//internal:macos_arm64": [],
        "@rules_halide//internal:linux_arm64": [],
        "@rules_halide//internal:linux_x86_64": [],
        "//conditions:default": ["@platforms//:incompatible"],
    })

def halide_library(name, src, function, args, visibility = None):
    cc_binary(
        name = name + "_generator",
        srcs = [
            src,
        ],
        deps = [
            "@rules_halide//:halide",
            "@rules_halide//:gengen",
        ],
        target_compatible_with = _generator_compatible_with(),
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
