const std = @import("std");
const fl = @import("fltk");

pub fn main() void {

    const w = fl.new(.window, .{.w = 500, .h = 500, .l = "Hello"});

    const btn = fl.new(.button, .{});
    btn.show();

    w.show();
    fl.run();
}
