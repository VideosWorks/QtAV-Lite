CONFIG(shared, static|shared) {
    isEmpty(target.path): target.path = $$[QT_INSTALL_BINS]
    INSTALLS *= target
    $${TARGET}_libs.path = $${BIN_DIR}
    isEmpty(windeployqt): windeployqt = $$[QT_INSTALL_BINS]/windeployqt
    exists("$${windeployqt}.exe") {
        target_file_name = $${TARGET}
        CONFIG(dll) {
            exists($${BIN_DIR}/$${target_file_name}$${QTAV_MAJOR_VERSION}.dll): target_file_name = $${target_file_name}$${QTAV_MAJOR_VERSION}.dll
            else: target_file_name = $${target_file_name}.dll
        } else {
            target_file_name = $${target_file_name}.exe
        }
        windeployqt_command = --plugindir \"$${BIN_DIR}\\plugins\" --no-translations --no-compiler-runtime -opengl --list source
        CONFIG(no_llvmpipe)|CONFIG(no_mesa): windeployqt_command = $${windeployqt_command} --no-opengl-sw
        CONFIG(no_angle): windeployqt_command = $${windeployqt_command} --no-system-d3d-compiler --no-angle
        CONFIG(no_svg): windeployqt_command = $${windeployqt_command} --no-svg
        $${TARGET}_libs.commands *= $$quote(\"$${windeployqt}\" $${windeployqt_command} \"$${BIN_DIR}\\$${target_file_name}\")
    } else {
        message("It seems that there is no \"windeployqt\" in \"$$[QT_INSTALL_BINS]\".")
        message("You may have to copy Qt run-time libraries manually and don\'t forget about the plugins.")
        message("Qt5Svg.dll, Qt5OpenGL.dll and plugins\\iconengines\\qsvgicon.dll are the necessary dlls you must copy.")
        message("d3dcompiler_XX.dll, libEGL.dll, libGLESv2.dll and opengl32sw.dll may be useful as well.")
    }
    !isEmpty($${TARGET}_libs.commands) {
        $${TARGET}_libs.commands = $$join($${TARGET}_libs.commands, $$escape_expand(\\n\\t))
        INSTALLS *= $${TARGET}_libs
    }
}
