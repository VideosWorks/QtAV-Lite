TEMPLATE = subdirs
CONFIG *= ordered
SUBDIRS *= libqtav
libqtav.file = src/libQtAV.pro
qtHaveModule(widgets):!CONFIG(no_widgets) {
    SUBDIRS *= libqtavwidgets
    libqtavwidgets.file = widgets/libQtAVWidgets.pro
    libqtavwidgets.depends *= libqtav
}
qtHaveModule(quick):!CONFIG(no_qml) {
    SUBDIRS *= libqmlav
    libqmlav.file = qml/libQmlAV.pro
    libqmlav.depends *= libqtav
}
