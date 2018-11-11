TEMPLATE = lib
TARGET = Qt$${QT_MAJOR_VERSION}AV
CONFIG(debug, debug|release): DEFINES *= DEBUG
PROJECTROOT = $$PWD/..
CONFIG(shared, static|shared) {
    RC_FILE = QtAV.rc
    CONFIG *= dll
} else:CONFIG(static, static|shared) {
    DEFINES *= BUILD_QTAV_STATIC
}
config_uchardet {
  DEFINES += LINK_UCHARDET
  LIBS *= -luchardet
} else:exists($$PROJECTROOT/contrib/uchardet/src/uchardet.h) {
  include($$PROJECTROOT/contrib/uchardet.pri)
  DEFINES += BUILD_UCHARDET
}
exists($$PROJECTROOT/contrib/capi/capi.pri) {
  include($$PROJECTROOT/contrib/capi/capi.pri)
  DEFINES *= QTAV_HAVE_CAPI=1
} else {
  warning("contrib/capi is missing. run 'git submodule update --init' first")
}
RESOURCES += \
    images_svg.qrc \
    shaders/shaders.qrc

capi {
DEFINES += QTAV_HAVE_EGL_CAPI=1
    HEADERS *= capi/egl_api.h
    SOURCES *= capi/egl_api.cpp
}

#UINT64_C: C99 math features, need -D__STDC_CONSTANT_MACROS in CXXFLAGS
DEFINES += __STDC_CONSTANT_MACROS

config_swresample {
    DEFINES += QTAV_HAVE_SWRESAMPLE=1
    SOURCES += AudioResamplerFF.cpp
    LIBS += -lswresample
}
config_avresample {
    DEFINES += QTAV_HAVE_AVRESAMPLE=1
    SOURCES += AudioResamplerLibav.cpp
    LIBS += -lavresample
}
config_avdevice { #may depends on avfilter
    DEFINES += QTAV_HAVE_AVDEVICE=1
    LIBS *= -lavdevice
    static_ffmpeg {
      LIBS *= -lgdi32 -loleaut32 -lshlwapi #shlwapi: desktop >= xp only
    }
}
config_avfilter {
    DEFINES += QTAV_HAVE_AVFILTER=1
    LIBS += -lavfilter
}
config_ipp {
    DEFINES += QTAV_HAVE_IPP=1
    ICCROOT = $$(IPPROOT)/../compiler
    INCLUDEPATH += $$(IPPROOT)/include
    SOURCES += ImageConverterIPP.cpp
    message("QMAKE_TARGET.arch" $$QMAKE_TARGET.arch)
    *64|contains(QMAKE_TARGET.arch, x86_64)|contains(TARGET_ARCH, x86_64) {
        IPPARCH=intel64
    } else {
        IPPARCH=ia32
    }
    LIBS *= -L$$(IPPROOT)/lib/$$IPPARCH -lippcc -lippcore -lippi
    LIBS *= -L$$(IPPROOT)/../compiler/lib/$$IPPARCH -lsvml -limf
    #omp for static link. _t is multi-thread static link
}

