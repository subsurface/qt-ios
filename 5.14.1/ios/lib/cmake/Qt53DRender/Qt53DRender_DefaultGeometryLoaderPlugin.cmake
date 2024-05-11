
add_library(Qt5::DefaultGeometryLoaderPlugin MODULE IMPORTED)

set(_Qt5DefaultGeometryLoaderPlugin_MODULE_DEPENDENCIES "3DRender;3DCore;3DRender;3DCore;Gui;Core;Core")

foreach(_module_dep ${_Qt5DefaultGeometryLoaderPlugin_MODULE_DEPENDENCIES})
    if(NOT Qt5${_module_dep}_FOUND)
        find_package(Qt5${_module_dep}
            1.0.0 ${_Qt53DRender_FIND_VERSION_EXACT}
            ${_Qt53DRender_DEPENDENCIES_FIND_QUIET}
            ${_Qt53DRender_FIND_DEPENDENCIES_REQUIRED}
            PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
        )
    endif()
endforeach()

_qt5_3DRender_process_prl_file(
    "${_qt53DRender_install_prefix}/plugins/geometryloaders/libdefaultgeometryloader.prl" RELEASE
    _Qt5DefaultGeometryLoaderPlugin_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5DefaultGeometryLoaderPlugin_STATIC_RELEASE_LINK_FLAGS
)

_qt5_3DRender_process_prl_file(
    "${_qt53DRender_install_prefix}/plugins/geometryloaders/libdefaultgeometryloader_debug.prl" DEBUG
    _Qt5DefaultGeometryLoaderPlugin_STATIC_DEBUG_LIB_DEPENDENCIES
    _Qt5DefaultGeometryLoaderPlugin_STATIC_DEBUG_LINK_FLAGS
)

set_property(TARGET Qt5::DefaultGeometryLoaderPlugin PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt53DRender_DefaultGeometryLoaderPlugin_Import.cpp"
)

_populate_3DRender_plugin_properties(DefaultGeometryLoaderPlugin RELEASE "geometryloaders/libdefaultgeometryloader.a" TRUE)
_populate_3DRender_plugin_properties(DefaultGeometryLoaderPlugin DEBUG "geometryloaders/libdefaultgeometryloader_debug.a" TRUE)

list(APPEND Qt53DRender_PLUGINS Qt5::DefaultGeometryLoaderPlugin)
set_property(TARGET Qt5::3DRender APPEND PROPERTY QT_ALL_PLUGINS_geometryloaders Qt5::DefaultGeometryLoaderPlugin)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_geometryloaders>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_geometryloaders>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::DefaultGeometryLoaderPlugin,${_manual_plugins_genex};${_plugin_type_genex}>"
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
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::DefaultGeometryLoaderPlugin,QT_PLUGIN_EXTENDS>,Qt5::3DRender>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::DefaultGeometryLoaderPlugin,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::DefaultGeometryLoaderPlugin,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::DefaultGeometryLoaderPlugin>"
)
set_property(TARGET Qt5::3DRender APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::DefaultGeometryLoaderPlugin APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::3DRender;Qt5::3DCore;Qt5::3DRender;Qt5::3DCore;Qt5::Gui;Qt5::Core;Qt5::Core"
)
set_property(TARGET Qt5::DefaultGeometryLoaderPlugin PROPERTY QT_PLUGIN_TYPE "geometryloaders")
set_property(TARGET Qt5::DefaultGeometryLoaderPlugin PROPERTY QT_PLUGIN_EXTENDS "")
