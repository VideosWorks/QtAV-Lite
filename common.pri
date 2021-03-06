isEmpty(ROOT): ROOT = $$PWD
isEmpty(BUILD_DIR): BUILD_DIR = $${ROOT}/build
isEmpty(BIN_DIR): BIN_DIR = $${BUILD_DIR}/bin
isEmpty(LIB_DIR): LIB_DIR = $${BUILD_DIR}/lib
contains(QT_ARCH, x86_64) {
    BIN_DIR = $$join(BIN_DIR,,,64)
    LIB_DIR = $$join(LIB_DIR,,,64)
}
CONFIG(static, static|shared): LIB_DIR = $$join(LIB_DIR,,,_static)
contains(TEMPLATE, app): DESTDIR = $${BIN_DIR}
else:contains(TEMPLATE, lib): DESTDIR = $${LIB_DIR}
CONFIG(dll): DLLDESTDIR = $${BIN_DIR}
CONFIG *= c++11 c++1z
CONFIG(qt) {
    DEFINES *= \
        QT_DEPRECATED_WARNINGS \
        QT_DISABLE_DEPRECATED_BEFORE=0x050603
}
CONFIG(debug, debug|release): TARGET = $$join(TARGET,,,d)
CONFIG -= app_bundle
