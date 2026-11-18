const c = @import("bindings.zig");
const fl = @import("fltk.zig");

/// A struct with the fields of `Base` followed by the fields of `Ext`.
/// A field in `Ext` replaces the field of the same name in `Base`.
pub fn Merge(comptime Base: type, comptime Ext: type) type {
    const base = @typeInfo(Base).@"struct";
    const ext = @typeInfo(Ext).@"struct";

    var names: @TypeOf(base.field_names) = &.{};
    var types: @TypeOf(base.field_types) = &.{};
    var attrs: @TypeOf(base.field_attrs) = &.{};
    for (base.field_names, base.field_types, base.field_attrs) |name, T, attr| {
        if (@hasField(Ext, name)) continue;
        names = names ++ .{name};
        types = types ++ .{T};
        attrs = attrs ++ .{attr};
    }

    return @Struct(
        .auto,
        null,
        names ++ ext.field_names,
        types ++ ext.field_types,
        attrs ++ ext.field_attrs,
    );
}

/// Whether `def` is `base` or has it somewhere in its parent chain.
pub fn inherits(comptime def: type, comptime base: type) bool {
    if (def == base) return true;
    return @hasDecl(def, "parent") and inherits(def.parent, base);
}

/// Calls `apply` for every def in the parent chain, base first.
pub fn applyOptions(comptime def: type, self: anytype, opts: anytype) void {
    if (@hasDecl(def, "parent")) applyOptions(def.parent, self, opts);
    if (@hasDecl(def, "apply")) def.apply(self, opts);
}

/// Wraps `handler` in a C callback. The callback's user data must be a `Ctx`.
pub fn callback(
    comptime Self: type,
    comptime Ctx: type,
    comptime handler: fn (Ctx, *Self) void,
) *const c.Callback {
    return &struct {
        fn call(w: *fl.Widget, data: ?*anyopaque) callconv(.c) void {
            handler(@ptrCast(@alignCast(data)), @ptrCast(w));
        }
    }.call;
}
