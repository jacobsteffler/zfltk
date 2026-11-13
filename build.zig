const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});

    const os = b.graph.host.result.os.tag;
    const msvc: std.Target.Query = .{ .abi = .msvc };
    const target = if (os == .windows)
        b.standardTargetOptions(.{
            .whitelist = &.{ msvc },
            .default_target = msvc,
        })
    else b.standardTargetOptions(.{});

    const cmake_conf = b.addSystemCommand(&.{ "cmake", "--log-level=WARNING" });
    cmake_conf.addDirectoryArg2(b.path("fltk"), .{});
    cmake_conf.addArgs(&.{
        "-DCMAKE_BUILD_TYPE=Release",
        "-DFLTK_MSVC_RUNTIME_DLL=OFF",
        "-DFLTK_BUILD_FLTK_OPTIONS=OFF",
        "-DFLTK_BUILD_GL=OFF",
        "-DFLTK_BUILD_FLUID=OFF",
        "-DFLTK_BUILD_FORMS=OFF",
        "-DFLTK_BUILD_TEST=OFF",
        "-DFLTK_BUILD_HTML_DOCS=OFF",
        "-DFLTK_BUILD_PDF_DOCS=OFF",
    });

    cmake_conf.addArg("-B");
    const fltk_out_dir = cmake_conf.addOutputDirectoryArg2("fltk", .{});

    const fltk_compile = b.addSystemCommand(&.{ "cmake", "--build" });
    fltk_compile.addDirectoryArg2(fltk_out_dir, .{});
    fltk_compile.addArgs(&.{ "--config", "Release" });

    const fltk_step = b.step("fltk", "Build FLTK");
    fltk_step.dependOn(&fltk_compile.step);

    const fltk_bindings = b.addTranslateC(.{
        .root_source_file = b.path("src/fltk/bindings/fltk.h"),
        .target = target,
        .optimize = optimize,
    });

    const fltk_mod = b.addModule("fltk", .{
        .root_source_file = b.path("src/fltk/fltk.zig"),
        .target = target,
        .optimize = optimize,
        .link_libcpp = (os != .windows),
        .imports = &.{.{
            .name = "c",
            .module = fltk_bindings.createModule(),
        }},
    });

    fltk_mod.addCSourceFile(.{
        .file = b.path("src/fltk/bindings/fltk.cpp"),
    });

    fltk_mod.addIncludePath(b.path("fltk"));
    fltk_mod.addIncludePath(fltk_out_dir);

    if (os == .windows) {
        fltk_mod.addObjectFile(fltk_out_dir.path(b, "lib/Release/fltk.lib"));
    } else {
        fltk_mod.addObjectFile(fltk_out_dir.path(b, "lib/libfltk.a"));
    }

    if (os == .macos) {
        fltk_mod.linkFramework("Cocoa", .{});
        fltk_mod.linkFramework("ScreenCaptureKit", .{});
    } else if (os == .windows) {
        fltk_mod.linkSystemLibrary("gdi32", .{});
        fltk_mod.linkSystemLibrary("user32", .{});
        fltk_mod.linkSystemLibrary("comdlg32", .{});
        fltk_mod.linkSystemLibrary("comctl32", .{});
        fltk_mod.linkSystemLibrary("ole32", .{});
        fltk_mod.linkSystemLibrary("shell32", .{});
        fltk_mod.linkSystemLibrary("gdiplus", .{});
        fltk_mod.linkSystemLibrary("winspool", .{});
        fltk_mod.linkSystemLibrary("ws2_32", .{});
    }

    const exe = b.addExecutable(.{
        .name = "zfltk",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{
                .name = "fltk",
                .module = fltk_mod,
            }},
        }),
    });
    exe.step.dependOn(fltk_step);

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());
    run_cmd.addPassthruArgs();

    const exe_tests = b.addTest(.{ .root_module = exe.root_module, });
    const run_exe_tests = b.addRunArtifact(exe_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_exe_tests.step);
}
