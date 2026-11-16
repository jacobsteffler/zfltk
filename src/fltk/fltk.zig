const c = @import("bindings.zig");

const widget = @import("widget.zig");

pub const new = widget.new;

pub fn run() void {
    c.Fl_run();
}
