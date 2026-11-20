const c = @import("bindings.zig");
const classes = @import("classes.zig");
const types = @import("types.zig");

pub const Widget = classes.Widget;
pub const Group = classes.Group;
pub const Flex = classes.Flex;
pub const Window = classes.Window;
pub const Button = classes.Button;
pub const Menu = classes.Menu;
pub const MenuBar = classes.MenuBar;

pub const BoxType = types.BoxType;
pub const Color = types.Color;
pub const Shortcut = types.Shortcut;

/// Runs the event loop until every window is closed.
pub fn run() void {
    _ = c.Fl_run();
}
