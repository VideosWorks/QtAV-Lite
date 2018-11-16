qtavwidgets_lib_name = Qt$${QT_MAJOR_VERSION}AVWidgets
qtavwidgets_lib_file = Qt$${QT_MAJOR_VERSION}AVWidgets
qtavwidgets_lib_dir = release
CONFIG(debug, debug|release) {
    qtavwidgets_lib_file = $$join(qtavwidgets_lib_file,,,d)
    qtavwidgets_lib_dir = debug
}
#LIBS *= -L$$OUT_PWD/../$${qtavwidgets_lib_name}/$${qtavwidgets_lib_dir} -l$${qtavwidgets_lib_file}
LIBS *= -L$${DESTDIR} -l$${qtavwidgets_lib_file}
contains(DEFINES, BUILD_QTAV_LIB) {
    INCLUDEPATH *= $$PWD/avwidgets
    DEPENDPATH *= $$PWD/avwidgets
} else {
    INCLUDEPATH *= $$PWD/avwidgets/QtAVWidgets
    DEPENDPATH *= $$PWD/avwidgets/QtAVWidgets
}
