
add_library(Qt5::QQmlNativeDebugConnectorFactory MODULE IMPORTED)

set(_Qt5QQmlNativeDebugConnectorFactory_MODULE_DEPENDENCIES "Qml;PacketProtocol;Core")

foreach(_module_dep ${_Qt5QQmlNativeDebugConnectorFactory_MODULE_DEPENDENCIES})
    if(NOT Qt5${_module_dep}_FOUND)
        find_package(Qt5${_module_dep}
            1.0.0 ${_Qt5Qml_FIND_VERSION_EXACT}
            ${_Qt5Qml_DEPENDENCIES_FIND_QUIET}
            ${_Qt5Qml_FIND_DEPENDENCIES_REQUIRED}
            PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
        )
    endif()
endforeach()

_qt5_Qml_process_prl_file(
    "${_qt5Qml_install_prefix}/plugins/qmltooling/libqmldbg_native.prl" RELEASE
    _Qt5QQmlNativeDebugConnectorFactory_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5QQmlNativeDebugConnectorFactory_STATIC_RELEASE_LINK_FLAGS
)

_qt5_Qml_process_prl_file(
    "${_qt5Qml_install_prefix}/plugins/qmltooling/libqmldbg_native_debug.prl" DEBUG
    _Qt5QQmlNativeDebugConnectorFactory_STATIC_DEBUG_LIB_DEPENDENCIES
    _Qt5QQmlNativeDebugConnectorFactory_STATIC_DEBUG_LINK_FLAGS
)

set_property(TARGET Qt5::QQmlNativeDebugConnectorFactory PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt5Qml_QQmlNativeDebugConnectorFactory_Import.cpp"
)

_populate_Qml_plugin_properties(QQmlNativeDebugConnectorFactory RELEASE "qmltooling/libqmldbg_native.a" TRUE)
_populate_Qml_plugin_properties(QQmlNativeDebugConnectorFactory DEBUG "qmltooling/libqmldbg_native_debug.a" TRUE)

list(APPEND Qt5Qml_PLUGINS Qt5::QQmlNativeDebugConnectorFactory)
set_property(TARGET Qt5::Qml APPEND PROPERTY QT_ALL_PLUGINS_qmltooling Qt5::QQmlNativeDebugConnectorFactory)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_qmltooling>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_qmltooling>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::QQmlNativeDebugConnectorFactory,${_manual_plugins_genex};${_plugin_type_genex}>"
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
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QQmlNativeDebugConnectorFactory,QT_PLUGIN_EXTENDS>,Qt5::Qml>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QQmlNativeDebugConnectorFactory,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::QQmlNativeDebugConnectorFactory,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::QQmlNativeDebugConnectorFactory>"
)
set_property(TARGET Qt5::Qml APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::QQmlNativeDebugConnectorFactory APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::Qml;Qt5::PacketProtocol;Qt5::Core"
)
set_property(TARGET Qt5::QQmlNativeDebugConnectorFactory PROPERTY QT_PLUGIN_TYPE "qmltooling")
set_property(TARGET Qt5::QQmlNativeDebugConnectorFactory PROPERTY QT_PLUGIN_EXTENDS "")
