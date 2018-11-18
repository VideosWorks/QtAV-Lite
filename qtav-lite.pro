TEMPLATE = subdirs
CONFIG -= ordered
libqtav.file = av/av.pro
SUBDIRS *= libqtav
qtHaveModule(widgets):!CONFIG(no_qtavwidgets) {
    libqtavwidgets.file = avwidgets/avwidgets.pro
    libqtavwidgets.depends *= libqtav
    SUBDIRS *= libqtavwidgets
}
qtHaveModule(quick):!CONFIG(no_qtqmlav) {
    libqmlav.file = qmlav/qmlav.pro
    libqmlav.depends *= libqtav
    SUBDIRS *= libqmlav
}
