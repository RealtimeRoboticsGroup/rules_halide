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

cd "${WRITABLE_WORKSPACE}"

echo "Running build & test with default host toolchain..."
"${BIT_BAZEL_BINARY}" \
  --output_user_root="${TEST_TMPDIR}/output_user_root" \
  --bazelrc=.bazelrc \
  test \
  --repository_cache="${TEST_TMPDIR}/repository_cache" \
  --test_output=errors \
  //...

echo "Running build with aarch64 cross toolchain..."
"${BIT_BAZEL_BINARY}" \
  --output_user_root="${TEST_TMPDIR}/output_user_root" \
  --bazelrc=.bazelrc \
  build \
  --repository_cache="${TEST_TMPDIR}/repository_cache" \
  --config=aarch64 \
  //...

echo "Reconfiguring integration workspace to use Halide version 14.0.0..."
cat << 'EOF' >> MODULE.bazel

halide = use_extension("@rules_halide//:extensions.bzl", "halide")
halide.toolchain(version = "14.0.0")
use_repo(halide, "halide_prebuilt_pkg")
EOF

# Fetch and build using the alternative version to verify dynamic toolchain switching works
echo "Running build & test with Halide 14.0.0..."
"${BIT_BAZEL_BINARY}" \
  --output_user_root="${TEST_TMPDIR}/output_user_root" \
  --bazelrc=.bazelrc \
  test \
  --repository_cache="${TEST_TMPDIR}/repository_cache" \
  --test_output=errors \
  //...

echo "Success: Integration targets compiled and verified successfully across multiple Halide versions."
