"""Halide toolchain definition"""

load("@rules_cc//cc/common:cc_info.bzl", "CcInfo")

HalideToolchainInfo = provider(
    doc = "Details of Halide toolchain",
    fields = {
        "halide": "The precompiled halide library target",
        "gengen": "The GenGen.cpp source target",
        "runtime": "The Halide runtime header-only target",
    },
)

def _halide_toolchain_impl(ctx):
    return [
        platform_common.ToolchainInfo(
            halide_info = HalideToolchainInfo(
                halide = ctx.attr.halide,
                gengen = ctx.attr.gengen,
                runtime = ctx.attr.runtime,
            ),
        ),
    ]

halide_toolchain = rule(
    implementation = _halide_toolchain_impl,
    attrs = {
        "halide": attr.label(
            mandatory = True,
            providers = [CcInfo],
        ),
        "gengen": attr.label(
            mandatory = True,
            providers = [CcInfo],
        ),
        "runtime": attr.label(
            mandatory = True,
            providers = [CcInfo],
        ),
    },
)

def _halide_alias_impl(ctx):
    toolchain = ctx.toolchains["@rules_halide//:toolchain_type"]
    halide_info = toolchain.halide_info
    target = getattr(halide_info, ctx.attr.target_type)
    return [
        target[CcInfo],
        target[DefaultInfo],
    ]

halide_alias = rule(
    implementation = _halide_alias_impl,
    attrs = {
        "target_type": attr.string(mandatory = True, values = ["halide", "gengen", "runtime"]),
    },
    toolchains = ["@rules_halide//:toolchain_type"],
)
