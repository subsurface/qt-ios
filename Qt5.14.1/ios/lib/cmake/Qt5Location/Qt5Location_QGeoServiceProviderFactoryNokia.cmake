
add_library(Qt5::QGeoServiceProviderFactoryNokia MODULE IMPORTED)

set(_Qt5QGeoServiceProviderFactoryNokia_MODULE_DEPENDENCIES "Location;Location;Location;Positioning;Location;Gui;Network;Core")

foreach(_module_dep ${_Qt5QGeoServiceProviderFactoryNokia_MODULE_DEPENDENCIES})
    if(NOT Qt5${_module_dep}_FOUND)
        find_package(Qt5${_module_dep}
            1.0.0 ${_Qt5Location_FIND_VERSION_EXACT}
            ${_Qt5Location_DEPENDENCIES_FIND_QUIET}
            ${_Qt5Location_FIND_DEPENDENCIES_REQUIRED}
            PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
        )
    endif()
endforeach()

_qt5_Location_process_prl_file(
    "${_qt5Location_install_prefix}/plugins/geoservices/libqtgeoservices_nokia.prl" RELEASE
    _Qt5QGeoServiceProviderFactoryNokia_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5QGeoServiceProviderFactoryNokia_STATIC_RELEASE_LINK_FLAGS
)

_qt5_Location_process_prl_file(
    "${_qt5Location_install_prefix}/plugins/geoservices/libqtgeoservices_nokia_debug.prl" DEBUG
    _Qt5QGeoServiceProviderFactoryNokia_STATIC_DEBUG_LIB_DEPENDENCIES
    _Qt5QGeoServiceProviderFactoryNokia_STATIC_DEBUG_LINK_FLAGS
)

set_property(TARGET Qt5::QGeoServiceProviderFactoryNokia PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt5Location_QGeoServiceProviderFactoryNokia_Import.cpp"
)

_populate_Location_plugin_properties(QGeoServiceProviderFactoryNokia RELEASE "geoservices/libqtgeoservices_nokia.a" TRUE)
_populate_Location_plugin_properties(QGeoServiceProviderFactoryNokia DEBUG "geoservices/libqtgeoservices_nokia_debug.a" TRUE)

list(APPEND Qt5Location_PLUGINS Qt5::QGeoServiceProviderFactoryNokia)
set_property(TARGET Qt5::Location APPEND PROPERTY QT_ALL_PLUGINS_geoservices Qt5::QGeoServiceProviderFactoryNokia)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_geoservices>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_geoservices>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::QGeoServiceProviderFactoryNokia,${_manual_plugins_genex};${_plugin_type_genex}>"
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
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QGeoServiceProviderFactoryNokia,QT_PLUGIN_EXTENDS>,Qt5::Location>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QGeoServiceProviderFactoryNokia,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::QGeoServiceProviderFactoryNokia,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::QGeoServiceProviderFactoryNokia>"
)
set_property(TARGET Qt5::Location APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::QGeoServiceProviderFactoryNokia APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::Location;Qt5::Location;Qt5::Location;Qt5::Positioning;Qt5::Location;Qt5::Gui;Qt5::Network;Qt5::Core"
)
set_property(TARGET Qt5::QGeoServiceProviderFactoryNokia PROPERTY QT_PLUGIN_TYPE "geoservices")
set_property(TARGET Qt5::QGeoServiceProviderFactoryNokia PROPERTY QT_PLUGIN_EXTENDS "")
