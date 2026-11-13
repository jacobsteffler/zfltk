const c = @import("c");

const Window = @This();

ptr: *anyopaque,

pub fn new(w: u32, h: u32, title: [:0]const u8) Window {
    return .{
        .ptr = c.Window_new(@intCast(w), @intCast(h), @constCast(title)).?,
    };
}

pub fn show(self: *const Window) void {
    c.Window_show(self.ptr);
}

pub fn end(self: *const Window) void {
    c.Window_end(self.ptr);
}