win32: {
  HEADERS += output/audio/xaudio2_compat.h
  SOURCES += output/audio/AudioOutputXAudio2.cpp
  DEFINES *= QTAV_HAVE_XAUDIO2=1
}
config_dsound:!winrt {
    SOURCES += output/audio/AudioOutputDSound.cpp
    DEFINES *= QTAV_HAVE_DSOUND=1
}
config_portaudio {
    SOURCES += output/audio/AudioOutputPortAudio.cpp
    DEFINES *= QTAV_HAVE_PORTAUDIO=1
    LIBS *= -lportaudio
    #win32: LIBS *= -lwinmm #-lksguid #-luuid
}
config_openal {
    SOURCES *= output/audio/AudioOutputOpenAL.cpp
    HEADERS *= capi/openal_api.h
    SOURCES *= capi/openal_api.cpp
    DEFINES *= QTAV_HAVE_OPENAL=1
    static_openal: DEFINES += AL_LIBTYPE_STATIC # openal-soft AL_API dllimport error. mac's macro is AL_BUILD_LIBRARY
    !capi|config_openal_link|static_openal {
      DEFINES *= CAPI_LINK_OPENAL
      LIBS += -lOpenAL32 -lwinmm
    }
}
config_opensl {
    SOURCES += output/audio/AudioOutputOpenSL.cpp
    DEFINES *= QTAV_HAVE_OPENSL=1
    LIBS += -lOpenSLES
}
config_pulseaudio {
    SOURCES += output/audio/AudioOutputPulse.cpp
    DEFINES *= QTAV_HAVE_PULSEAUDIO=1
    LIBS += -lpulse
}
CONFIG += config_cuda
#CONFIG += config_cuda_link
config_cuda {
    DEFINES += QTAV_HAVE_CUDA=1
    HEADERS += cuda/dllapi/nv_inc.h cuda/helper_cuda.h
    SOURCES += codec/video/VideoDecoderCUDA.cpp
    #contains(QT_CONFIG, opengl) {
      HEADERS += codec/video/SurfaceInteropCUDA.h
      SOURCES += codec/video/SurfaceInteropCUDA.cpp
    #}
    INCLUDEPATH += $$PWD/cuda cuda/dllapi
    config_dllapi:config_dllapi_cuda {
        DEFINES += QTAV_HAVE_DLLAPI_CUDA=1
        INCLUDEPATH += ../depends/dllapi/src
include(../depends/dllapi/src/libdllapi.pri)
        SOURCES += cuda/dllapi/cuda.cpp cuda/dllapi/nvcuvid.cpp cuda/dllapi/cuviddec.cpp
    } else:config_cuda_link {
        DEFINES += CUDA_LINK
        INCLUDEPATH += $$(CUDA_PATH)/include
        LIBS += -L$$(CUDA_PATH)/lib
        contains(TARGET_ARCH, x86): LIBS += -L$$(CUDA_PATH)/lib/Win32
        else: LIBS += -L$$(CUDA_PATH)/lib/x64
        LIBS += -lnvcuvid -lcuda
    }
    SOURCES += cuda/cuda_api.cpp
    HEADERS += cuda/cuda_api.h
}
config_d3d11va {
  CONFIG *= d3dva c++11
  DEFINES *= QTAV_HAVE_D3D11VA=1
  SOURCES += codec/video/VideoDecoderD3D11.cpp
  HEADERS += directx/SurfaceInteropD3D11.h
  SOURCES += directx/SurfaceInteropD3D11.cpp
  HEADERS += directx/D3D11VP.h
  SOURCES += directx/D3D11VP.cpp
  SOURCES += directx/SurfaceInteropD3D11EGL.cpp
  winrt: LIBS *= -ld3d11
}
win32:!winrt {
  HEADERS += directx/SurfaceInteropD3D9.h
  SOURCES += directx/SurfaceInteropD3D9.cpp
  SOURCES += directx/SurfaceInteropD3D9EGL.cpp
}
config_dxva {
  CONFIG *= d3dva
  DEFINES *= QTAV_HAVE_DXVA=1
  SOURCES += codec/video/VideoDecoderDXVA.cpp
  LIBS += -lole32
}
d3dva {
  HEADERS += codec/video/VideoDecoderD3D.h
  SOURCES += codec/video/VideoDecoderD3D.cpp
}
config_vaapi* {
    DEFINES *= QTAV_HAVE_VAAPI=1
    SOURCES += codec/video/VideoDecoderVAAPI.cpp  vaapi/vaapi_helper.cpp
    HEADERS += vaapi/vaapi_helper.h
  #contains(QT_CONFIG, opengl) {
    HEADERS += vaapi/SurfaceInteropVAAPI.h
    SOURCES += vaapi/SurfaceInteropVAAPI.cpp
  #}
    LIBS *= -lva -lX11 #dynamic load va-glx va-x11 using dllapi. -lX11: used by tfp
}

config_vda {
    DEFINES *= QTAV_HAVE_VDA=1
    SOURCES += codec/video/VideoDecoderVDA.cpp
    LIBS += -framework VideoDecodeAcceleration
}
config_videotoolbox {
  DEFINES *= QTAV_HAVE_VIDEOTOOLBOX=1
  SOURCES *= codec/video/VideoDecoderVideoToolbox.cpp
  LIBS += -framework CoreMedia -framework VideoToolbox
}

