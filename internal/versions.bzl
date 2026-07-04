"""Supported versions of Halide"""

DEFAULT_VERSION = "18.0.0"

SUPPORTED_VERSIONS = {
    "18.0.0": {
        "linux-x86_64": {
            "url": "https://github.com/halide/Halide/releases/download/v18.0.0/Halide-18.0.0-x86-64-linux-8c651b459a4e3744b413c23a29b5c5d968702bb7.tar.gz",
            "sha256": "8e491e2f9ac7c138482bb344cb291c708632718dfee1dd7f9c3749b3607e41c7",
            "strip_prefix": "Halide-18.0.0-x86-64-linux",
        },
        "linux-aarch64": {
            "url": "https://github.com/halide/Halide/releases/download/v18.0.0/Halide-18.0.0-arm-64-linux-8c651b459a4e3744b413c23a29b5c5d968702bb7.tar.gz",
            "sha256": "89083e890f47cd9cef983d5555111af4c9628e89b1ce24712dc090edb89c3dd8",
            "strip_prefix": "Halide-18.0.0-arm-64-linux",
        },
        "macos-arm64": {
            "url": "https://github.com/halide/Halide/releases/download/v18.0.0/Halide-18.0.0-arm-64-osx-8c651b459a4e3744b413c23a29b5c5d968702bb7.tar.gz",
            "sha256": "d96831794ba91455a19d1d5832f175c6913d7238cb70dadfdc0e1475ccd9e1e6",
            "strip_prefix": "Halide-18.0.0-arm-64-osx",
        },
    },
    "17.0.2": {
        "linux-x86_64": {
            "url": "https://github.com/halide/Halide/releases/download/v17.0.2/Halide-17.0.2-x86-64-linux-b2e6d2aa1f205c0ed5f4e266252c633268de2805.tar.gz",
            "sha256": "3191b67598a72a55e0781eff18dcd56a7a0db753bdaa35326bc4312c9e5c0459",
            "strip_prefix": "Halide-17.0.2-x86-64-linux",
        },
        "linux-aarch64": {
            "url": "https://github.com/halide/Halide/releases/download/v17.0.2/Halide-17.0.2-arm-64-linux-b2e6d2aa1f205c0ed5f4e266252c633268de2805.tar.gz",
            "sha256": "d948475a695a5db705032601eb79f8a378313691b066abb85393540b4ebd0fb3",
            "strip_prefix": "Halide-17.0.2-arm-64-linux",
        },
        "macos-arm64": {
            "url": "https://github.com/halide/Halide/releases/download/v17.0.2/Halide-17.0.2-arm-64-osx-b2e6d2aa1f205c0ed5f4e266252c633268de2805.tar.gz",
            "sha256": "43a7f7a7e03e4b4950451c45a45a7a497bda3cc3d3d89dae8dc192b35ff6db10",
            "strip_prefix": "Halide-17.0.2-arm-64-osx",
        },
    },
    "16.0.0": {
        "linux-x86_64": {
            "url": "https://github.com/halide/Halide/releases/download/v16.0.0/Halide-16.0.0-x86-64-linux-1e963ff817ef0968cc25d811a25a7350c8953ee6.tar.gz",
            "sha256": "694b3ed359d694f82dca9ccca761d927fdf97599b78ef0afe2ad881669ae6c40",
            "strip_prefix": "Halide-16.0.0-x86-64-linux",
        },
        "linux-aarch64": {
            "url": "https://github.com/halide/Halide/releases/download/v16.0.0/Halide-16.0.0-arm-64-linux-1e963ff817ef0968cc25d811a25a7350c8953ee6.tar.gz",
            "sha256": "de000ec21c340f3ff7381ad01567cf986446eaf6d5c5c7e30ac72363074bd77e",
            "strip_prefix": "Halide-16.0.0-arm-64-linux",
        },
        "macos-arm64": {
            "url": "https://github.com/halide/Halide/releases/download/v16.0.0/Halide-16.0.0-arm-64-osx-1e963ff817ef0968cc25d811a25a7350c8953ee6.tar.gz",
            "sha256": "57e9b1de3a40d50a47e5f728aa12d838471c3c69cb250babf84999577f1e4d51",
            "strip_prefix": "Halide-16.0.0-arm-64-osx",
        },
    },
    "15.0.1": {
        "linux-x86_64": {
            "url": "https://github.com/halide/Halide/releases/download/v15.0.1/Halide-15.0.1-x86-64-linux-4c63f1befa1063184c5982b11b6a2cc17d4e5815.tar.gz",
            "sha256": "d290fadf3f358c94aacf43c883de6468bb98883e26116920afd491ec0e440cd2",
            "strip_prefix": "Halide-15.0.1-x86-64-linux",
        },
        "linux-aarch64": {
            "url": "https://github.com/halide/Halide/releases/download/v15.0.1/Halide-15.0.1-arm-64-linux-4c63f1befa1063184c5982b11b6a2cc17d4e5815.tar.gz",
            "sha256": "ee3def00a1734ec67f63b2d35d5f820149a539d416e7c799eb200dcc65c3ebbc",
            "strip_prefix": "Halide-15.0.1-arm-64-linux",
        },
        "macos-arm64": {
            "url": "https://github.com/halide/Halide/releases/download/v15.0.1/Halide-15.0.1-arm-64-osx-4c63f1befa1063184c5982b11b6a2cc17d4e5815.tar.gz",
            "sha256": "db5d20d75fa7463490fcbc79c89f0abec9c23991f787c8e3e831fff411d5395c",
            "strip_prefix": "Halide-15.0.1-arm-64-osx",
        },
    },
    "14.0.0": {
        "linux-x86_64": {
            "url": "https://github.com/halide/Halide/releases/download/v14.0.0/Halide-14.0.0-x86-64-linux-6b9ed2afd1d6d0badf04986602c943e287d44e46.tar.gz",
            "sha256": "be3bdd067acb9ee0d37d0830821113cd69174bee46da466a836d8829fef7cf91",
            "strip_prefix": "Halide-14.0.0-x86-64-linux",
        },
        "linux-aarch64": {
            "url": "https://github.com/halide/Halide/releases/download/v14.0.0/Halide-14.0.0-arm-64-linux-6b9ed2afd1d6d0badf04986602c943e287d44e46.tar.gz",
            "sha256": "cdd42411bcbba682f73d7db0af69837c4857ee90f1727c6feb37fc9a98132385",
            "strip_prefix": "Halide-14.0.0-arm-64-linux",
        },
        "macos-arm64": {
            "url": "https://github.com/halide/Halide/releases/download/v14.0.0/Halide-14.0.0-arm-64-osx-6b9ed2afd1d6d0badf04986602c943e287d44e46.tar.gz",
            "sha256": "164e5e6e238c7c35e54776d9911f2922d92078ef79a4a1f3c1c9cd5a251f3efa",
            "strip_prefix": "Halide-14.0.0-arm-64-osx",
        },
    },
}
