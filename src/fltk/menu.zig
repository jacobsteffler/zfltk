const std = @import("std");
const c = @import("bindings.zig");
const fl = @import("fltk.zig");
const meta = @import("meta.zig");

pub const parent = @import("widget.zig");
pub const Options = parent.Options;

pub const ItemOptions = struct {
    shortcut: ?fl.Shortcut = null,
    /// Draws a dividing line below the item.
    divider: bool = false,
};

pub fn Methods(comptime Self: type) type {
    return struct {
        /// Adds an item. Submenus are created as needed from the '/' separated `path`,
        /// e.g. "File/Quit". The path is copied.
        ///
        /// `ctx` is a pointer that is handed back to `handler`. It must outlive the menu.
        pub fn add(
            self: *Self,
            path: [:0]const u8,
            opts: ItemOptions,
            ctx: anytype,
            comptime handler: fn (@TypeOf(ctx), *Self) void,
        ) void {
            const thunk = meta.callback(Self, @TypeOf(ctx), handler);
            const shortcut = if (opts.shortcut) |s| s.toInt() else 0;
            const flags: c_int = if (opts.divider) 0x80 else 0;
            _ = c.Fl_Menu_add(self.as(fl.Menu), path, shortcut, thunk, @ptrCast(@constCast(ctx)), flags);
        }

        /// The label of the most recently picked item.
        pub fn text(self: *Self) ?[:0]const u8 {
            return std.mem.span(c.Fl_Menu_text(self.as(fl.Menu)) orelse return null);
        }
    };
}
