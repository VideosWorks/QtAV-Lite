TARGET = Qt$${QT_MAJOR_VERSION}QmlAV
TEMPLATE = lib
CONFIG(shared, static|shared) {
    RC_FILE = QmlAV.rc
    CONFIG *= dll
} else:CONFIG(static, static|shared) {
    DEFINES *= BUILD_QMLAV_STATIC
    RESOURCES *= QmlAV.qrc
}
include(../common.pri)
CONFIG *= plugin
QT *= \
    quick \
    qml
DEFINES *= BUILD_QMLAV_LIB
include(../av.pri)
INCLUDEPATH *= QmlAV
DEPENDPATH *= QmlAV
SOURCES *= \
    plugin.cpp \
    QQuickItemRenderer.cpp \
    SGVideoNode.cpp \
    QmlAVPlayer.cpp \
    QuickFilter.cpp \
    QuickSubtitle.cpp \
    MediaMetaData.cpp \
    QuickSubtitleItem.cpp \
    QuickVideoPreview.cpp \
    QuickFBORenderer.cpp
HEADERS *= \
    QmlAV/version.h \
    QmlAV/QuickSubtitle.h \
    QmlAV/QuickSubtitleItem.h \
    QmlAV/QuickVideoPreview.h \
    QmlAV/QuickFBORenderer.h
SDK_HEADERS *= \
    QmlAV/Export.h \
    QmlAV/MediaMetaData.h \
    QmlAV/SGVideoNode.h \
    QmlAV/QQuickItemRenderer.h \
    QmlAV/QuickFilter.h \
    QmlAV/QmlAVPlayer.h
HEADERS *= $$SDK_HEADERS
target.path = $$[QT_INSTALL_QML]/QtAV
qtav_qml.path = $$[QT_INSTALL_QML]/QtAV
qtav_qml.files *= \
    qmldir \
    Video.qml \
    plugins.qmltypes
INSTALLS *= \
    target \
    qtav_qml
include(../deploy.pri)
