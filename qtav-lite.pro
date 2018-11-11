TEMPLATE = subdirs
CONFIG -= ordered
libqtav.file = av/libQtAV.pro
SUBDIRS *= libqtav
qtHaveModule(widgets):!CONFIG(no_widgets) {
    libqtavwidgets.file = avwidgets/libQtAVWidgets.pro
    libqtavwidgets.depends *= libqtav
    SUBDIRS *= libqtavwidgets
}
qtHaveModule(quick):!CONFIG(no_qml) {
    libqmlav.file = qmlav/libQmlAV.pro
    libqmlav.depends *= libqtav
    SUBDIRS *= libqmlav
}
