
add_library(Qt5::IOSSensorPlugin MODULE IMPORTED)

set(_Qt5IOSSensorPlugin_MODULE_DEPENDENCIES "Sensors;Core")

foreach(_module_dep ${_Qt5IOSSensorPlugin_MODULE_DEPENDENCIES})
    if(NOT Qt5${_module_dep}_FOUND)
        find_package(Qt5${_module_dep}
            1.0.0 ${_Qt5Sensors_FIND_VERSION_EXACT}
            ${_Qt5Sensors_DEPENDENCIES_FIND_QUIET}
            ${_Qt5Sensors_FIND_DEPENDENCIES_REQUIRED}
            PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
        )
    endif()
endforeach()

_qt5_Sensors_process_prl_file(
    "${_qt5Sensors_install_prefix}/plugins/sensors/libqtsensors_ios.prl" RELEASE
    _Qt5IOSSensorPlugin_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5IOSSensorPlugin_STATIC_RELEASE_LINK_FLAGS
)

_qt5_Sensors_process_prl_file(
    "${_qt5Sensors_install_prefix}/plugins/sensors/libqtsensors_ios_debug.prl" DEBUG
    _Qt5IOSSensorPlugin_STATIC_DEBUG_LIB_DEPENDENCIES
    _Qt5IOSSensorPlugin_STATIC_DEBUG_LINK_FLAGS
)

set_property(TARGET Qt5::IOSSensorPlugin PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt5Sensors_IOSSensorPlugin_Import.cpp"
)

_populate_Sensors_plugin_properties(IOSSensorPlugin RELEASE "sensors/libqtsensors_ios.a" TRUE)
_populate_Sensors_plugin_properties(IOSSensorPlugin DEBUG "sensors/libqtsensors_ios_debug.a" TRUE)

list(APPEND Qt5Sensors_PLUGINS Qt5::IOSSensorPlugin)
set_property(TARGET Qt5::Sensors APPEND PROPERTY QT_ALL_PLUGINS_sensors Qt5::IOSSensorPlugin)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_sensors>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_sensors>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::IOSSensorPlugin,${_manual_plugins_genex};${_plugin_type_genex}>"
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
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::IOSSensorPlugin,QT_PLUGIN_EXTENDS>,Qt5::Sensors>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::IOSSensorPlugin,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::IOSSensorPlugin,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::IOSSensorPlugin>"
)
set_property(TARGET Qt5::Sensors APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::IOSSensorPlugin APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::Sensors;Qt5::Core"
)
set_property(TARGET Qt5::IOSSensorPlugin PROPERTY QT_PLUGIN_TYPE "sensors")
set_property(TARGET Qt5::IOSSensorPlugin PROPERTY QT_PLUGIN_EXTENDS "")
