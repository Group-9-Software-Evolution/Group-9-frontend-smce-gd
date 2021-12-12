#include <iostream>
#include <SMCE_framebuffer.hpp>
#include "MKRRGBMatrix.h"

RGBMatrixClass MATRIX;


RGBMatrixClass::RGBMatrixClass(): ArduinoGraphics {RGB_MATRIX_HEIGHT, RGB_MATRIX_WIDTH}, m_framebuffer{0} {}

int RGBMatrixClass::begin() {
    if (!ArduinoGraphics::begin()) {
        return 0;
    }
    m_framebuffer.begin(RGB_MATRIX_HEIGHT, RGB_MATRIX_WIDTH);
    return 1;
}

void RGBMatrixClass::end() {
    ArduinoGraphics::end();

    m_framebuffer.end();
}

void RGBMatrixClass::endDraw()
{
    ArduinoGraphics::endDraw();

}

void RGBMatrixClass::set(int x, int y, uint8_t r, uint8_t g, uint8_t b)
{
    m_framebuffer.set(x, y, r, g, b);
}
