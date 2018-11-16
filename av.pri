qtav_lib_name = Qt$${QT_MAJOR_VERSION}AV
qtav_lib_file = Qt$${QT_MAJOR_VERSION}AV
qtav_lib_dir = release
CONFIG(debug, debug|release) {
    qtav_lib_file = $$join(qtav_lib_file,,,d)
    qtav_lib_dir = debug
}
#LIBS *= -L$$OUT_PWD/../$${qtav_lib_name}/$${qtav_lib_dir} -l$${qtav_lib_file}
LIBS *= -L$${DESTDIR} -l$${qtav_lib_file}
contains(DEFINES, BUILD_QTAVWIDGETS_LIB) {
    INCLUDEPATH *= $$PWD/av
    DEPENDPATH *= $$PWD/av
} else {
    INCLUDEPATH *= $$PWD/av/QtAV
    DEPENDPATH *= $$PWD/av/QtAV
}
