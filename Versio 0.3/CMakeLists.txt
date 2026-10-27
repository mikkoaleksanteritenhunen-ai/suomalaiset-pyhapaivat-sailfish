cmake_minimum_required(VERSION 3.19)

project(harbour-suomalaisetpyhapaivat LANGUAGES CXX)

set(TARGET_NAME harbour-suomalaisetpyhapaivat)
set(APP_DATA_DIR "share/${TARGET_NAME}")
set(TRANSLATIONS_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/translations")
set(TRANSLATIONS_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/translations")

find_package(Qt5 REQUIRED COMPONENTS
    Core
    Gui
    Network
    Qml
    Quick
    LinguistTools
)

find_package(PkgConfig REQUIRED)
pkg_check_modules(SAILFISH REQUIRED IMPORTED_TARGET sailfishapp)

set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/SuomalaisetPyhapaivat.cpp")
    message(FATAL_ERROR
        "Lähdetiedosto puuttuu: src/SuomalaisetPyhapaivat.cpp"
    )
endif()

add_executable(${TARGET_NAME}
    src/SuomalaisetPyhapaivat.cpp
)

target_compile_features(${TARGET_NAME} PRIVATE
    cxx_std_11
)

target_compile_definitions(${TARGET_NAME} PRIVATE
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)

target_link_libraries(${TARGET_NAME} PRIVATE
    Qt5::Core
    Qt5::Gui
    Qt5::Network
    Qt5::Qml
    Qt5::Quick
    PkgConfig::SAILFISH
)

install(
    TARGETS ${TARGET_NAME}
    RUNTIME DESTINATION bin
)

install(
    DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/qml/"
    DESTINATION "${APP_DATA_DIR}/qml"
)

# Suomenkielistä QM-tiedostoa ei tarvita, koska QML-lähdetekstit
# ovat suomeksi. Kaikkien muiden käyttöliittymässä tarjottujen
# kielten TS-tiedostojen on oltava projektissa.
set(TRANSLATION_LANGUAGES
    da
    de
    en
    es
    fr
    it
    nb
    ru
    sv
    uk
)

set(TS_FILES)

foreach(LANGUAGE_CODE IN LISTS TRANSLATION_LANGUAGES)
    set(TS_FILE
        "${TRANSLATIONS_SOURCE_DIR}/${TARGET_NAME}-${LANGUAGE_CODE}.ts"
    )

    if(NOT EXISTS "${TS_FILE}")
        message(FATAL_ERROR
            "Pakollinen käännöstiedosto puuttuu: ${TS_FILE}"
        )
    endif()

    list(APPEND TS_FILES "${TS_FILE}")
    message(STATUS
        "Käännöstiedosto löytyi: ${TARGET_NAME}-${LANGUAGE_CODE}.ts"
    )
endforeach()

if(NOT Qt5_LRELEASE_EXECUTABLE)
    message(FATAL_ERROR
        "Qt5 lrelease -ohjelmaa ei löytynyt. Tarkista Qt5 LinguistTools -asennus."
    )
endif()

# Qt:n lrelease tuottaa QM-tiedostot build-hakemistoon.
file(MAKE_DIRECTORY "${TRANSLATIONS_BINARY_DIR}")

set(QM_FILES)

foreach(TS_FILE IN LISTS TS_FILES)
    get_filename_component(TRANSLATION_NAME "${TS_FILE}" NAME_WE)
    set(QM_FILE
        "${TRANSLATIONS_BINARY_DIR}/${TRANSLATION_NAME}.qm"
    )

    add_custom_command(
        OUTPUT "${QM_FILE}"
        COMMAND "${Qt5_LRELEASE_EXECUTABLE}"
            "${TS_FILE}"
            -qm "${QM_FILE}"
        DEPENDS "${TS_FILE}"
        COMMENT "Luodaan kielipaketti ${TRANSLATION_NAME}.qm"
        VERBATIM
    )

    list(APPEND QM_FILES "${QM_FILE}")
endforeach()

add_custom_target(translations ALL
    DEPENDS ${QM_FILES}
)

add_dependencies(${TARGET_NAME} translations)

install(
    FILES ${QM_FILES}
    DESTINATION "${APP_DATA_DIR}/translations"
)

message(STATUS "Asennettavat QM-kielipaketit:")
foreach(QM_FILE IN LISTS QM_FILES)
    message(STATUS "  ${QM_FILE}")
endforeach()

set(DESKTOP_FILE
    "${CMAKE_CURRENT_SOURCE_DIR}/${TARGET_NAME}.desktop"
)

if(NOT EXISTS "${DESKTOP_FILE}")
    message(FATAL_ERROR
        "Desktop-tiedosto puuttuu: ${DESKTOP_FILE}"
    )
endif()

install(
    FILES "${DESKTOP_FILE}"
    DESTINATION share/applications
)

set(ICON_SIZES
    86x86
    108x108
    128x128
    172x172
)

set(ICON_FILES)

foreach(ICON_SIZE IN LISTS ICON_SIZES)
    set(ICON_FILE
        "${CMAKE_CURRENT_SOURCE_DIR}/icons/${ICON_SIZE}/${TARGET_NAME}.png"
    )

    if(EXISTS "${ICON_FILE}")
        list(APPEND ICON_FILES "${ICON_FILE}")

        install(
            FILES "${ICON_FILE}"
            DESTINATION "share/icons/hicolor/${ICON_SIZE}/apps"
        )

        message(STATUS "Kuvake löytyi: ${ICON_FILE}")
    else()
        message(WARNING "Kuvake puuttuu: ${ICON_FILE}")
    endif()
endforeach()

add_custom_target(distfiles
    SOURCES
        ${TARGET_NAME}.desktop
        src/SuomalaisetPyhapaivat.cpp
        qml/SuomalaisetPyhapaivat.qml
        qml/cover/CoverPage.qml
        qml/pages/FirstPage.qml
        qml/pages/FlagDaysPage.qml
        qml/pages/SearchPage.qml
        qml/pages/SettingsPage.qml
        qml/pages/YearHolidaysPage.qml
        qml/pages/DayDetailPage.qml
        qml/pages/AboutPage.qml
        qml/images/finnish_flag.png
        qml/images/eu_flag.png
        ${ICON_FILES}
        ${TS_FILES}
        rpm/SuomalaisetPyhapaivat.changes.in
        rpm/SuomalaisetPyhapaivat.spec
)

file(
    WRITE
    "${CMAKE_BINARY_DIR}/QtCreatorDeployment.txt"
    "${CMAKE_INSTALL_PREFIX}\n"
    "${CMAKE_BINARY_DIR}/${TARGET_NAME}:bin\n"
)
