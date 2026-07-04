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
