TARGET = Qt$${QT_MAJOR_VERSION}AVWidgets
include(../common.pri)
TEMPLATE = lib
qtHaveModule(widgets): QT *= widgets
CONFIG(shared, static|shared) {
    RC_FILE = QtAVWidgets.rc
    CONFIG *= dll
} else:CONFIG(static, static|shared) {
    DEFINES *= BUILD_QTAV_STATIC
}
LIBS *= -lUser32
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
    GLWidgetRenderer2.cpp
DEFINES *= QTAV_HAVE_GL
CONFIG(enbale_gdiplus) {
  DEFINES *= QTAV_HAVE_GDIPLUS
  SOURCES *= GDIRenderer.cpp
  LIBS *= -lgdiplus -lgdi32
}
CONFIG(enable_direct2d) {
  DEFINES *= QTAV_HAVE_DIRECT2D
  !*msvc*: INCLUDEPATH *= $${ROOT}/contrib/d2d1headers
  SOURCES *= Direct2DRenderer.cpp
  #LIBS += -lD2d1
}
HEADERS *= \
    $$SDK_HEADERS \
    $$SDK_PRIVATE_HEADERS
