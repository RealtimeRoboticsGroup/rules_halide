# rules_halide: Halide Rules for Bazel

`rules_halide` provides Bazel rules to build and run [Halide](https://halide-lang.org/) generators ahead-of-time (AOT) to produce optimized object files and headers, and link them as standard Bazel `cc_library` targets.

## Features

- **Automated Toolchain Setup**: Automatically downloads and configures the prebuilt Halide release for your host platform.
- **Bzlmod Support**: Integrates seamlessly with Bazel's modern Bzlmod dependency system.
- **Cross-Compilation**: Supports cross-compiling Halide generator pipelines to target platforms (e.g. `linux-aarch64` / `macos-arm64`) using Bazel platforms and toolchains.
- **Multi-Platform Support**: Works on `x86_64` Linux, `aarch64` Linux, and `arm64` macOS.

---

## Installation

### 1. Using Bzlmod (Recommended)

Add the following to your `MODULE.bazel` file:

```starlark
bazel_dep(name = "rules_halide", version = "0.0.1")
```

---

## Usage

Here is a step-by-step example of how to define and use a Halide generator in your project.

### 1. Write your Halide Generator

Create a file, e.g., `simple_generator.cc`:

```cpp
#include "Halide.h"

class SimpleScale : public Halide::Generator<SimpleScale> {
public:
    GeneratorParam<float> scale{"scale", 2.0f};

    Input<Halide::Buffer<float, 2>> input{"input"};
    Output<Halide::Buffer<float, 2>> output{"output"};

    Halide::Var x{"x"}, y{"y"};

    void generate() {
        output(x, y) = input(x, y) * scale;
    }
};

HALIDE_REGISTER_GENERATOR(SimpleScale, simple_scale)
```

### 2. Declare the Halide Target in `BUILD.bazel`

Load `halide_library` and define your target:

```starlark
load("@rules_halide//:halide.bzl", "halide_library")
load("@rules_cc//cc:cc_test.bzl", "cc_test")

halide_library(
    name = "simple_scale",
    src = "simple_generator.cc",
    function = "simple_scale",
    args = "scale=2.0",
)

cc_test(
    name = "simple_test",
    srcs = ["simple_test.cc"],
    deps = [
        ":simple_scale",
    ],
)
```

### 3. Use the Generated Code in C++

Include the generated header and use `Halide::Runtime::Buffer`:

```cpp
#include <iostream>
#include "HalideBuffer.h"
#include "simple_scale.h" // generated header

int main() {
    Halide::Runtime::Buffer<float, 2> input(4, 4);
    // ... initialize input ...
    
    Halide::Runtime::Buffer<float, 2> output(4, 4);
    
    // Call the generated ahead-of-time function
    int result = simple_scale(input, output);
    if (result != 0) {
        return result;
    }
    
    std::cout << "Pipeline completed successfully!" << std::endl;
    return 0;
}
```

---

## Cross-Compilation

`rules_halide` uses Bazel platforms and toolchains to determine the proper target architecture when building ahead-of-time pipeline code.

When cross-compiling (for example to `aarch64` Linux using `--platforms=//:my_aarch64_platform` and `toolchains_llvm`), `rules_halide` will automatically invoke the generator with the correct target string (e.g. `target=arm-64-linux`) and produce compatible machine code for your destination platform.

The generator build tool itself will natively compile for your host configuration (e.g. `x86_64` Linux) to run as a code-generation tool during the build.
