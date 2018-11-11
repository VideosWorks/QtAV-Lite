TEMPLATE = subdirs
CONFIG *= ordered
SUBDIRS *= libqtav
libqtav.file = av/libQtAV.pro
qtHaveModule(widgets):!CONFIG(no_widgets) {
    SUBDIRS *= libqtavwidgets
    libqtavwidgets.file = avwidgets/libQtAVWidgets.pro
    libqtavwidgets.depends *= libqtav
}
qtHaveModule(quick):!CONFIG(no_qml) {
    SUBDIRS *= libqmlav
    libqmlav.file = qml/libQmlAV.pro
    libqmlav.depends *= libqtav
}
