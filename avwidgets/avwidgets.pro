TARGET = Qt$${QT_MAJOR_VERSION}AVWidgets
TEMPLATE = lib
CONFIG(shared, static|shared): CONFIG *= dll
else:CONFIG(static, static|shared): DEFINES *= BUILD_QTAVWIDGETS_STATIC
include(../common.pri)
QT *= widgets opengl
DEFINES *= \
    BUILD_QTAVWIDGETS_LIB \
    QTAV_HAVE_GL=1 \
    QTAV_HAVE_GDIPLUS=1 \
    QTAV_HAVE_DIRECT2D=1
include(../av.pri)
CONFIG(shared, static|shared): RC_FILE = ../av/AV.rc
LIBS *= -lUser32 -lgdiplus -lgdi32
INCLUDEPATH *= QtAVWidgets
DEPENDPATH *= QtAVWidgets
SDK_HEADERS *= \
    QtAVWidgets/QtAVWidgets \
    QtAVWidgets/QtAVWidgets.h \
    QtAVWidgets/global.h \
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
HEADERS *= $$SDK_HEADERS
include(../deploy.pri)
