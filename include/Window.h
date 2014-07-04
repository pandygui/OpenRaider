/*!
 * \file include/Window.h
 * \brief Windowing interface
 *
 * \author xythobuz
 */

#ifndef _WINDOW_H_
#define _WINDOW_H_

/*!
 * \brief Windowing interface
 */
class Window {
public:

    virtual ~Window() {}

    virtual void setSize(unsigned int width, unsigned int height) = 0;

    virtual void setFullscreen(bool fullscreen) = 0;

    virtual void setMousegrab(bool grab) = 0;

    virtual int initialize() = 0;

    virtual void eventHandling() = 0;

    virtual void setTextInput(bool on) = 0;

    virtual void delay(unsigned int ms) = 0;

    virtual void swapBuffersGL() = 0;

    virtual unsigned int getWidth();

    virtual unsigned int getHeight();

    virtual int initializeGL();

    virtual void resizeGL();

    virtual void glEnter2D();

    virtual void glExit2D();

protected:
    bool mInit;
    bool mFullscreen;
    bool mMousegrab;
    unsigned int mWidth;
    unsigned int mHeight;
};

Window &getWindow();

#endif

