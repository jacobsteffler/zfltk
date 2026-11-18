const c = @import("bindings.zig");

pub const new = c.Fl_Menu_Bar_new;
pub const parent = @import("menu.zig");
pub const Options = parent.Options;
