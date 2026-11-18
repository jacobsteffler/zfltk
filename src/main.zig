const std = @import("std");
const fl = @import("fltk");

const App = struct {
    window: *fl.Window,
    clicks: u32 = 0,

    fn onClick(app: *App, button: *fl.Button) void {
        app.clicks += 1;
        var buf: [32]u8 = undefined;
        button.setLabel(std.mem.printSentinel(&buf, "Clicked {d}", .{app.clicks}, 0) catch unreachable);
    }

    fn onQuit(app: *App, _: *fl.MenuBar) void {
        app.window.hide();
    }
};

pub fn main() void {
    const win = fl.Window.create(.{ .w = 400, .h = 300, .label = "Hello" });
    defer win.destroy();

    var app: App = .{ .window = win };

    const menu = win.add(fl.MenuBar, .{ .w = 400, .h = 25 });
    menu.add("File/Quit", .{ .shortcut = .{ .key = 'q', .command = true }, .divider = true }, &app, App.onQuit);
    menu.add("File/Test", .{}, &app, App.onQuit);

    const button = win.add(fl.Button, .{
        .x = 125,
        .y = 125,
        .w = 150,
        .h = 50,
        .label = "Click me",
        .tooltip = "Hello from a tooltip",
    });
    button.setCallback(&app, App.onClick);

    win.setResizable(button);
    win.setResizable(win);

    win.show();
    fl.run();
}
