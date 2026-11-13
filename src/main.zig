const std = @import("std");
const fltk = @import("fltk");

const Window = fltk.Window;

pub fn main() void {
    const win: Window = .new(640, 480, "Test!");
    win.end();
    win.show();
    fltk.run();
}
