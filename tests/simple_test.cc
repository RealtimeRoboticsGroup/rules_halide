#include <iostream>
#include "HalideBuffer.h"
#include "tests/simple_scale.h"

#define ASSERT_EQ(val1, val2) \
    do { \
        if ((val1) != (val2)) { \
            std::cerr << "Assertion failed: " << #val1 << " == " << #val2 \
                      << " (" << (val1) << " vs " << (val2) << ") at " \
                      << __FILE__ << ":" << __LINE__ << std::endl; \
            return 1; \
        } \
    } while(0)

int main() {
    Halide::Runtime::Buffer<float, 2> input(4, 4);
    for (int y = 0; y < 4; ++y) {
        for (int x = 0; x < 4; ++x) {
            input(x, y) = static_cast<float>(x + y * 4);
        }
    }
    
    Halide::Runtime::Buffer<float, 2> output(4, 4);
    
    int result = simple_scale(input, output);
    ASSERT_EQ(result, 0);
    
    for (int y = 0; y < 4; ++y) {
        for (int x = 0; x < 4; ++x) {
            std::cout << "input(" << x << ", " << y << ") = " << input(x, y)
                      << ", output(" << x << ", " << y << ") = " << output(x, y) << std::endl;
            ASSERT_EQ(output(x, y), input(x, y) * 2.0f);
        }
    }
    std::cout << "SimpleScale test passed!" << std::endl;
    return 0;
}
