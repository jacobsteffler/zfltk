const c = @import("bindings.zig");
const fl = @import("fltk.zig");

pub const new = c.Fl_Group_new;
pub const parent = @import("widget.zig");
pub const Options = parent.Options;

pub fn Methods(comptime Self: type) type {
    return struct {
        /// Creates a `T` as the last child of this group.
        pub fn add(self: *Self, comptime T: type, opts: T.Options) *T {
            const child = T.create(opts);
            self.adopt(child);
            return child;
        }

        /// Makes an existing widget the last child of this group, removing it from its old parent.
        pub fn adopt(self: *Self, child: anytype) void {
            c.Fl_Group_add(self.as(fl.Group), child.as(fl.Widget));
        }

        /// The child that absorbs the size change when this group is resized.
        /// Passing the group itself resizes all children proportionally.
        /// Passing null keeps every child at its size and position.
        pub fn setResizable(self: *Self, child: anytype) void {
            const widget: ?*fl.Widget = switch (@typeInfo(@TypeOf(child))) {
                .null => null,
                .optional => if (child) |ch| ch.as(fl.Widget) else null,
                else => child.as(fl.Widget),
            };
            c.Fl_Group_set_resizable(self.as(fl.Group), widget);
        }
    };
}
