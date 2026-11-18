//! Every class, by its public name. `zig build gen` turns this list into classes.zig.
//!
//! A def is a namespace with:
//!   parent   the def it inherits from (all but Widget)
//!   Options  the struct accepted by `create`
//!   new      the C constructor (concrete classes only)
//!   apply    applies the options this def adds (optional)
//!   Methods  the methods this def adds (optional)
//!
//! Any other public declaration, e.g. `Menu.ItemOptions`, is aliased onto the class
//! and the classes that inherit from it.

pub const Widget = @import("widget.zig");
pub const Group = @import("group.zig");
pub const Window = @import("window.zig");
pub const Button = @import("button.zig");
pub const Menu = @import("menu.zig");
pub const MenuBar = @import("menubar.zig");
