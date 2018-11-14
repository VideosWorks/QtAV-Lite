isEmpty(ROOT): ROOT = $$PWD
isEmpty(BUILD_DIR): BUILD_DIR = $${ROOT}/build
isEmpty(BIN_DIR): BIN_DIR = $${BUILD_DIR}/bin
contains(QT_ARCH, x86_64): BIN_DIR = $$join(BIN_DIR,,,64)
exists("$${ROOT}/version_ci.pri"): include($${ROOT}/version_ci.pri)
isEmpty(QTAV_MAJOR_VERSION): QTAV_MAJOR_VERSION = 1
isEmpty(QTAV_MINOR_VERSION): QTAV_MINOR_VERSION = 13
isEmpty(QTAV_PATCH_VERSION): QTAV_PATCH_VERSION = 0
isEmpty(QTAV_BUILD_VERSION): QTAV_BUILD_VERSION = 0
DESTDIR = $${BIN_DIR}
CONFIG *= c++1z
CONFIG(qt) {
    DEFINES *= \
        QT_DEPRECATED_WARNINGS \
        QT_DISABLE_DEPRECATED_BEFORE=0x050603
}
CONFIG(debug, debug|release): TARGET = $$join(TARGET,,,d)
CONFIG -= app_bundle
