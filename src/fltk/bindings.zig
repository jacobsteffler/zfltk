pub const Fl_Widget = opaque {};
pub const Fl_Window = opaque {};
pub const Fl_Button = opaque {};

// Core
pub extern fn Fl_run() void;

// Widget
pub extern fn Fl_Widget_show(*Fl_Widget) void;

// Window
pub extern fn Fl_Window_new(c_int, c_int, [*c]u8) *Fl_Window;
pub extern fn Fl_Window_as_Fl_Widget(*Fl_Window) *Fl_Widget;

// Button
pub extern fn Fl_Button_new() *Fl_Button;
pub extern fn Fl_Button_as_Fl_Widget(*Fl_Button) *Fl_Widget;