config_gl|config_opengl {
  contains(QT_CONFIG, egl) {
    DEFINES *= QTAV_HAVE_QT_EGL=1
#if a platform plugin depends on egl (for example, eglfs), egl is defined
  }
  OTHER_FILES += shaders/planar.f.glsl shaders/rgb.f.glsl
  SDK_HEADERS *= \
    QtAV/Geometry.h \
    QtAV/GeometryRenderer.h \
    QtAV/GLSLFilter.h \
    QtAV/OpenGLRendererBase.h \
    QtAV/OpenGLTypes.h \
    QtAV/OpenGLVideo.h \
    QtAV/ConvolutionShader.h \
    QtAV/VideoShaderObject.h \
    QtAV/VideoShader.h
  SDK_PRIVATE_HEADERS = \
    QtAV/private/OpenGLRendererBase_p.h
  HEADERS *= \
    opengl/gl_api.h \
    opengl/OpenGLHelper.h \
    opengl/SubImagesGeometry.h \
    opengl/SubImagesRenderer.h \
    opengl/ShaderManager.h
  SOURCES *= \
    filter/GLSLFilter.cpp \
    output/video/OpenGLRendererBase.cpp \
    opengl/gl_api.cpp \
    opengl/OpenGLTypes.cpp \
    opengl/Geometry.cpp \
    opengl/GeometryRenderer.cpp \
    opengl/SubImagesGeometry.cpp \
    opengl/SubImagesRenderer.cpp \
    opengl/OpenGLVideo.cpp \
    opengl/VideoShaderObject.cpp \
    opengl/VideoShader.cpp \
    opengl/ShaderManager.cpp \
    opengl/ConvolutionShader.cpp \
    opengl/OpenGLHelper.cpp
}
config_openglwindow {
  SDK_HEADERS *= QtAV/OpenGLWindowRenderer.h
  SOURCES *= output/video/OpenGLWindowRenderer.cpp
}
config_libass {
#link against libass instead of dynamic load
  !capi|winrt|android|ios|config_libass_link {
    LIBS += -lass #-lfribidi -lfontconfig -lxml2 -lfreetype -lharfbuzz -lz
    DEFINES += CAPI_LINK_ASS
  }
  DEFINES *= QTAV_HAVE_LIBASS=1
  HEADERS *= capi/ass_api.h
  SOURCES *= capi/ass_api.cpp
  SOURCES *= subtitle/SubtitleProcessorLibASS.cpp
}
LIBS *= -lavcodec -lavformat -lswscale -lavutil
win32 {
  HEADERS *= utils/DirectXHelper.h
  SOURCES *= utils/DirectXHelper.cpp
#dynamicgl: __impl__GetDC __impl_ReleaseDC __impl_GetDesktopWindow
  !winrt:LIBS += -luser32
}
winrt {
  SOURCES *= io/WinRTIO.cpp
  LIBS *= -lshcore
}
# compat with old system
# use old libva.so to link against
glibc_compat: *linux*: LIBS += -lrt  # do not use clock_gettime in libc, GLIBC_2.17 is not available on old system
static_ffmpeg {
LIBS *= -lws2_32 -lstrmiids -lvfw32 -luuid
}
SOURCES += \
    AVCompat.cpp \
    QtAV_Global.cpp \
    subtitle/SubImage.cpp \
    subtitle/CharsetDetector.cpp \
    subtitle/PlainText.cpp \
    subtitle/PlayerSubtitle.cpp \
    subtitle/Subtitle.cpp \
    subtitle/SubtitleProcessor.cpp \
    subtitle/SubtitleProcessorFFmpeg.cpp \
    utils/GPUMemCopy.cpp \
    utils/Logger.cpp \
    AudioThread.cpp \
    utils/internal.cpp \
    AVThread.cpp \
    AudioFormat.cpp \
    AudioFrame.cpp \
    AudioResampler.cpp \
    AudioResamplerTemplate.cpp \
    codec/audio/AudioDecoder.cpp \
    codec/audio/AudioDecoderFFmpeg.cpp \
    codec/audio/AudioEncoder.cpp \
    codec/audio/AudioEncoderFFmpeg.cpp \
    codec/AVDecoder.cpp \
    codec/AVEncoder.cpp \
    AVMuxer.cpp \
    AVDemuxer.cpp \
    AVDemuxThread.cpp \
    ColorTransform.cpp \
    Frame.cpp \
    FrameReader.cpp \
    filter/Filter.cpp \
    filter/FilterContext.cpp \
    filter/FilterManager.cpp \
    filter/LibAVFilter.cpp \
    filter/SubtitleFilter.cpp \
    filter/EncodeFilter.cpp \
    ImageConverter.cpp \
    ImageConverterFF.cpp \
    Packet.cpp \
    PacketBuffer.cpp \
    AVError.cpp \
    AVPlayer.cpp \
    AVPlayerPrivate.cpp \
    AVTranscoder.cpp \
    AVClock.cpp \
    VideoCapture.cpp \
    VideoFormat.cpp \
    VideoFrame.cpp \
    io/MediaIO.cpp \
    io/QIODeviceIO.cpp \
    output/audio/AudioOutput.cpp \
    output/audio/AudioOutputBackend.cpp \
    output/audio/AudioOutputNull.cpp \
    output/video/VideoRenderer.cpp \
    output/video/VideoOutput.cpp \
    output/video/QPainterRenderer.cpp \
    output/AVOutput.cpp \
    output/OutputSet.cpp \
    Statistics.cpp \
    codec/video/VideoDecoder.cpp \
    codec/video/VideoDecoderFFmpegBase.cpp \
    codec/video/VideoDecoderFFmpeg.cpp \
    codec/video/VideoDecoderFFmpegHW.cpp \
    codec/video/VideoEncoder.cpp \
    codec/video/VideoEncoderFFmpeg.cpp \
    VideoThread.cpp \
    VideoFrameExtractor.cpp

