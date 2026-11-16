const std = @import("std");
const c = @import("bindings.zig");
const meta = @import("meta.zig");

pub const Kind = enum {
    window,
    button,
};

pub fn new(comptime kind: Kind, options: Options(kind)) Widget(kind) {
    // TODO accept options parameter of type Options(Kind)
    // Options(Kind) is a type-specific options struct.
    // Options(Kind) has two functions:
    // - toCtorArgs() -> produces array of args to pass to th e ctor with @args
    // - applyOpiton() -> applies all fields of Options(Kind) that aren't handled by the ctor
    // TODO also do more autogeneration:
    // - CPP macro for conversion functions
    // - Optionally generate zig bindings for conversion functions with @extern()
    // - Can probably do at least one of the above for constructors too
    // -- (Maybe not in CPP because the ctor arguments are variable)



    const ctor = constructor(kind);
    const args = options.toCtorArgs();
    const handle = @call(.auto, ctor, args);

    // TODO more initialization

    return .{ .handle = handle };
}

fn Widget(comptime kind: Kind) type {
    return struct {
        handle: Handle(kind),

        const Self = @This();

        pub fn show(self: Self) void {
            const widget_handle = meta.cast(self.handle, c.Fl_Widget);
            c.Fl_Widget_show(widget_handle);
        }
    };
}

fn constructor(comptime kind: Kind) CtorFn(kind) {
    return @field(c, ctorName(kind));
}

fn ctorName(comptime kind: Kind) []const u8 {
    const HandleType = Handle(kind);
    const CppType = @typeInfo(HandleType).pointer.child;
    const cppTypeName = comptime meta.baseName(CppType);
    return cppTypeName ++ "_new";
}

fn CtorFn(comptime kind: Kind) type {
    return @TypeOf(@field(c, ctorName(kind)));
}

pub fn Handle(comptime kind: Kind) type {
    return switch (kind) {
        .button => *c.Fl_Button,
        .window => *c.Fl_Window,
    };
}

fn CtorArgs(comptime kind: Kind) type {
    const ctor = CtorFn(kind);
    return std.meta.ArgsTuple(ctor);
}

fn Options(comptime kind: Kind) type {
    return switch (kind) {
        .window => WindowOptions,
        .button => struct { pub fn toCtorArgs(self: @This()) CtorArgs(.button) { _=self; return .{}; } },
    };
}

const WindowOptions = struct {
    w: c_int,
    h: c_int,
    l: [:0]const u8,

    pub fn toCtorArgs(self: @This()) CtorArgs(.window) {
        return .{ self.w, self.h, @constCast(self.l) };
    }
};
