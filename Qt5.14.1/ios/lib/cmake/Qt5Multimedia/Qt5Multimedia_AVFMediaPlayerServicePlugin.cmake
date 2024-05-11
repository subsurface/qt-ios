
add_library(Qt5::AVFMediaPlayerServicePlugin MODULE IMPORTED)

set(_Qt5AVFMediaPlayerServicePlugin_MODULE_DEPENDENCIES "MultimediaWidgets;Multimedia;Gui;Network;Core")

foreach(_module_dep ${_Qt5AVFMediaPlayerServicePlugin_MODULE_DEPENDENCIES})
    if(NOT Qt5${_module_dep}_FOUND)
        find_package(Qt5${_module_dep}
            1.0.0 ${_Qt5Multimedia_FIND_VERSION_EXACT}
            ${_Qt5Multimedia_DEPENDENCIES_FIND_QUIET}
            ${_Qt5Multimedia_FIND_DEPENDENCIES_REQUIRED}
            PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
        )
    endif()
endforeach()

_qt5_Multimedia_process_prl_file(
    "${_qt5Multimedia_install_prefix}/plugins/mediaservice/libqavfmediaplayer.prl" RELEASE
    _Qt5AVFMediaPlayerServicePlugin_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5AVFMediaPlayerServicePlugin_STATIC_RELEASE_LINK_FLAGS
)

_qt5_Multimedia_process_prl_file(
    "${_qt5Multimedia_install_prefix}/plugins/mediaservice/libqavfmediaplayer_debug.prl" DEBUG
    _Qt5AVFMediaPlayerServicePlugin_STATIC_DEBUG_LIB_DEPENDENCIES
    _Qt5AVFMediaPlayerServicePlugin_STATIC_DEBUG_LINK_FLAGS
)

set_property(TARGET Qt5::AVFMediaPlayerServicePlugin PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt5Multimedia_AVFMediaPlayerServicePlugin_Import.cpp"
)

_populate_Multimedia_plugin_properties(AVFMediaPlayerServicePlugin RELEASE "mediaservice/libqavfmediaplayer.a" TRUE)
_populate_Multimedia_plugin_properties(AVFMediaPlayerServicePlugin DEBUG "mediaservice/libqavfmediaplayer_debug.a" TRUE)

list(APPEND Qt5Multimedia_PLUGINS Qt5::AVFMediaPlayerServicePlugin)
set_property(TARGET Qt5::Multimedia APPEND PROPERTY QT_ALL_PLUGINS_mediaservice Qt5::AVFMediaPlayerServicePlugin)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_mediaservice>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_mediaservice>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::AVFMediaPlayerServicePlugin,${_manual_plugins_genex};${_plugin_type_genex}>"
)
string(CONCAT _plugin_genex
    "$<$<OR:"
        # Add this plugin if it's in the list of manual plugins or plugins for the type
        "${_user_specified_genex},"
        # Add this plugin if the list of plugins for the type is empty, the PLUGIN_EXTENDS
        # is either empty or equal to the module name, and the user hasn't blacklisted it
        "$<AND:"
            "$<STREQUAL:${_plugin_type_genex},>,"
            "$<OR:"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::AVFMediaPlayerServicePlugin,QT_PLUGIN_EXTENDS>,Qt5::Multimedia>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::AVFMediaPlayerServicePlugin,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::AVFMediaPlayerServicePlugin,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::AVFMediaPlayerServicePlugin>"
)
set_property(TARGET Qt5::Multimedia APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::AVFMediaPlayerServicePlugin APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::MultimediaWidgets;Qt5::Multimedia;Qt5::Gui;Qt5::Network;Qt5::Core"
)
set_property(TARGET Qt5::AVFMediaPlayerServicePlugin PROPERTY QT_PLUGIN_TYPE "mediaservice")
set_property(TARGET Qt5::AVFMediaPlayerServicePlugin PROPERTY QT_PLUGIN_EXTENDS "")