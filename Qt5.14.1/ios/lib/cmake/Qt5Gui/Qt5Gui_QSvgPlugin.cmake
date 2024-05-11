
add_library(Qt5::QSvgPlugin MODULE IMPORTED)

set(_Qt5QSvgPlugin_MODULE_DEPENDENCIES "Svg;Gui;Core")

foreach(_module_dep ${_Qt5QSvgPlugin_MODULE_DEPENDENCIES})
    if(NOT Qt5${_module_dep}_FOUND)
        find_package(Qt5${_module_dep}
            1.0.0 ${_Qt5Gui_FIND_VERSION_EXACT}
            ${_Qt5Gui_DEPENDENCIES_FIND_QUIET}
            ${_Qt5Gui_FIND_DEPENDENCIES_REQUIRED}
            PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
        )
    endif()
endforeach()

_qt5_Gui_process_prl_file(
    "${_qt5Gui_install_prefix}/plugins/imageformats/libqsvg.prl" RELEASE
    _Qt5QSvgPlugin_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5QSvgPlugin_STATIC_RELEASE_LINK_FLAGS
)

_qt5_Gui_process_prl_file(
    "${_qt5Gui_install_prefix}/plugins/imageformats/libqsvg_debug.prl" DEBUG
    _Qt5QSvgPlugin_STATIC_DEBUG_LIB_DEPENDENCIES
    _Qt5QSvgPlugin_STATIC_DEBUG_LINK_FLAGS
)

set_property(TARGET Qt5::QSvgPlugin PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt5Gui_QSvgPlugin_Import.cpp"
)

_populate_Gui_plugin_properties(QSvgPlugin RELEASE "imageformats/libqsvg.a" TRUE)
_populate_Gui_plugin_properties(QSvgPlugin DEBUG "imageformats/libqsvg_debug.a" TRUE)

list(APPEND Qt5Gui_PLUGINS Qt5::QSvgPlugin)
set_property(TARGET Qt5::Gui APPEND PROPERTY QT_ALL_PLUGINS_imageformats Qt5::QSvgPlugin)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_imageformats>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_imageformats>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::QSvgPlugin,${_manual_plugins_genex};${_plugin_type_genex}>"
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
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QSvgPlugin,QT_PLUGIN_EXTENDS>,Qt5::Gui>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QSvgPlugin,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::QSvgPlugin,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::QSvgPlugin>"
)
set_property(TARGET Qt5::Gui APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::QSvgPlugin APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::Svg;Qt5::Gui;Qt5::Core"
)
set_property(TARGET Qt5::QSvgPlugin PROPERTY QT_PLUGIN_TYPE "imageformats")
set_property(TARGET Qt5::QSvgPlugin PROPERTY QT_PLUGIN_EXTENDS "Qt5::Svg")