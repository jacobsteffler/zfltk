const c = @import("bindings.zig");
const fl = @import("fltk.zig");
const meta = @import("meta.zig");

pub const new = c.Fl_Window_new;
pub const parent = @import("group.zig");
pub const Options = meta.Merge(parent.Options, struct {
    modal: bool = false,
});

pub fn apply(self: anytype, opts: anytype) void {
    if (opts.x == null and opts.y == null) c.Fl_Window_free_position(self.as(fl.Window));
    if (opts.modal) self.setModal();
}

pub fn Methods(comptime Self: type) type {
    return struct {
        pub fn setModal(self: *Self) void {
            c.Fl_Window_set_modal(self.as(fl.Window));
        }
    };
}
