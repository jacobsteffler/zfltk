#include <FL/Fl.H>
#include <FL/Fl_Button.H>
#include <FL/Fl_Double_Window.H>
#include <FL/Fl_Flex.H>
#include <FL/Fl_Group.H>
#include <FL/Fl_Menu_Bar.H>
#include <FL/Fl_Window.H>

extern "C" const unsigned char FL_FLEX_HORIZONTAL = Fl_Flex::HORIZONTAL;
extern "C" const unsigned char FL_FLEX_VERTICAL = Fl_Flex::VERTICAL;

template <class T>
static T *create(int x, int y, int w, int h, const char *l) noexcept {
    T *t = new T(x, y, w, h);
    Fl_Group::current(nullptr);
    if (l) t->copy_label(l);
    return t;
}

// Fl_Flex only schedules a layout from end(), which explicit parenting never calls.
struct Flex : Fl_Flex {
    using Fl_Flex::Fl_Flex;
    int on_insert(Fl_Widget *, int index) override {
        need_layout(1);
        redraw();
        return index;
    }
};

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
    unsigned char Fl_Widget_type(Fl_Widget *w) noexcept { return w->type(); }
    void Fl_Widget_set_type(Fl_Widget *w, unsigned char t) noexcept { w->type(t); }
    void Fl_Widget_set_callback(Fl_Widget *w, Fl_Callback *cb, void *data) noexcept { w->callback(cb, data); }
    void Fl_Widget_do_callback(Fl_Widget *w) noexcept { w->do_callback(); }

    // Group
    Fl_Group *Fl_Group_new(int x, int y, int w, int h, const char *l) noexcept { return create<Fl_Group>(x, y, w, h, l); }
    void Fl_Group_add(Fl_Group *g, Fl_Widget *w) noexcept { g->add(w); }
    void Fl_Group_set_resizable(Fl_Group *g, Fl_Widget *w) noexcept { g->resizable(w); }

    // Flex
    Fl_Flex *Fl_Flex_new(int x, int y, int w, int h, const char *l) noexcept { return create<Flex>(x, y, w, h, l); }
    void Fl_Flex_fixed(Fl_Flex *f, Fl_Widget *w, int size) noexcept { f->fixed(w, size); }

    // Window
    Fl_Window *Fl_Window_new(int x, int y, int w, int h, const char *l) noexcept { return create<Fl_Double_Window>(x, y, w, h, l); }
    void Fl_Window_free_position(Fl_Window *w) noexcept { w->free_position(); }
    void Fl_Window_set_modal(Fl_Window *w) noexcept { w->set_modal(); }

    // Button
    Fl_Button *Fl_Button_new(int x, int y, int w, int h, const char *l) noexcept { return create<Fl_Button>(x, y, w, h, l); }
    int Fl_Button_value(Fl_Button *b) noexcept { return b->value(); }
    void Fl_Button_set_value(Fl_Button *b, int v) noexcept { b->value(v); }
    void Fl_Button_set_shortcut(Fl_Button *b, int s) noexcept { b->shortcut(s); }

    // Menu
    int Fl_Menu_add(Fl_Menu_ *m, const char *path, int shortcut, Fl_Callback *cb, void *data, int flags) noexcept {
        return m->add(path, shortcut, cb, data, flags);
    }
    const char *Fl_Menu_text(Fl_Menu_ *m) noexcept { return m->text(); }

    // MenuBar
    Fl_Menu_Bar *Fl_Menu_Bar_new(int x, int y, int w, int h, const char *l) noexcept { return create<Fl_Menu_Bar>(x, y, w, h, l); }
}
