const std = @import("std");
const fltk = @import("fltk");

const Window = fltk.Window;

pub fn main() void {
    const win: Window = .new();
    win.end();
    win.show();
    fltk.run();
}
