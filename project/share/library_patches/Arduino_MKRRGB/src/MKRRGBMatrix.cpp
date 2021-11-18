#include <SMCE_framebuffer.hpp>

int RGBMatrixClass::begin() {
    if (!ArduinoGraphics::begin()) {
        return 0;
    }

    return m_framebuffer.begin();
}

void RGBMatrixClass::end() {
    ArduinoGraphics::end();

    m_framebuffer.end();
}

void RGBMatrixClass::endDraw()
{
    ArduinoGraphics::endDraw();

    SPI_MATRIX.transfer(_buffer, sizeof(_buffer));
}

void RGBMatrixClass::set(int x, int y, uint8_t r, uint8_t g, uint8_t b)
{
    m_framebuffer.set(x, y, r, g, b);
}