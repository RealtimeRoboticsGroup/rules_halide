"""Halide toolchain and alias definitions.

This file defines the toolchain type, provider, and rules used to manage
precompiled Halide libraries across architectures, alongside `halide_alias`
to route those toolchain-provided libraries through standard toolchain resolution.
"""

load("@rules_cc//cc/common:cc_info.bzl", "CcInfo")

HalideToolchainInfo = provider(
    doc = "Details of Halide toolchain libraries for compilation and linking.",
    fields = {
        "halide": "The precompiled libHalide library target (CcInfo).",
        "gengen": "The GenGen source/library target (CcInfo) required by generators.",
        "runtime": "The Halide runtime header-only target (CcInfo) required by generated code.",
    },
)

def _halide_toolchain_impl(ctx):
    """Implementation of the halide_toolchain rule.

    Packs the configured library targets into a HalideToolchainInfo provider.
    """
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
    doc = "Defines a Halide toolchain wrapping the precompiled static libraries.",
    implementation = _halide_toolchain_impl,
    attrs = {
        "halide": attr.label(
            doc = "The precompiled halide library target.",
            mandatory = True,
            providers = [CcInfo],
        ),
        "gengen": attr.label(
            doc = "The GenGen library target.",
            mandatory = True,
            providers = [CcInfo],
        ),
        "runtime": attr.label(
            doc = "The Halide runtime library target.",
            mandatory = True,
            providers = [CcInfo],
        ),
    },
)

def _halide_alias_impl(ctx):
    """Implementation of the halide_alias rule.

    Performs toolchain resolution for the '@rules_halide//:toolchain_type' toolchain
    to extract the specific library target (halide, gengen, or runtime) corresponding
    to the target configuration, and propagates its CcInfo and DefaultInfo.
    """
    toolchain = ctx.toolchains["@rules_halide//:toolchain_type"]
    halide_info = toolchain.halide_info
    target = getattr(halide_info, ctx.attr.target_type)
    return [
        target[CcInfo],
        target[DefaultInfo],
    ]

halide_alias = rule(
    doc = """
    Acts as a configuration-aware proxy for Halide toolchain libraries.

    Rather than linking against hardcoded library targets directly, Bazel targets
    should link against a halide_alias. During build analysis, the alias uses
    toolchain resolution to select the correct precompiled binaries corresponding
    to the configuration it is built in (e.g. host configuration vs target configuration).
    """,
    implementation = _halide_alias_impl,
    attrs = {
        "target_type": attr.string(
            doc = "The library target to extract from the resolved toolchain.",
            mandatory = True,
            values = ["halide", "gengen", "runtime"],
        ),
    },
    toolchains = ["@rules_halide//:toolchain_type"],
)
