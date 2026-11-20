const std = @import("std");
const fl = @import("fltk");

pub fn main() void {
    const win = fl.Window.create(.{ .w = 640, .h = 480, .label = "Hello" });

    const flex = win.add(fl.Flex, .{ .w = 640, .h = 480, .direction = .vertical });
    _ = flex.add(fl.Group, 22, .{ .box = .up });
    _ = flex.add(fl.Group, null, .{ .box = .up });
    _ = flex.add(fl.Group, 22, .{ .box = .up });

    win.setResizable(flex);
    win.show();
    fl.run();
}
