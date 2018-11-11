TEMPLATE = lib
TARGET = Qt$${QT_MAJOR_VERSION}AVWidgets
qtHaveModule(widgets): QT *= widgets
PROJECTROOT = $$PWD/..
CONFIG(shared, static|shared) {
    RC_FILE = QtAVWidgets.rc
    CONFIG *= dll
}
win32 {
#dynamicgl: __impl__GetDC __impl_ReleaseDC
  !winrt:LIBS *= -luser32
}

SDK_HEADERS *= \
    QtAVWidgets/QtAVWidgets \
    QtAVWidgets/QtAVWidgets.h \
    QtAVWidgets/global.h \
    QtAVWidgets/version.h \
    QtAVWidgets/VideoPreviewWidget.h \
    QtAVWidgets/GraphicsItemRenderer.h \
    QtAVWidgets/WidgetRenderer.h


SOURCES *= \
    global.cpp \
    VideoPreviewWidget.cpp \
    GraphicsItemRenderer.cpp \
    WidgetRenderer.cpp

contains(QT_CONFIG, opengl):greaterThan(QT_MAJOR_VERSION, 4) {
  SDK_HEADERS *= QtAVWidgets/OpenGLWidgetRenderer.h
  SOURCES *= OpenGLWidgetRenderer.cpp
}

DEFINES *= QTAV_HAVE_GL=1
  SOURCES += GLWidgetRenderer2.cpp
  SDK_HEADERS += QtAVWidgets/GLWidgetRenderer2.h
config_gdiplus {
  DEFINES *= QTAV_HAVE_GDIPLUS=1
  SOURCES += GDIRenderer.cpp
  LIBS *= -lgdiplus -lgdi32
}
config_direct2d {
  DEFINES *= QTAV_HAVE_DIRECT2D=1
  !*msvc*: INCLUDEPATH += $$PROJECTROOT/contrib/d2d1headers
  SOURCES += Direct2DRenderer.cpp
  #LIBS += -lD2d1
}
config_xv {
  DEFINES *= QTAV_HAVE_XV=1
  SOURCES += XVRenderer.cpp
  LIBS *= -lXv -lX11 -lXext
}
config_x11 {
  DEFINES *= QTAV_HAVE_X11=1
  SOURCES *= X11Renderer.cpp
  LIBS *= -lX11
}
# QtAV/private/* may be used by developers to extend QtAV features without changing QtAV library
# headers not in QtAV/ and it's subdirs are used only by QtAV internally
HEADERS *= \
    $$SDK_HEADERS \
    $$SDK_PRIVATE_HEADERS