SDK_HEADERS *= \
    QtAV/QtAV \
    QtAV/QtAV.h \
    QtAV/dptr.h \
    QtAV/QtAV_Global.h \
    QtAV/AudioResampler.h \
    QtAV/AudioDecoder.h \
    QtAV/AudioEncoder.h \
    QtAV/AudioFormat.h \
    QtAV/AudioFrame.h \
    QtAV/AudioOutput.h \
    QtAV/AVDecoder.h \
    QtAV/AVEncoder.h \
    QtAV/AVDemuxer.h \
    QtAV/AVMuxer.h \
    QtAV/Filter.h \
    QtAV/FilterContext.h \
    QtAV/LibAVFilter.h \
    QtAV/EncodeFilter.h \
    QtAV/Frame.h \
    QtAV/FrameReader.h \
    QtAV/QPainterRenderer.h \
    QtAV/Packet.h \
    QtAV/AVError.h \
    QtAV/AVPlayer.h \
    QtAV/AVTranscoder.h \
    QtAV/VideoCapture.h \
    QtAV/VideoRenderer.h \
    QtAV/VideoOutput.h \
    QtAV/MediaIO.h \
    QtAV/AVOutput.h \
    QtAV/AVClock.h \
    QtAV/VideoDecoder.h \
    QtAV/VideoEncoder.h \
    QtAV/VideoFormat.h \
    QtAV/VideoFrame.h \
    QtAV/VideoFrameExtractor.h \
    QtAV/FactoryDefine.h \
    QtAV/Statistics.h \
    QtAV/SubImage.h \
    QtAV/Subtitle.h \
    QtAV/SubtitleFilter.h \
    QtAV/SurfaceInterop.h \
    QtAV/version.h

SDK_PRIVATE_HEADERS *= \
    QtAV/private/factory.h \
    QtAV/private/mkid.h \
    QtAV/private/prepost.h \
    QtAV/private/singleton.h \
    QtAV/private/PlayerSubtitle.h \
    QtAV/private/SubtitleProcessor.h \
    QtAV/private/AVCompat.h \
    QtAV/private/AudioOutputBackend.h \
    QtAV/private/AudioResampler_p.h \
    QtAV/private/AVDecoder_p.h \
    QtAV/private/AVEncoder_p.h \
    QtAV/private/MediaIO_p.h \
    QtAV/private/AVOutput_p.h \
    QtAV/private/Filter_p.h \
    QtAV/private/Frame_p.h \
    QtAV/private/VideoShader_p.h \
    QtAV/private/VideoRenderer_p.h \
    QtAV/private/QPainterRenderer_p.h

# QtAV/private/* may be used by developers to extend QtAV features without changing QtAV library
# headers not in QtAV/ and it's subdirs are used only by QtAV internally
HEADERS *= \
    $$SDK_HEADERS \
    $$SDK_PRIVATE_HEADERS \
    AVPlayerPrivate.h \
    AVDemuxThread.h \
    AVThread.h \
    AVThread_p.h \
    AudioThread.h \
    PacketBuffer.h \
    VideoThread.h \
    ImageConverter.h \
    ImageConverter_p.h \
    codec/video/VideoDecoderFFmpegBase.h \
    codec/video/VideoDecoderFFmpegHW.h \
    codec/video/VideoDecoderFFmpegHW_p.h \
    filter/FilterManager.h \
    subtitle/CharsetDetector.h \
    subtitle/PlainText.h \
    utils/BlockingQueue.h \
    utils/GPUMemCopy.h \
    utils/Logger.h \
    utils/SharedPtr.h \
    utils/ring.h \
    utils/internal.h \
    output/OutputSet.h \
    ColorTransform.h
