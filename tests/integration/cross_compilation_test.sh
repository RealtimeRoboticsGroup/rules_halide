#!/bin/bash
set -euo pipefail

# Set HOME inside the test temp dir to avoid sandbox access issues on macOS
export HOME="${TEST_TMPDIR}/home"
mkdir -p "${HOME}"

# Resolve sandbox and setup writable workspace
readonly WRITABLE_WORKSPACE="${TEST_TMPDIR}/writable_workspace"
mkdir -p "${WRITABLE_WORKSPACE}"
cp -RL "${BIT_WORKSPACE_DIR}"/* "${WRITABLE_WORKSPACE}/"
if [[ -f "${BIT_WORKSPACE_DIR}/.bazelrc" ]]; then
  cp -RL "${BIT_WORKSPACE_DIR}/.bazelrc" "${WRITABLE_WORKSPACE}/"
fi
chmod -R +w "${WRITABLE_WORKSPACE}"

PARENT_ROOT=$(realpath "${BIT_WORKSPACE_DIR}/../../..")
sed "s|path = \"../../..\"|path = \"${PARENT_ROOT}\"|g" "${WRITABLE_WORKSPACE}/MODULE.bazel" > "${WRITABLE_WORKSPACE}/MODULE.bazel.tmp" && mv "${WRITABLE_WORKSPACE}/MODULE.bazel.tmp" "${WRITABLE_WORKSPACE}/MODULE.bazel"

# Backup pristine MODULE.bazel for version switching
cp "${WRITABLE_WORKSPACE}/MODULE.bazel" "${WRITABLE_WORKSPACE}/MODULE.bazel.pristine"

cd "${WRITABLE_WORKSPACE}"

# Test all supported versions sequentially
for version in "18.0.0" "17.0.2" "16.0.0" "15.0.1" "14.0.0"; do
  echo "============================================================"
  echo "Testing Halide version ${version}..."
  echo "============================================================"
  
  # Restore pristine MODULE.bazel
  cp MODULE.bazel.pristine MODULE.bazel
  
  # Configure version
  cat << EOF >> MODULE.bazel

halide = use_extension("@rules_halide//:extensions.bzl", "halide")
halide.toolchain(version = "${version}")
use_repo(halide, "halide_prebuilt_pkg")
EOF

  echo "Running build & test for ${version} with default host toolchain..."
  "${BIT_BAZEL_BINARY}" \
    --output_user_root="${TEST_TMPDIR}/output_user_root" \
    --bazelrc=.bazelrc \
    test \
    --repository_cache="${TEST_TMPDIR}/repository_cache" \
    --test_output=errors \
    //...

  echo "Running build for ${version} with aarch64 cross toolchain..."
  "${BIT_BAZEL_BINARY}" \
    --output_user_root="${TEST_TMPDIR}/output_user_root" \
    --bazelrc=.bazelrc \
    build \
    --repository_cache="${TEST_TMPDIR}/repository_cache" \
    --config=aarch64 \
    //...
done

echo "Success: Integration targets compiled and verified successfully across all Halide versions."
