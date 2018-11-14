!qtHaveModule(gui): error("qmake can\'t find \"gui\" module. Compilation aborted.")
#!qtHaveModule(widgets): error("qmake can\'t find \"widgets\" module. Compilation aborted.")
#!qtHaveModule(network): error("qmake can\'t find \"network\" module. Compilation aborted.")
TEMPLATE = subdirs
CONFIG -= ordered
libqtav.file = av/av.pro
SUBDIRS *= libqtav
qtHaveModule(widgets):!CONFIG(no_widgets) {
    libqtavwidgets.file = avwidgets/avwidgets.pro
    libqtavwidgets.depends *= libqtav
    SUBDIRS *= libqtavwidgets
}
#qtHaveModule(quick):!CONFIG(no_qml) {
    #libqmlav.file = qmlav/qmlav.pro
    #libqmlav.depends *= libqtav
    #SUBDIRS *= libqmlav
#}
