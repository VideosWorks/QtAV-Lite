## QtAV - Lite
Lite version of QtAV, removed all platform support except Windows. Removed some useless features as well.

## Compilation
Write the default configurations to **`.qmake.conf`**:
```text
contains(QT_ARCH, x86_64) {
    LIBS *= -L$$PWD/ffmpeg/lib/x64
} else {
    LIBS *= -L$$PWD/ffmpeg/lib/x86
}
INCLUDEPATH *= $$PWD/ffmpeg/include
CONFIG *= enable_dx enable_avutil enable_avcodec enable_avformat enable_swscale enable_swresample enable_avfilter enable_avdevice enable_dsound enable_cuda enable_d3d11va enable_dxva
```
Remember to download FFmpeg's lib files and header files and place them into **`$$PWD/ffmpeg`** folder. Of course, you can change it to anywhere you want. If you want to link against static version of FFmpeg, add **`static_ffmpeg`** to **`CONFIG`**. Add **`enable_avresample`** to **`CONFIG`** if you want to use *libavresample* (not recommended, FFmpeg has declared it as deprecated). You are free to remove the configs, but the compilation may fail because of depending problems.

## FFmpeg
- Zeranoe builds: https://ffmpeg.zeranoe.com/builds/

   Git and stable versions, shared libs only
- QtAV builds: https://sourceforge.net/projects/avbuild/files/windows-desktop/

   Git and stable versions, shared and static libs
- ShiftMediaProject builds: https://github.com/ShiftMediaProject/FFmpeg/releases/latest

   Git and stable versions, shared and static libs
