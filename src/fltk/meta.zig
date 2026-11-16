const std = @import("std");
const c = @import("bindings.zig");
const widget = @import("widget.zig");

pub fn cast(handle: anytype, comptime Parent: type) *Parent {
    const ChildHandle = @TypeOf(handle);
    const Child = @typeInfo(ChildHandle).pointer.child;
    const childName = comptime baseName(Child);
    const parentName = comptime baseName(Parent);
    const castName = childName ++ "_as_" ++ parentName;
    const castFn = @field(c, castName);
    return castFn(handle);
}

pub fn baseName(comptime T: type) []const u8 {
    const name = @typeName(T);
    const idx = std.mem.findLast(u8, name, ".").?;
    return name[idx+1..];
}
