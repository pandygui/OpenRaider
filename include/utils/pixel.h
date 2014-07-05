/*!
 * \file include/utils/pixel.h
 * \brief Pixel buffer utilities
 *
 * \author xythobuz
 */

#ifndef _UTILS_PIXEL_H_
#define _UTILS_PIXEL_H_

unsigned char *generateColorTexture(const unsigned char *rgba, unsigned int width,
        unsigned int height, unsigned int bpp);

void bgr2rgb24(unsigned char *image, unsigned int w, unsigned int h);
void bgra2rgba32(unsigned char *image, unsigned int w, unsigned int h);
void argb2rgba32(unsigned char *image, unsigned int w, unsigned int h);

unsigned char *scaleBuffer(unsigned char *image, unsigned int *w, unsigned int *h, unsigned int bpp);

#endif
