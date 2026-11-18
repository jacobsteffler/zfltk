const std = @import("std");
const c = @import("bindings.zig");
const fl = @import("fltk.zig");
const meta = @import("meta.zig");

pub const Options = struct {
    x: ?i32 = null,
    y: ?i32 = null,
    w: ?i32 = null,
    h: ?i32 = null,
    /// Copied, so it doesn't need to outlive the call.
    label: ?[:0]const u8 = null,
    /// Copied, so it doesn't need to outlive the call.
    tooltip: ?[:0]const u8 = null,
    box: ?fl.BoxType = null,
    color: ?fl.Color = null,
};

pub fn apply(self: anytype, opts: anytype) void {
    if (opts.tooltip) |v| self.setTooltip(v);
    if (opts.box) |v| self.setBox(v);
    if (opts.color) |v| self.setColor(v);
}

pub fn Methods(comptime Self: type) type {
    return struct {
        /// Creates a widget without a parent. See `Group.add` to create one inside a group.
        pub fn create(opts: Self.Options) *Self {
            if (!@hasDecl(Self.def, "new")) @compileError(@typeName(Self) ++ " cannot be created directly");
            const self: *Self = Self.def.new(
                opts.x orelse 0,
                opts.y orelse 0,
                opts.w orelse 0,
                opts.h orelse 0,
                if (opts.label) |l| l.ptr else null,
            );
            meta.applyOptions(Self.def, self, opts);
            return self;
        }

        /// Destroys the widget and all of its children. Inside a callback, use `destroyLater`.
        pub fn destroy(self: *Self) void {
            c.Fl_Widget_delete(self.as(fl.Widget));
        }

        /// Hides the widget now and destroys it, with all of its children, once control
        /// is back in the event loop. Safe to call from a callback, even the widget's own.
        pub fn destroyLater(self: *Self) void {
            c.Fl_delete_widget(self.as(fl.Widget));
        }

        /// Casts to a class this one inherits from.
        pub fn as(self: *Self, comptime T: type) *T {
            if (comptime !meta.inherits(Self.def, T.def))
                @compileError(@typeName(Self) ++ " does not inherit from " ++ @typeName(T));
            return @ptrCast(self);
        }

        pub fn show(self: *Self) void {
            c.Fl_Widget_show(self.as(fl.Widget));
        }

        pub fn hide(self: *Self) void {
            c.Fl_Widget_hide(self.as(fl.Widget));
        }

        pub fn redraw(self: *Self) void {
            c.Fl_Widget_redraw(self.as(fl.Widget));
        }

        pub fn label(self: *Self) [:0]const u8 {
            return std.mem.span(c.Fl_Widget_label(self.as(fl.Widget)) orelse "");
        }

        /// The text is copied, so it doesn't need to outlive the call.
        pub fn setLabel(self: *Self, text: ?[:0]const u8) void {
            c.Fl_Widget_copy_label(self.as(fl.Widget), if (text) |t| t.ptr else null);
        }

        /// The text is copied, so it doesn't need to outlive the call.
        pub fn setTooltip(self: *Self, text: ?[:0]const u8) void {
            c.Fl_Widget_copy_tooltip(self.as(fl.Widget), if (text) |t| t.ptr else null);
        }

        pub fn box(self: *Self) fl.BoxType {
            return c.Fl_Widget_box(self.as(fl.Widget));
        }

        pub fn setBox(self: *Self, box_type: fl.BoxType) void {
            c.Fl_Widget_set_box(self.as(fl.Widget), box_type);
        }

        pub fn color(self: *Self) fl.Color {
            return c.Fl_Widget_color(self.as(fl.Widget));
        }

        pub fn setColor(self: *Self, background: fl.Color) void {
            c.Fl_Widget_set_color(self.as(fl.Widget), background);
        }

        /// `ctx` is a pointer that is handed back to `handler`. It must outlive the widget.
        pub fn setCallback(
            self: *Self,
            ctx: anytype,
            comptime handler: fn (@TypeOf(ctx), *Self) void,
        ) void {
            const thunk = meta.callback(Self, @TypeOf(ctx), handler);
            c.Fl_Widget_set_callback(self.as(fl.Widget), thunk, @ptrCast(@constCast(ctx)));
        }

        /// Runs the callback as if the user had triggered it.
        pub fn doCallback(self: *Self) void {
            c.Fl_Widget_do_callback(self.as(fl.Widget));
        }
    };
}
