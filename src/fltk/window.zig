const c = @import("c");

pub const Window = struct {
    ptr: *anyopaque,
};

pub fn init() Window {
    return .{
        .ptr = c.Window_new().?,
    };
}
