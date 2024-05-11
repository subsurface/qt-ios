
add_library(Qt5::QShakeSensorGesturePlugin MODULE IMPORTED)

set(_Qt5QShakeSensorGesturePlugin_MODULE_DEPENDENCIES "Sensors;Core")

foreach(_module_dep ${_Qt5QShakeSensorGesturePlugin_MODULE_DEPENDENCIES})
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
    "${_qt5Sensors_install_prefix}/plugins/sensorgestures/libqtsensorgestures_shakeplugin.prl" RELEASE
    _Qt5QShakeSensorGesturePlugin_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5QShakeSensorGesturePlugin_STATIC_RELEASE_LINK_FLAGS
)

_qt5_Sensors_process_prl_file(
    "${_qt5Sensors_install_prefix}/plugins/sensorgestures/libqtsensorgestures_shakeplugin_debug.prl" DEBUG
    _Qt5QShakeSensorGesturePlugin_STATIC_DEBUG_LIB_DEPENDENCIES
    _Qt5QShakeSensorGesturePlugin_STATIC_DEBUG_LINK_FLAGS
)

set_property(TARGET Qt5::QShakeSensorGesturePlugin PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt5Sensors_QShakeSensorGesturePlugin_Import.cpp"
)

_populate_Sensors_plugin_properties(QShakeSensorGesturePlugin RELEASE "sensorgestures/libqtsensorgestures_shakeplugin.a" TRUE)
_populate_Sensors_plugin_properties(QShakeSensorGesturePlugin DEBUG "sensorgestures/libqtsensorgestures_shakeplugin_debug.a" TRUE)

list(APPEND Qt5Sensors_PLUGINS Qt5::QShakeSensorGesturePlugin)
set_property(TARGET Qt5::Sensors APPEND PROPERTY QT_ALL_PLUGINS_sensorgestures Qt5::QShakeSensorGesturePlugin)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_sensorgestures>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_sensorgestures>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::QShakeSensorGesturePlugin,${_manual_plugins_genex};${_plugin_type_genex}>"
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
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QShakeSensorGesturePlugin,QT_PLUGIN_EXTENDS>,Qt5::Sensors>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QShakeSensorGesturePlugin,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::QShakeSensorGesturePlugin,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::QShakeSensorGesturePlugin>"
)
set_property(TARGET Qt5::Sensors APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::QShakeSensorGesturePlugin APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::Sensors;Qt5::Core"
)
set_property(TARGET Qt5::QShakeSensorGesturePlugin PROPERTY QT_PLUGIN_TYPE "sensorgestures")
set_property(TARGET Qt5::QShakeSensorGesturePlugin PROPERTY QT_PLUGIN_EXTENDS "-")
