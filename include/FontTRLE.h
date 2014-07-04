/*!
 * \file include/FontTRLE.h
 * \brief Tomb Raider Level Editor Font loader
 *
 * \author xythobuz
 */

#ifndef _FONT_TRLE_H_
#define _FONT_TRLE_H_

#include "Font.h"

/*!
 * \brief Tomb Raider Level Editor Font loader
 */
class FontTRLE : public Font {
public:

    /*!
     * \brief Constructs an object of FontTRLE
     */
    FontTRLE();

    /*!
     * \brief Deconstructs an object of FontTRLE
     */
    virtual ~FontTRLE();

    virtual int initialize();

    virtual void writeString(FontString &s);

private:

    void loadLPS(const char *f);
    void writeChar(unsigned int index, unsigned int xDraw, FontString &s);

    unsigned int mFontTexture;

    // 106 entries: (x, y, w, h, offset)
    int offsets[106][5] = {
        { 174,  52,   3,  12, -11 },
        {  98,  58,   6,   4, -10 },
        {  82,  26,  13,  11, -10 },
        {  78,  38,   9,  13, -10 },
        { 214,  13,  14,  11, -9  },
        {  40,  26,  13,  11, -10 },
        { 157,  57,   5,   6, -11 },
        { 204,  39,   5,  15, -12 },
        {  34,  40,   5,  15, -12 },
        { 184,  59,   4,   4, -11 },
        {  22,  40,  10,  10, -9  },
        { 178,  59,   4,   4, -2  },
        { 106,  60,   7,   2, -4  },
        { 114,  60,   4,   3, -2  },
        { 212,  38,   8,  14, -12 },
        {  88,  49,   9,   9, -8  },
        { 200,  55,   5,   9, -8  },
        {  46,  52,   8,   9, -8  },
        {  88,  38,   7,  10, -8  },
        {  62,  40,  10,  10, -8  },
        { 142,  48,   8,  11, -9  },
        { 232,  50,   8,  10, -9  },
        { 120,  47,   8,  11, -9  },
        {  22,  51,   8,  10, -9  },
        { 110,  49,   8,  10, -8  },
        { 152,  57,   4,   7, -7  },
        { 136,  57,   4,   9, -7  },
        { 178,  40,  11,   9, -8  },
        { 210,  53,  10,   6, -7  },
        { 240,  40,  11,   9, -7  },
        {  12,  39,   9,  12, -11 },
        {  66,  13,  15,  13, -10 },
        { 130,  13,  13,  12, -11 },
        { 214,  25,  12,  12, -11 },
        { 132,  35,  10,  12, -11 },
        {   0,  26,  12,  12, -11 },
        {  14,  26,  12,  12, -11 },
        {  66,  27,  11,  12, -11 },
        { 182,  27,  11,  12, -11 },
        { 200,  13,  13,  12, -11 },
        { 222,  54,   4,  12, -11 },
        {  56,  52,   4,  15, -11 },
        { 230,  15,  12,  12, -11 },
        { 144,  35,  10,  12, -11 },
        {  48,  13,  17,  12, -11 },
        { 144,  13,  13,  12, -11 },
        {  54,  26,  11,  12, -11 },
        { 200,  26,  11,  12, -11 },
        { 240,   0,  13,  14, -11 },
        { 158,  13,  13,  12, -11 },
        { 156,  35,  10,  12, -11 },
        { 172,  13,  13,  12, -11 },
        {  98,  13,  14,  12, -11 },
        {  82,  13,  14,  12, -11 },
        {  24,  13,  22,  12, -11 },
        { 186,  13,  12,  13, -11 },
        { 114,  13,  14,  12, -11 },
        { 228,  28,  11,  12, -11 },
        {  62,  60,   5,   3, -4  },
        { 248,  59,   5,   3, -4  },
        {  88,  59,   7,   3, -4  },
        { 142,  60,   6,   2, -3  },
        { 120,  59,   7,   3, -4  },
        { 242,  59,   4,   4, -11 },
        {  98,  49,  10,   8, -7  },
        {  96,  35,  10,  13, -12 },
        {  72,  52,   8,   8, -7  },
        {   0,  39,  10,  11, -10 },
        { 164,  52,   8,   8, -7  },
        { 168,  38,   9,  13, -12 },
        { 120,  35,  11,  11, -7  },
        { 108,  35,  10,  13, -12 },
        { 194,  27,   5,  11, -10 },
        {  40,  51,   5,  15, -10 },
        {  28,  26,  11,  13, -12 },
        {  82,  52,   5,  12, -11 },
        {  96,  26,  17,   8, -7  },
        { 152,  48,  11,   8, -7  },
        {  62,  51,   9,   8, -7  },
        { 244,  15,  10,  12, -7  },
        {  52,  39,   9,  12, -7  },
        {  10,  52,   9,   8, -7  },
        { 190,  52,   8,   8, -7  },
        {   0,  51,   8,  10, -9  },
        { 178,  50,  10,   8, -7  },
        { 130,  48,  11,   8, -7  },
        { 132,  26,  17,   8, -7  },
        { 242,  50,  10,   8, -7  },
        {  40,  38,  10,  12, -7  },
        { 232,  41,   7,   8, -7  },
        { 222,  41,   8,  12, -7  },
        { 130,  57,   5,   8, -7  },
        { 194,  39,   9,  12, -10 },
        {  32,  56,   4,  11, -10 },
        {   1,  14,  22,  11, -10 },
        { 192,   0,  23,  13, -10 },
        { 168,   0,  23,  12, -10 },
        { 216,   0,  23,  12, -10 },
        { 150,  26,  17,   8, -8  },
        { 168,  26,  11,  11, -9  },
        { 114,  26,  17,   8, -8  },
        { 240,  28,  12,  11, -9  },
        {   0,   0,  40,  12, -10 },
        {  84,   0,  39,  11, -10 },
        {  42,   0,  39,  11, -10 },
        { 126,   0,  39,  11, -10 },
    };
};

#endif

