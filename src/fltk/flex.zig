const c = @import("bindings.zig");
const fl = @import("fltk.zig");
const meta = @import("meta.zig");

pub const Direction = enum {
    horizontal,
    vertical,
};

pub const new = c.Fl_Flex_new;
pub const parent = @import("group.zig");
pub const Options = meta.Merge(parent.Options, struct {
    direction: Direction,
});

pub fn apply(self: anytype, opts: anytype) void {
    switch (opts.direction) {
        .horizontal => self.setSubtype(c.FL_FLEX_HORIZONTAL),
        .vertical => self.setSubtype(c.FL_FLEX_VERTICAL),
    }
}

pub fn Methods(comptime Self: type) type {
    return struct {
        pub fn add(self: *Self, comptime T: type, size: ?i32, opts: T.Options) *T {
            const child = T.create(opts);
            self.adopt(child);
            if (size) |s| self.setFixed(child, s);
            return child;
        }

        pub fn setFixed(self: *Self, child: anytype, size: i32) void {
            c.Fl_Flex_fixed(self.as(fl.Flex), child.as(fl.Widget), size);
        }
    };
}
