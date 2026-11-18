const c = @import("bindings.zig");
const fl = @import("fltk.zig");
const meta = @import("meta.zig");

pub const new = c.Fl_Button_new;
pub const parent = @import("widget.zig");
pub const Options = meta.Merge(parent.Options, struct {
    shortcut: ?fl.Shortcut = null,
});

pub fn apply(self: anytype, opts: anytype) void {
    if (opts.shortcut) |v| self.setShortcut(v);
}

pub fn Methods(comptime Self: type) type {
    return struct {
        pub fn value(self: *Self) bool {
            return c.Fl_Button_value(self.as(fl.Button)) != 0;
        }

        pub fn setValue(self: *Self, on: bool) void {
            c.Fl_Button_set_value(self.as(fl.Button), @intFromBool(on));
        }

        pub fn setShortcut(self: *Self, shortcut: fl.Shortcut) void {
            c.Fl_Button_set_shortcut(self.as(fl.Button), shortcut.toInt());
        }
    };
}
