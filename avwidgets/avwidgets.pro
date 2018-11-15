TARGET = Qt$${QT_MAJOR_VERSION}AVWidgets
include(../common.pri)
TEMPLATE = lib
QT *= opengl
qtHaveModule(widgets): QT *= widgets
DEFINES *= BUILD_QTAVWIDGETS_LIB
CONFIG(shared, static|shared) {
    RC_FILE = QtAVWidgets.rc
    CONFIG *= dll
} else:CONFIG(static, static|shared) {
    DEFINES *= BUILD_QTAVWIDGETS_STATIC
}
include(../av.pri)
LIBS *= -lUser32 -lgdiplus -lgdi32
DEFINES *= QTAV_HAVE_GL QTAV_HAVE_GDIPLUS QTAV_HAVE_DIRECT2D
SDK_HEADERS *= \
    QtAVWidgets/QtAVWidgets \
    QtAVWidgets/QtAVWidgets.h \
    QtAVWidgets/global.h \
    QtAVWidgets/version.h \
    QtAVWidgets/VideoPreviewWidget.h \
    QtAVWidgets/GraphicsItemRenderer.h \
    QtAVWidgets/WidgetRenderer.h \
    QtAVWidgets/OpenGLWidgetRenderer.h \
    QtAVWidgets/GLWidgetRenderer2.h
SOURCES *= \
    global.cpp \
    VideoPreviewWidget.cpp \
    GraphicsItemRenderer.cpp \
    WidgetRenderer.cpp \
    OpenGLWidgetRenderer.cpp \
    GLWidgetRenderer2.cpp \
    GDIRenderer.cpp \
    Direct2DRenderer.cpp
HEADERS *= \
    $$SDK_HEADERS \
    $$SDK_PRIVATE_HEADERS
