const builtin = @import("builtin");

pub const BoxType = enum(c_int) {
    none = 0,
    flat,
    up,
    down,
    up_frame,
    down_frame,
    thin_up,
    thin_down,
    thin_up_frame,
    thin_down_frame,
    engraved,
    embossed,
    engraved_frame,
    embossed_frame,
    border,
    border_frame = 16,
    _,
};

pub const Color = enum(c_uint) {
    foreground = 0,
    background2 = 7,
    inactive = 8,
    selection = 15,
    background = 49,
    black = 56,
    green = 63,
    red = 88,
    yellow = 95,
    blue = 216,
    cyan = 223,
    magenta = 248,
    white = 255,
    _,

    pub fn rgb(r: u8, g: u8, b: u8) Color {
        // 0 is the foreground color index, so pure black has to use the palette.
        if (r == 0 and g == 0 and b == 0) return .black;
        return @fromBackingInt(@intCast(@as(c_uint, r) << 24 | @as(c_uint, g) << 16 | @as(c_uint, b) << 8));
    }
};

pub const Shortcut = struct {
    key: u16,
    shift: bool = false,
    ctrl: bool = false,
    alt: bool = false,
    meta: bool = false,
    /// Cmd on macOS, Ctrl everywhere else.
    command: bool = false,

    pub fn toInt(self: Shortcut) c_int {
        const command = self.command;
        const mac = builtin.os.tag == .macos;
        var result: c_int = self.key;
        if (self.shift) result |= 0x00010000;
        if (self.ctrl or (command and !mac)) result |= 0x00040000;
        if (self.alt) result |= 0x00080000;
        if (self.meta or (command and mac)) result |= 0x00400000;
        return result;
    }
};
