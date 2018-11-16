TARGET = Qt$${QT_MAJOR_VERSION}AV
include(../common.pri)
isEmpty(ffmpeg_dir): ffmpeg_dir = $${ROOT}/ffmpeg
!exists($${ffmpeg_dir}): error("Can\'t find FFmpeg dir.")
contains(QT_ARCH, x86_64): LIBS *= -L$${ffmpeg_dir}/lib/x64
else: LIBS *= -L$${ffmpeg_dir}/lib/x86
INCLUDEPATH *= $${ffmpeg_dir}/include
DEPENDPATH *= $${ffmpeg_dir}/include
TEMPLATE = lib
QT *= opengl
DEFINES *= BUILD_QTAV_LIB
CONFIG(shared, static|shared) {
    RC_FILE = QtAV.rc
    CONFIG *= dll
} else:CONFIG(static, static|shared) {
    DEFINES *= BUILD_QTAV_STATIC
}
CONFIG(sse4_1)|CONFIG(enable_sse4_1)|contains(TARGET_ARCH_SUB, sse4.1): CONFIG *= sse4_1 enable_simd
CONFIG(sse2)|CONFIG(enable_sse2)|contains(TARGET_ARCH_SUB, sse2): CONFIG *= sse2 enable_simd
exists($${ROOT}/contrib/capi/capi.pri) {
    include($${ROOT}/contrib/capi/capi.pri)
    DEFINES *= QTAV_HAVE_CAPI
} else {
    warning("\"contrib/capi\" is missing. run \'git submodule update --init\' first.")
}
CONFIG(capi) {
    DEFINES *= QTAV_HAVE_EGL_CAPI
    HEADERS *= capi/egl_api.h
    SOURCES *= capi/egl_api.cpp
} else {
    CONFIG(debug, debug|release): LIBS *= -llibEGLd -llibGLESv2d
    else:CONFIG(release, debug|release): LIBS *= -llibEGL -llibGLESv2
}
!CONFIG(enable_dx): INCLUDEPATH *= $${ROOT}/contrib/dxsdk
CONFIG(sse4_1) {
    CONFIG *= sse2
    DEFINES *= QTAV_HAVE_SSE4_1
    !CONFIG(enable_simd): CONFIG *= simd
    SSE4_1_SOURCES *= utils/CopyFrame_SSE4.cpp
}
CONFIG(sse2) {
  DEFINES *= QTAV_HAVE_SSE2
  !CONFIG(enable_simd): CONFIG *= simd
  SSE2_SOURCES *= utils/CopyFrame_SSE2.cpp
}
CONFIG(enable_uchardet) {
    DEFINES *= LINK_UCHARDET
    LIBS *= -luchardet
} else:exists($${ROOT}/contrib/uchardet/src/uchardet.h) {
    include($${ROOT}/contrib/uchardet.pri)
    DEFINES *= BUILD_UCHARDET
}
RESOURCES *= shaders/shaders.qrc
#UINT64_C: C99 math features, need -D__STDC_CONSTANT_MACROS in CXXFLAGS
DEFINES *= __STDC_CONSTANT_MACROS
CONFIG(enable_swresample) {
    DEFINES *= QTAV_HAVE_SWRESAMPLE
    SOURCES *= AudioResamplerFF.cpp
    CONFIG(static_ffmpeg): LIBS *= -llibswresample
    else: LIBS *= -lswresample
}
CONFIG(enable_avresample) {
    DEFINES *= QTAV_HAVE_AVRESAMPLE
    SOURCES *= AudioResamplerLibav.cpp
    CONFIG(static_ffmpeg): LIBS *= -llibavresample
    else: LIBS *= -lavresample
}
CONFIG(enable_avfilter) {
    DEFINES *= QTAV_HAVE_AVFILTER
    CONFIG(static_ffmpeg): LIBS *= -llibavfilter
    else: LIBS *= -lavfilter
}
#may depends on avfilter
CONFIG(enable_avdevice) {
    DEFINES *= QTAV_HAVE_AVDEVICE
    CONFIG(static_ffmpeg): LIBS *= -llibavdevice -lgdi32 -loleaut32 -lshlwapi
    else: LIBS *= -lavdevice
}
CONFIG(enable_ipp) {
    DEFINES *= QTAV_HAVE_IPP
    ICCROOT = $${IPPROOT}/../compiler
    INCLUDEPATH *= $${IPPROOT}/include
    SOURCES *= ImageConverterIPP.cpp
    message("\"QMAKE_TARGET.arch\" = $$QMAKE_TARGET.arch")
    *64|contains(QMAKE_TARGET.arch, x86_64)|contains(TARGET_ARCH, x86_64) {
        IPPARCH = intel64
    } else {
        IPPARCH = ia32
    }
    LIBS *= \
        -L$${IPPROOT}/lib/$$IPPARCH \
        -lippcc \
        -lippcore \
        -lippi
    LIBS *= \
        -L$${IPPROOT}/../compiler/lib/$$IPPARCH \
        -lsvml \
        -limf
    #omp for static link. _t is multi-thread static link
}
CONFIG(enable_dsound) {
    SOURCES *= output/audio/AudioOutputDSound.cpp
    DEFINES *= QTAV_HAVE_DSOUND
}
CONFIG(enable_cuda) {
    DEFINES *= QTAV_HAVE_CUDA
    HEADERS *= \
        cuda/dllapi/nv_inc.h \
        cuda/helper_cuda.h \
        codec/video/SurfaceInteropCUDA.h \
        cuda/cuda_api.h
    SOURCES *= \
        codec/video/VideoDecoderCUDA.cpp \
        codec/video/SurfaceInteropCUDA.cpp \
        cuda/cuda_api.cpp
    INCLUDEPATH *= \
        cuda \
        cuda/dllapi
    CONFIG(enable_dllapi):CONFIG(enable_dllapi_cuda) {
        DEFINES *= QTAV_HAVE_DLLAPI_CUDA
        INCLUDEPATH *= ../depends/dllapi/src
        include(../depends/dllapi/src/libdllapi.pri)
        SOURCES *= \
            cuda/dllapi/cuda.cpp \
            cuda/dllapi/nvcuvid.cpp \
            cuda/dllapi/cuviddec.cpp
    } else:CONFIG(enable_cuda_link) {
        DEFINES *= CUDA_LINK
        INCLUDEPATH *= $${CUDA_PATH}/include
        LIBS *= -L$${CUDA_PATH}/lib
        contains(TARGET_ARCH, x86): LIBS *= -L$${CUDA_PATH}/lib/Win32
        else: LIBS *= -L$${CUDA_PATH}/lib/x64
        LIBS *= -lnvcuvid -lcuda
    }
}
CONFIG(enable_d3d11va) {
    CONFIG *= enable_d3dva c++11
    DEFINES *= QTAV_HAVE_D3D11VA
    SOURCES *= \
        codec/video/VideoDecoderD3D11.cpp \
        directx/SurfaceInteropD3D11.cpp \
        directx/D3D11VP.cpp \
        directx/SurfaceInteropD3D11EGL.cpp \
        directx/SurfaceInteropD3D11GL.cpp
    HEADERS *= \
        directx/SurfaceInteropD3D11.h \
        directx/D3D11VP.h
}
CONFIG(enable_dxva) {
    CONFIG *= enable_d3dva
    DEFINES *= QTAV_HAVE_DXVA
    SOURCES *= codec/video/VideoDecoderDXVA.cpp
    LIBS *= -lole32
}
CONFIG(enable_d3dva) {
    HEADERS *= codec/video/VideoDecoderD3D.h
    SOURCES *= codec/video/VideoDecoderD3D.cpp
}
DEFINES *= QTAV_HAVE_QT_EGL QTAV_HAVE_XAUDIO2
CONFIG(enable_libass) {
    !CONFIG(capi)|CONFIG(enable_libass_link) {
        LIBS *= -lass # libass for static
        DEFINES *= CAPI_LINK_ASS
    }
    DEFINES *= QTAV_HAVE_LIBASS
    HEADERS *= capi/ass_api.h
    SOURCES *= \
        capi/ass_api.cpp \
        subtitle/SubtitleProcessorLibASS.cpp
}
LIBS *= -lUser32
CONFIG(static_ffmpeg): LIBS *= -llibavcodec -llibavformat -llibswscale -llibavutil -lws2_32 -lstrmiids -lVfw32 -luuid -lSecur32 -lBcrypt -llegacy_stdio_definitions
else: LIBS *= -lavcodec -lavformat -lswscale -lavutil
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
    VideoFrameExtractor.cpp \
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
    opengl/OpenGLHelper.cpp \
    output/video/OpenGLWindowRenderer.cpp \
    utils/DirectXHelper.cpp \
    directx/SurfaceInteropD3D9.cpp \
    directx/SurfaceInteropD3D9EGL.cpp \
    directx/SurfaceInteropD3D9GL.cpp \
    output/audio/AudioOutputXAudio2.cpp
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
    QtAV/version.h \
    QtAV/OpenGLWindowRenderer.h \
    QtAV/Geometry.h \
    QtAV/GeometryRenderer.h \
    QtAV/GLSLFilter.h \
    QtAV/OpenGLRendererBase.h \
    QtAV/OpenGLTypes.h \
    QtAV/OpenGLVideo.h \
    QtAV/ConvolutionShader.h \
    QtAV/VideoShaderObject.h \
    QtAV/VideoShader.h
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
    QtAV/private/QPainterRenderer_p.h \
    QtAV/private/OpenGLRendererBase_p.h
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
    ColorTransform.h \
    opengl/gl_api.h \
    opengl/OpenGLHelper.h \
    opengl/SubImagesGeometry.h \
    opengl/SubImagesRenderer.h \
    opengl/ShaderManager.h \
    utils/DirectXHelper.h \
    directx/SurfaceInteropD3D9.h \
    output/audio/xaudio2_compat.h
include(../deploy.pri)
