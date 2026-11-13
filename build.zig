const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const cmake_conf = b.addSystemCommand(&.{ "cmake", "--log-level=WARNING" });
    cmake_conf.addDirectoryArg2(b.path("fltk"), .{});
    cmake_conf.addArgs(&.{
        "-DCMAKE_BUILD_TYPE=Release",
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

    // Step just to compile fltk
    const fltk_step = b.step("fltk", "Build FLTK");
    fltk_step.dependOn(&fltk_compile.step);

    const fltk_bindings = b.addTranslateC(.{
        .root_source_file = b.path("src/fltk/bindings/fltk.h"),
        .target = target,
        .optimize = optimize,
        .link_libc = false,
    });

    const fltk_mod = b.addModule("fltk", .{
        .root_source_file = b.path("src/fltk/fltk.zig"),
        .target = target,
        .optimize = optimize,
        .link_libcpp = true,
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
    fltk_mod.addObjectFile(fltk_out_dir.path(b, "lib/libfltk.a"));

    // TODO OS-specific
    fltk_mod.linkFramework("Cocoa", .{});
    fltk_mod.linkFramework("ScreenCaptureKit", .{});

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
