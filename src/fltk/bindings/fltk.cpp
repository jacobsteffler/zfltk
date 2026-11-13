#include <FL/Fl_Window.H>

extern "C" Fl_Window *Window_new() {
    return new Fl_Window(300, 100, "Hi");
}

extern "C" void Window_show(Fl_Window *w) {
    w->show();
}

extern "C" void Window_end(Fl_Window *w) {
    w->end();
}

extern "C" void run() {
    Fl::run();
}
