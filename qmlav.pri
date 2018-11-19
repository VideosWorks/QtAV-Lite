qtqmlav_lib_name = Qt$${QT_MAJOR_VERSION}QmlAV
qtqmlav_lib_file = Qt$${QT_MAJOR_VERSION}QmlAV
qtqmlav_lib_dir = release
CONFIG(debug, debug|release) {
    qtqmlav_lib_file = $$join(qtqmlav_lib_file,,,d)
    qtqmlav_lib_dir = debug
}
#LIBS *= -L$$OUT_PWD/../$${qtqmlav_lib_name}/$${qtqmlav_lib_dir} -l$${qtqmlav_lib_file}
LIBS *= -L$${LIB_DIR} -l$${qtqmlav_lib_file}
CONFIG(static, static|shared): DEFINES *= BUILD_QMLAV_STATIC
INCLUDEPATH *= \
    $$PWD/qmlav \
    $$PWD/qmlav/QmlAV
DEPENDPATH *= \
    $$PWD/qmlav \
    $$PWD/qmlav/QmlAV
