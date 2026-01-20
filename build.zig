const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const libogg = b.addLibrary(.{
        .name = "ogg",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .sanitize_c = .off,
        }),
        .linkage = .static,
    });
    libogg.root_module.addIncludePath(b.path("include"));
    libogg.root_module.addCSourceFiles(.{
        .flags = &.{"-std=c99", "-fvisibility=hidden"},
        .files = &.{ "bitwise.c", "framing.c" },
        .root = b.path("libogg"),
    });
    libogg.installHeadersDirectory(b.path("include/ogg"), "ogg", .{});
    b.installArtifact(libogg);

    const libvorbis = b.addLibrary(.{
        .name = "vorbis",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .sanitize_c = .off,
        }),
        .linkage = .static,
    });
    libvorbis.root_module.linkLibrary(libogg);
    libvorbis.root_module.addIncludePath(b.path("include"));
    libvorbis.root_module.addIncludePath(b.path("libvorbis"));
    libvorbis.root_module.addCSourceFiles(.{
        .flags = &.{"-fvisibility=hidden"},
        .files = &.{
            "analysis.c",
            "bitrate.c",
            "block.c",
            "codebook.c",
            "envelope.c",
            "floor0.c",
            "floor1.c",
            "info.c",
            "lookup.c",
            "lpc.c",
            "lsp.c",
            "mapping0.c",
            "mdct.c",
            "psy.c",
            "registry.c",
            "res0.c",
            "sharedbook.c",
            "smallft.c",
            "synthesis.c",
            "window.c",
            "vorbisfile.c",
            "vorbisenc.c",
        },
        .root = b.path("libvorbis"),
    });
    libvorbis.installHeadersDirectory(b.path("include/vorbis"), "vorbis", .{});
    b.installArtifact(libvorbis);
}
