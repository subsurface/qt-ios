host_build {
    QT_CPU_FEATURES.x86_64 = cx16 mmx sse sse2 sse3 ssse3 sse4.1
} else {
    QT_CPU_FEATURES.arm64 = neon
}
QT.global_private.enabled_features = alloca_h alloca dlopen gc_binaries gui network reduce_exports release_tools sql system-zlib testlib widgets xml
QT.global_private.disabled_features = sse2 alloca_malloc_h android-style-assets avx2 private_tests dbus dbus-linked libudev posix_fallocate reduce_relocations relocatable stack-protector-strong zstd
QMAKE_LIBS_LIBDL = 
QT_COORD_TYPE = double
QMAKE_LIBS_ZLIB = -lz
CONFIG += cross_compile compile_examples largefile neon precompile_header
QT_BUILD_PARTS += libs
QT_HOST_CFLAGS_DBUS += 
