"""Supported versions of Halide"""

DEFAULT_VERSION = "14.0.0"

SUPPORTED_VERSIONS = {
    "14.0.0": {
        "linux-x86_64": {
            "url": "https://github.com/halide/Halide/releases/download/v14.0.0/Halide-14.0.0-x86-64-linux-6b9ed2afd1d6d0badf04986602c943e287d44e46.tar.gz",
            "sha256": "be3bdd067acb9ee0d37d0830821113cd69174bee46da466a836d8829fef7cf91",
            "strip_prefix": "Halide-14.0.0-x86-64-linux",
        },
        "linux-aarch64": {
            "url": "https://github.com/halide/Halide/releases/download/v14.0.0/Halide-14.0.0-arm-64-linux-6b9ed2afd1d6d0badf04986602c943e287d44e46.tar.gz",
            "sha256": "cdd42411bcbba682f73d7db0af69837c4857ee90f1727c67eb37fc9a98132385",
            "strip_prefix": "Halide-14.0.0-arm-64-linux",
        },
        "macos-arm64": {
            "url": "https://github.com/halide/Halide/releases/download/v14.0.0/Halide-14.0.0-arm-64-osx-6b9ed2afd1d6d0badf04986602c943e287d44e46.tar.gz",
            "sha256": "164e5e6e238c7c35e54776d9911f2922d92078ea79a4a1f3c1c9cd5a251f3efa",
            "strip_prefix": "Halide-14.0.0-arm-64-osx",
        },
    },
}
