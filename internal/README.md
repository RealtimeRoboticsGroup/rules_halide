# rules_halide Internal: Releases and Versioning

This directory contains the core implementation of the prebuilt Halide packaging rules and version configurations.

---

## 1. How to Release the Ruleset

This repository uses a automated GitHub Actions release workflow configured in [.github/workflows/release.yml](file:///home/austin/local/rules_halide/.github/workflows/release.yml).

### Automatically Triggered Releases
To publish a new release:
1. Draft and publish a new GitHub release on the repository with a version tag starting with `v` (e.g. `v0.0.1`).
2. The `Publish Ruleset Release Archive` workflow will run automatically.
3. It checks out the code, dynamically patches `MODULE.bazel` to set the correct `version` attribute, packages the repository files into a clean `rules_halide-<version>.tar.zst` archive, and uploads it to the release assets.

### Manually Triggered Releases
If you want to create a release manually:
1. Navigate to the **Actions** tab on GitHub.
2. Select the **Publish Ruleset Release Archive** workflow.
3. Click **Run workflow**, enter the version string (e.g. `0.0.1`), and click the run button.
4. The workflow will create a draft release (if one does not exist) and upload the packaged archive.

---

## 2. Managing Prebuilt Halide Versions

`rules_halide` downloads and configures precompiled official Halide releases. Supported versions, download URLs, and SHA256 checksums are declared in [internal/versions.bzl](file:///home/austin/local/rules_halide/internal/versions.bzl).

### Adding a New Halide Version
When a new version of Halide is released on GitHub (e.g., `v19.0.0` or later):
1. Identify the download URLs for the following platforms from the release page:
   - `x86-64-linux`
   - `arm-64-linux`
   - `arm-64-osx`
2. Download the archives and compute their SHA256 hashes.
3. Add the metadata block to the `SUPPORTED_VERSIONS` dictionary in [internal/versions.bzl](file:///home/austin/local/rules_halide/internal/versions.bzl). Be sure to configure the `strip_prefix` properly (it matches the root folder name inside the archive, which typically excludes the commit hash suffix).
4. Update `DEFAULT_VERSION` if you want this new release to be the default toolchain for consumers.
