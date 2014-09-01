/*!
 * \file include/UI.h
 * \brief Abstract UI interface
 *
 * \author xythobuz
 */

#ifndef _UI_H_
#define _UI_H_

#include <functional>
#include <memory>
#include <vector>

class UI {
public:
    virtual ~UI();

    virtual void display();
    virtual void handleKeyboard(KeyboardButton key, bool pressed);
    virtual void handleText(char *text, bool notFinished);
    virtual void handleAction(ActionEvents action, bool isFinished);
    virtual void handleMouseClick(unsigned int x, unsigned int y, KeyboardButton button, bool released);
    virtual void handleMouseMotion(int xrel, int yrel);
    virtual void handleMouseScroll(int xrel, int yrel);

    virtual bool isOnTop();
    virtual void moveToTop();
    virtual void makeInvisible();

    static void addWindow(UI* window);
    static void removeWindow(UI *window);
    static void displayInOrder();
    static void passKeyboard(KeyboardButton key, bool pressed);
    static void passText(char *text, bool notFinished);
    static void passMouseClick(unsigned int x, unsigned int y, KeyboardButton button, bool released);
    static void passMouseMotion(int xrel, int yrel);
    static void passMouseScroll(int xrel, int yrel);

protected:
    long zPos;

private:
    static void findInList(UI *w, std::function<void (unsigned long i)> func);
    static bool isOnTop(unsigned long windowID);
    static void moveToTop(unsigned long windowID);
    static void makeInvisible(unsigned long windowID);
    static bool compareUIs(UI* a, UI* b);

    static std::vector<UI*> windows;
};

#endif

