#include <FL/Fl_Button.H>
#include <FL/Fl_Window.H>

#define INHERITS(child, parent) \
    parent *child##_as_##parent(child *c) { return c; }

// TODO noexcept

extern "C" {

    // Core
    extern "C" void Fl_run() { Fl::run(); }

    // Widget
    extern "C" void Fl_Widget_show(Fl_Widget *w) { w->show(); }

    // Window
    INHERITS(Fl_Window, Fl_Widget);
    extern "C" Fl_Window *Fl_Window_new(int w, int h, char *l) { return new Fl_Window(500, 400, "Test"); }

    // Button
    INHERITS(Fl_Button, Fl_Widget);
    extern "C" Fl_Button *Fl_Button_new() { return new Fl_Button(0, 0, 150, 150, "Test!"); }
}
