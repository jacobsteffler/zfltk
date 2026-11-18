#include <FL/Fl.H>
#include <FL/Fl_Button.H>
#include <FL/Fl_Group.H>
#include <FL/Fl_Menu_Bar.H>
#include <FL/Fl_Window.H>

// Widgets are parented explicitly, so the current group is always left null.
// Labels are copied so callers don't have to keep the string alive.
template <class T>
static T *create(int x, int y, int w, int h, const char *l) noexcept {
    T *t = new T(x, y, w, h);
    Fl_Group::current(nullptr);
    if (l) t->copy_label(l);
    return t;
}

#define NEW(type) \
    type *type##_new(int x, int y, int w, int h, const char *l) noexcept { return create<type>(x, y, w, h, l); }

extern "C" {
    // Core
    int Fl_run() noexcept { return Fl::run(); }
    void Fl_delete_widget(Fl_Widget *w) noexcept { Fl::delete_widget(w); }

    // Widget
    void Fl_Widget_delete(Fl_Widget *w) noexcept { delete w; }
    void Fl_Widget_show(Fl_Widget *w) noexcept { w->show(); }
    void Fl_Widget_hide(Fl_Widget *w) noexcept { w->hide(); }
    void Fl_Widget_redraw(Fl_Widget *w) noexcept { w->redraw(); }
    const char *Fl_Widget_label(Fl_Widget *w) noexcept { return w->label(); }
    void Fl_Widget_copy_label(Fl_Widget *w, const char *l) noexcept { w->copy_label(l); }
    void Fl_Widget_copy_tooltip(Fl_Widget *w, const char *t) noexcept { w->copy_tooltip(t); }
    int Fl_Widget_box(Fl_Widget *w) noexcept { return w->box(); }
    void Fl_Widget_set_box(Fl_Widget *w, int b) noexcept { w->box((Fl_Boxtype)b); }
    Fl_Color Fl_Widget_color(Fl_Widget *w) noexcept { return w->color(); }
    void Fl_Widget_set_color(Fl_Widget *w, Fl_Color c) noexcept { w->color(c); }
    void Fl_Widget_set_callback(Fl_Widget *w, Fl_Callback *cb, void *data) noexcept { w->callback(cb, data); }
    void Fl_Widget_do_callback(Fl_Widget *w) noexcept { w->do_callback(); }

    // Group
    NEW(Fl_Group);
    void Fl_Group_add(Fl_Group *g, Fl_Widget *w) noexcept { g->add(w); }
    void Fl_Group_set_resizable(Fl_Group *g, Fl_Widget *w) noexcept { g->resizable(w); }

    // Window
    NEW(Fl_Window);
    void Fl_Window_free_position(Fl_Window *w) noexcept { w->free_position(); }
    void Fl_Window_set_modal(Fl_Window *w) noexcept { w->set_modal(); }

    // Button
    NEW(Fl_Button);
    int Fl_Button_value(Fl_Button *b) noexcept { return b->value(); }
    void Fl_Button_set_value(Fl_Button *b, int v) noexcept { b->value(v); }
    void Fl_Button_set_shortcut(Fl_Button *b, int s) noexcept { b->shortcut(s); }

    // Menu
    int Fl_Menu_add(Fl_Menu_ *m, const char *path, int shortcut, Fl_Callback *cb, void *data, int flags) noexcept {
        return m->add(path, shortcut, cb, data, flags);
    }
    const char *Fl_Menu_text(Fl_Menu_ *m) noexcept { return m->text(); }

    // MenuBar
    NEW(Fl_Menu_Bar);
}
