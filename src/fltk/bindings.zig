const fl = @import("fltk.zig");

pub const Callback = fn (*fl.Widget, ?*anyopaque) callconv(.c) void;

pub extern const FL_FLEX_HORIZONTAL: u8;
pub extern const FL_FLEX_VERTICAL: u8;

// Core
pub extern fn Fl_run() c_int;
pub extern fn Fl_delete_widget(*fl.Widget) void;

// Widget
pub extern fn Fl_Widget_delete(*fl.Widget) void;
pub extern fn Fl_Widget_show(*fl.Widget) void;
pub extern fn Fl_Widget_hide(*fl.Widget) void;
pub extern fn Fl_Widget_redraw(*fl.Widget) void;
pub extern fn Fl_Widget_label(*fl.Widget) ?[*:0]const u8;
pub extern fn Fl_Widget_copy_label(*fl.Widget, ?[*:0]const u8) void;
pub extern fn Fl_Widget_copy_tooltip(*fl.Widget, ?[*:0]const u8) void;
pub extern fn Fl_Widget_box(*fl.Widget) fl.BoxType;
pub extern fn Fl_Widget_set_box(*fl.Widget, fl.BoxType) void;
pub extern fn Fl_Widget_color(*fl.Widget) fl.Color;
pub extern fn Fl_Widget_set_color(*fl.Widget, fl.Color) void;
pub extern fn Fl_Widget_type(*fl.Widget) u8;
pub extern fn Fl_Widget_set_type(*fl.Widget, u8) void;
pub extern fn Fl_Widget_set_callback(*fl.Widget, *const Callback, ?*anyopaque) void;
pub extern fn Fl_Widget_do_callback(*fl.Widget) void;

// Group
pub extern fn Fl_Group_new(c_int, c_int, c_int, c_int, ?[*:0]const u8) *fl.Group;
pub extern fn Fl_Group_add(*fl.Group, *fl.Widget) void;
pub extern fn Fl_Group_set_resizable(*fl.Group, ?*fl.Widget) void;

// Flex
pub extern fn Fl_Flex_new(c_int, c_int, c_int, c_int, ?[*:0]const u8) *fl.Flex;
pub extern fn Fl_Flex_fixed(*fl.Flex, *fl.Widget, c_int) void;

// Window
pub extern fn Fl_Window_new(c_int, c_int, c_int, c_int, ?[*:0]const u8) *fl.Window;
pub extern fn Fl_Window_free_position(*fl.Window) void;
pub extern fn Fl_Window_set_modal(*fl.Window) void;

// Button
pub extern fn Fl_Button_new(c_int, c_int, c_int, c_int, ?[*:0]const u8) *fl.Button;
pub extern fn Fl_Button_set_shortcut(*fl.Button, c_int) void;

// Menu
pub extern fn Fl_Menu_add(*fl.Menu, [*:0]const u8, c_int, *const Callback, ?*anyopaque, c_int) c_int;
pub extern fn Fl_Menu_text(*fl.Menu) ?[*:0]const u8;

// MenuBar
pub extern fn Fl_Menu_Bar_new(c_int, c_int, c_int, c_int, ?[*:0]const u8) *fl.MenuBar;
