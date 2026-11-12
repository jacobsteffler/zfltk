#include <FL/Fl_Window.H>

extern "C" void *Window_new() {
    return new Fl_Window(300, 100, "Hi");
}
