
add_library(Qt5::QDarwinWebViewPlugin MODULE IMPORTED)

set(_Qt5QDarwinWebViewPlugin_MODULE_DEPENDENCIES "Gui;Core")

foreach(_module_dep ${_Qt5QDarwinWebViewPlugin_MODULE_DEPENDENCIES})
    if(NOT Qt5${_module_dep}_FOUND)
        find_package(Qt5${_module_dep}
            1.0.0 ${_Qt5WebView_FIND_VERSION_EXACT}
            ${_Qt5WebView_DEPENDENCIES_FIND_QUIET}
            ${_Qt5WebView_FIND_DEPENDENCIES_REQUIRED}
            PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
        )
    endif()
endforeach()

_qt5_WebView_process_prl_file(
    "${_qt5WebView_install_prefix}/plugins/webview/libqtwebview_darwin.prl" RELEASE
    _Qt5QDarwinWebViewPlugin_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5QDarwinWebViewPlugin_STATIC_RELEASE_LINK_FLAGS
)

_qt5_WebView_process_prl_file(
    "${_qt5WebView_install_prefix}/plugins/webview/libqtwebview_darwin_debug.prl" DEBUG
    _Qt5QDarwinWebViewPlugin_STATIC_DEBUG_LIB_DEPENDENCIES
    _Qt5QDarwinWebViewPlugin_STATIC_DEBUG_LINK_FLAGS
)

set_property(TARGET Qt5::QDarwinWebViewPlugin PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt5WebView_QDarwinWebViewPlugin_Import.cpp"
)

_populate_WebView_plugin_properties(QDarwinWebViewPlugin RELEASE "webview/libqtwebview_darwin.a" TRUE)
_populate_WebView_plugin_properties(QDarwinWebViewPlugin DEBUG "webview/libqtwebview_darwin_debug.a" TRUE)

list(APPEND Qt5WebView_PLUGINS Qt5::QDarwinWebViewPlugin)
set_property(TARGET Qt5::WebView APPEND PROPERTY QT_ALL_PLUGINS_webview Qt5::QDarwinWebViewPlugin)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_webview>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_webview>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::QDarwinWebViewPlugin,${_manual_plugins_genex};${_plugin_type_genex}>"
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
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QDarwinWebViewPlugin,QT_PLUGIN_EXTENDS>,Qt5::WebView>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QDarwinWebViewPlugin,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::QDarwinWebViewPlugin,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::QDarwinWebViewPlugin>"
)
set_property(TARGET Qt5::WebView APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::QDarwinWebViewPlugin APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::Gui;Qt5::Core"
)
set_property(TARGET Qt5::QDarwinWebViewPlugin PROPERTY QT_PLUGIN_TYPE "webview")
set_property(TARGET Qt5::QDarwinWebViewPlugin PROPERTY QT_PLUGIN_EXTENDS "")
