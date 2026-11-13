const c = @import("c");

const Window = @This();

ptr: *anyopaque,

pub fn new() Window {
    return .{
        .ptr = c.Window_new().?,
    };
}

pub fn show(self: *const Window) void {
    c.Window_show(self.ptr);
}

pub fn end(self: *const Window) void {
    c.Window_end(self.ptr);
}
