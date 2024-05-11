
add_library(Qt5::QSQLiteDriverPlugin MODULE IMPORTED)

set(_Qt5QSQLiteDriverPlugin_MODULE_DEPENDENCIES "Sql;Core;Core")

foreach(_module_dep ${_Qt5QSQLiteDriverPlugin_MODULE_DEPENDENCIES})
    if(NOT Qt5${_module_dep}_FOUND)
        find_package(Qt5${_module_dep}
            1.0.0 ${_Qt5Sql_FIND_VERSION_EXACT}
            ${_Qt5Sql_DEPENDENCIES_FIND_QUIET}
            ${_Qt5Sql_FIND_DEPENDENCIES_REQUIRED}
            PATHS "${CMAKE_CURRENT_LIST_DIR}/.." NO_DEFAULT_PATH
        )
    endif()
endforeach()

_qt5_Sql_process_prl_file(
    "${_qt5Sql_install_prefix}/plugins/sqldrivers/libqsqlite.prl" RELEASE
    _Qt5QSQLiteDriverPlugin_STATIC_RELEASE_LIB_DEPENDENCIES
    _Qt5QSQLiteDriverPlugin_STATIC_RELEASE_LINK_FLAGS
)

_qt5_Sql_process_prl_file(
    "${_qt5Sql_install_prefix}/plugins/sqldrivers/libqsqlite_debug.prl" DEBUG
    _Qt5QSQLiteDriverPlugin_STATIC_DEBUG_LIB_DEPENDENCIES
    _Qt5QSQLiteDriverPlugin_STATIC_DEBUG_LINK_FLAGS
)

set_property(TARGET Qt5::QSQLiteDriverPlugin PROPERTY INTERFACE_SOURCES
    "${CMAKE_CURRENT_LIST_DIR}/Qt5Sql_QSQLiteDriverPlugin_Import.cpp"
)

_populate_Sql_plugin_properties(QSQLiteDriverPlugin RELEASE "sqldrivers/libqsqlite.a" TRUE)
_populate_Sql_plugin_properties(QSQLiteDriverPlugin DEBUG "sqldrivers/libqsqlite_debug.a" TRUE)

list(APPEND Qt5Sql_PLUGINS Qt5::QSQLiteDriverPlugin)
set_property(TARGET Qt5::Sql APPEND PROPERTY QT_ALL_PLUGINS_sqldrivers Qt5::QSQLiteDriverPlugin)
# $<GENEX_EVAL:...> wasn't added until CMake 3.12, so put a version guard around it
if(CMAKE_VERSION VERSION_LESS "3.12")
    set(_manual_plugins_genex "$<TARGET_PROPERTY:QT_PLUGINS>")
    set(_plugin_type_genex "$<TARGET_PROPERTY:QT_PLUGINS_sqldrivers>")
    set(_no_plugins_genex "$<TARGET_PROPERTY:QT_NO_PLUGINS>")
else()
    set(_manual_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS>>")
    set(_plugin_type_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_PLUGINS_sqldrivers>>")
    set(_no_plugins_genex "$<GENEX_EVAL:$<TARGET_PROPERTY:QT_NO_PLUGINS>>")
endif()
set(_user_specified_genex
    "$<IN_LIST:Qt5::QSQLiteDriverPlugin,${_manual_plugins_genex};${_plugin_type_genex}>"
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
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QSQLiteDriverPlugin,QT_PLUGIN_EXTENDS>,Qt5::Sql>,"
                "$<STREQUAL:$<TARGET_PROPERTY:Qt5::QSQLiteDriverPlugin,QT_PLUGIN_EXTENDS>,>"
            ">,"
            "$<NOT:$<IN_LIST:Qt5::QSQLiteDriverPlugin,${_no_plugins_genex}>>"
        ">"
    ">:Qt5::QSQLiteDriverPlugin>"
)
set_property(TARGET Qt5::Sql APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    ${_plugin_genex}
)
set_property(TARGET Qt5::QSQLiteDriverPlugin APPEND PROPERTY INTERFACE_LINK_LIBRARIES
    "Qt5::Sql;Qt5::Core;Qt5::Core"
)
set_property(TARGET Qt5::QSQLiteDriverPlugin PROPERTY QT_PLUGIN_TYPE "sqldrivers")
set_property(TARGET Qt5::QSQLiteDriverPlugin PROPERTY QT_PLUGIN_EXTENDS "")
