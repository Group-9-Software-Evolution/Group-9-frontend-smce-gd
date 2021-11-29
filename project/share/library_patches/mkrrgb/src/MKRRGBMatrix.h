//
// Created by Adam on 2021-11-18.
//

#ifndef GODOT_SMCE_MKRRGBMATRIX_H
#define GODOT_SMCE_MKRRGBMATRIX_H

#ifndef _MKR_RGB_MATRIX_H
#define _MKR_RGB_MATRIX_H

#include <ArduinoGraphics.h>
#include <SMCE_framebuffer.hpp>

#define RGB_MATRIX_WIDTH  600
#define RGB_MATRIX_HEIGHT 400

class RGBMatrixClass : public ArduinoGraphics {
  public:
    RGBMatrixClass();
    int begin();
    void end();

    virtual void endDraw();
    virtual void set(int x, int y, uint8_t r, uint8_t g, uint8_t b);

  private:
    SMCE_Framebuffer m_framebuffer;
};

extern RGBMatrixClass MATRIX;

#endif

#endif // GODOT_SMCE_MKRRGBMATRIX_H
