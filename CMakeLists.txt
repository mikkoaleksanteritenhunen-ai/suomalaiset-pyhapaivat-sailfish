cmake_minimum_required(VERSION 3.19)

project(
    harbour-suomalaisetpyhapaivat
    LANGUAGES CXX
)

# ------------------------------------------------------------------
# Sovelluksen perustiedot
# ------------------------------------------------------------------

set(
    TARGET_NAME
    "harbour-suomalaisetpyhapaivat"
)

set(
    APP_DATA_DIR
    "share/${TARGET_NAME}"
)

set(
    TRANSLATIONS_SOURCE_DIR
    "${CMAKE_CURRENT_SOURCE_DIR}/translations"
)

set(
    TRANSLATIONS_BINARY_DIR
    "${CMAKE_CURRENT_BINARY_DIR}/translations"
)

# ------------------------------------------------------------------
# Qt5 ja Sailfish OS
# ------------------------------------------------------------------

find_package(
    Qt5
    REQUIRED
    COMPONENTS
        Core
        Gui
        Network
        Qml
        Quick
        LinguistTools
)

find_package(
    PkgConfig
    REQUIRED
)

pkg_check_modules(
    SAILFISH
    REQUIRED
    IMPORTED_TARGET
    sailfishapp
)

set(CMAKE_AUTOMOC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# ------------------------------------------------------------------
# C++-lähdetiedostot
# ------------------------------------------------------------------

set(
    APPLICATION_SOURCES
    src/SuomalaisetPyhapaivat.cpp
    src/calendarexporter.cpp
)

set(
    APPLICATION_HEADERS
    src/calendarexporter.h
)

foreach(SOURCE_FILE IN LISTS APPLICATION_SOURCES)
    set(
        SOURCE_PATH
        "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_FILE}"
    )

    if(NOT EXISTS "${SOURCE_PATH}")
        message(
            FATAL_ERROR
            "Required source file is missing: ${SOURCE_PATH}"
        )
    endif()

    message(
        STATUS
        "Source file found: ${SOURCE_FILE}"
    )
endforeach()

foreach(HEADER_FILE IN LISTS APPLICATION_HEADERS)
    set(
        HEADER_PATH
        "${CMAKE_CURRENT_SOURCE_DIR}/${HEADER_FILE}"
    )

    if(NOT EXISTS "${HEADER_PATH}")
        message(
            FATAL_ERROR
            "Required header file is missing: ${HEADER_PATH}"
        )
    endif()

    message(
        STATUS
        "Header file found: ${HEADER_FILE}"
    )
endforeach()

# ------------------------------------------------------------------
# Sovelluksen suoritettava ohjelma
# ------------------------------------------------------------------

add_executable(
    ${TARGET_NAME}
    ${APPLICATION_SOURCES}
    ${APPLICATION_HEADERS}
)

target_compile_features(
    ${TARGET_NAME}
    PRIVATE
        cxx_std_11
)

target_compile_definitions(
    ${TARGET_NAME}
    PRIVATE
        $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)

target_include_directories(
    ${TARGET_NAME}
    PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/src"
)

target_link_libraries(
    ${TARGET_NAME}
    PRIVATE
        Qt5::Core
        Qt5::Gui
        Qt5::Network
        Qt5::Qml
        Qt5::Quick
        PkgConfig::SAILFISH
)

# ------------------------------------------------------------------
# Sovelluksen asentaminen
# ------------------------------------------------------------------

install(
    TARGETS
        ${TARGET_NAME}

    RUNTIME DESTINATION
        bin
)

# ------------------------------------------------------------------
# QML-hakemisto
# ------------------------------------------------------------------

set(
    QML_SOURCE_DIR
    "${CMAKE_CURRENT_SOURCE_DIR}/qml"
)

if(NOT IS_DIRECTORY "${QML_SOURCE_DIR}")
    message(
        FATAL_ERROR
        "QML directory is missing: ${QML_SOURCE_DIR}"
    )
endif()

install(
    DIRECTORY
        "${QML_SOURCE_DIR}/"

    DESTINATION
        "${APP_DATA_DIR}/qml"
)

# ------------------------------------------------------------------
# Pakolliset QML-tiedostot
# ------------------------------------------------------------------

set(
    REQUIRED_QML_FILES
    qml/SuomalaisetPyhapaivat.qml
    qml/cover/CoverPage.qml
    qml/pages/FirstPage.qml
    qml/pages/CalendarExportPage.qml
    qml/js/HolidayData.js
)

foreach(QML_FILE IN LISTS REQUIRED_QML_FILES)
    set(
        QML_FILE_PATH
        "${CMAKE_CURRENT_SOURCE_DIR}/${QML_FILE}"
    )

    if(NOT EXISTS "${QML_FILE_PATH}")
        message(
            FATAL_ERROR
            "Required QML or JavaScript file is missing: "
            "${QML_FILE_PATH}"
        )
    endif()

    message(
        STATUS
        "QML or JavaScript file found: ${QML_FILE}"
    )
endforeach()

# ------------------------------------------------------------------
# Kalenteriviennin tiedostot
# ------------------------------------------------------------------

set(
    CALENDAR_EXPORT_FILES
    qml/pages/CalendarExportPage.qml
    qml/js/HolidayData.js
    src/calendarexporter.cpp
    src/calendarexporter.h
)

foreach(CALENDAR_EXPORT_FILE IN LISTS CALENDAR_EXPORT_FILES)
    set(
        CALENDAR_EXPORT_PATH
        "${CMAKE_CURRENT_SOURCE_DIR}/${CALENDAR_EXPORT_FILE}"
    )

    if(NOT EXISTS "${CALENDAR_EXPORT_PATH}")
        message(
            FATAL_ERROR
            "Calendar export file is missing: "
            "${CALENDAR_EXPORT_PATH}"
        )
    endif()

    message(
        STATUS
        "Calendar export file found: ${CALENDAR_EXPORT_FILE}"
    )
endforeach()

# ------------------------------------------------------------------
# Käännökset
#
# Suomi on lähdekieli. Suomenkielistä QM-tiedostoa ei tarvita,
# koska QML- ja C++-lähdetekstit ovat suomeksi.
#
# Muut löytyvät TS-tiedostot muunnetaan QM-tiedostoiksi Qt5:n
# qt5_add_translation()-toiminnolla.
# ------------------------------------------------------------------

set(
    TRANSLATION_LANGUAGES
    da
    de
    en
    es
    et
    fr
    it
    nb
    ru
    sv
    uk
)

set(TS_FILES)

if(IS_DIRECTORY "${TRANSLATIONS_SOURCE_DIR}")
    message(
        STATUS
        "Translations directory: ${TRANSLATIONS_SOURCE_DIR}"
    )

    foreach(LANGUAGE_CODE IN LISTS TRANSLATION_LANGUAGES)
        set(
            TS_FILE
            "${TRANSLATIONS_SOURCE_DIR}/${TARGET_NAME}-${LANGUAGE_CODE}.ts"
        )

        if(EXISTS "${TS_FILE}")
            list(
                APPEND
                TS_FILES
                "${TS_FILE}"
            )

            message(
                STATUS
                "Translation file found: "
                "${TARGET_NAME}-${LANGUAGE_CODE}.ts"
            )
        else()
            message(
                WARNING
                "Translation file is missing and will be skipped: "
                "${TS_FILE}"
            )
        endif()
    endforeach()
else()
    message(
        WARNING
        "Translations directory is missing. "
        "The application will use Finnish source texts only: "
        "${TRANSLATIONS_SOURCE_DIR}"
    )
endif()

set(QM_FILES)

if(TS_FILES)
    file(
        MAKE_DIRECTORY
        "${TRANSLATIONS_BINARY_DIR}"
    )

    qt5_add_translation(
        QM_FILES
        ${TS_FILES}
    )

    add_custom_target(
        translations
        ALL
        DEPENDS
            ${QM_FILES}
    )

    add_dependencies(
        ${TARGET_NAME}
        translations
    )

    install(
        FILES
            ${QM_FILES}

        DESTINATION
            "${APP_DATA_DIR}/translations"
    )

    message(
        STATUS
        "Translation packages to be generated:"
    )

    foreach(QM_FILE IN LISTS QM_FILES)
        message(
            STATUS
            "  ${QM_FILE}"
        )
    endforeach()
else()
    message(
        WARNING
        "No TS translation files were found. "
        "The application will be built with Finnish source texts only."
    )
endif()

# ------------------------------------------------------------------
# Desktop-tiedosto
# ------------------------------------------------------------------

set(
    DESKTOP_FILE
    "${CMAKE_CURRENT_SOURCE_DIR}/${TARGET_NAME}.desktop"
)

if(NOT EXISTS "${DESKTOP_FILE}")
    message(
        FATAL_ERROR
        "Desktop file is missing: ${DESKTOP_FILE}"
    )
endif()

install(
    FILES
        "${DESKTOP_FILE}"

    DESTINATION
        share/applications
)

message(
    STATUS
    "Desktop file found: ${DESKTOP_FILE}"
)

# ------------------------------------------------------------------
# Sovelluskuvakkeet
# ------------------------------------------------------------------

set(
    ICON_SIZES
    86x86
    108x108
    128x128
    172x172
)

set(ICON_FILES)

foreach(ICON_SIZE IN LISTS ICON_SIZES)
    set(
        ICON_FILE
        "${CMAKE_CURRENT_SOURCE_DIR}/icons/${ICON_SIZE}/${TARGET_NAME}.png"
    )

    if(EXISTS "${ICON_FILE}")
        list(
            APPEND
            ICON_FILES
            "${ICON_FILE}"
        )

        install(
            FILES
                "${ICON_FILE}"

            DESTINATION
                "share/icons/hicolor/${ICON_SIZE}/apps"
        )

        message(
            STATUS
            "Application icon found: ${ICON_FILE}"
        )
    else()
        message(
            WARNING
            "Optional application icon is missing: ${ICON_FILE}"
        )
    endif()
endforeach()

# ------------------------------------------------------------------
# Valinnaiset kuvatiedostot
# ------------------------------------------------------------------

set(
    OPTIONAL_IMAGE_CANDIDATES
    qml/images/finnish_flag.png
    qml/images/eu_flag.png
    qml/images/AI-score-V.png
)

set(OPTIONAL_IMAGE_FILES)

foreach(IMAGE_FILE IN LISTS OPTIONAL_IMAGE_CANDIDATES)
    set(
        IMAGE_FILE_PATH
        "${CMAKE_CURRENT_SOURCE_DIR}/${IMAGE_FILE}"
    )

    if(EXISTS "${IMAGE_FILE_PATH}")
        list(
            APPEND
            OPTIONAL_IMAGE_FILES
            "${IMAGE_FILE}"
        )

        message(
            STATUS
            "Optional image found: ${IMAGE_FILE}"
        )
    else()
        message(
            WARNING
            "Optional image is missing: ${IMAGE_FILE}"
        )
    endif()
endforeach()

# ------------------------------------------------------------------
# Valinnaiset QML-sivut
#
# Nämä lisätään Qt Creatorin projektipuuhun vain, jos tiedosto löytyy.
# QML-hakemisto asennetaan joka tapauksessa kokonaisuudessaan.
# ------------------------------------------------------------------

set(
    OPTIONAL_QML_CANDIDATES
    qml/pages/FlagDaysPage.qml
    qml/pages/SearchPage.qml
    qml/pages/SettingsPage.qml
    qml/pages/YearHolidaysPage.qml
    qml/pages/DayDetailPage.qml
    qml/pages/AboutPage.qml
)

set(OPTIONAL_QML_FILES)

foreach(OPTIONAL_QML_FILE IN LISTS OPTIONAL_QML_CANDIDATES)
    if(EXISTS
       "${CMAKE_CURRENT_SOURCE_DIR}/${OPTIONAL_QML_FILE}")
        list(
            APPEND
            OPTIONAL_QML_FILES
            "${OPTIONAL_QML_FILE}"
        )
    else()
        message(
            WARNING
            "Optional QML page is missing: "
            "${OPTIONAL_QML_FILE}"
        )
    endif()
endforeach()

# ------------------------------------------------------------------
# RPM-tiedostot
# ------------------------------------------------------------------

set(RPM_FILES)

set(
    RPM_FILE_CANDIDATES
    rpm/SuomalaisetPyhapaivat.changes.in
    rpm/SuomalaisetPyhapaivat.spec
)

foreach(RPM_FILE IN LISTS RPM_FILE_CANDIDATES)
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${RPM_FILE}")
        list(
            APPEND
            RPM_FILES
            "${RPM_FILE}"
        )
    else()
        message(
            WARNING
            "Optional RPM file is missing: ${RPM_FILE}"
        )
    endif()
endforeach()

# ------------------------------------------------------------------
# Qt Creatorissa ja lähdepaketissa näkyvät tiedostot
# ------------------------------------------------------------------

add_custom_target(
    distfiles

    SOURCES
        ${TARGET_NAME}.desktop

        ${APPLICATION_SOURCES}
        ${APPLICATION_HEADERS}

        qml/SuomalaisetPyhapaivat.qml
        qml/cover/CoverPage.qml

        qml/pages/FirstPage.qml
        qml/pages/CalendarExportPage.qml

        qml/js/HolidayData.js

        ${OPTIONAL_QML_FILES}
        ${OPTIONAL_IMAGE_FILES}
        ${ICON_FILES}
        ${TS_FILES}
        ${RPM_FILES}
)

# ------------------------------------------------------------------
# Sailfish SDK:n käyttämä QtCreatorDeployment.txt
# ------------------------------------------------------------------

file(
    WRITE
    "${CMAKE_BINARY_DIR}/QtCreatorDeployment.txt"

    "${CMAKE_INSTALL_PREFIX}\n"
    "${CMAKE_BINARY_DIR}/${TARGET_NAME}:bin\n"
)

# ------------------------------------------------------------------
# Rakennusyhteenveto
# ------------------------------------------------------------------

message(
    STATUS
    "------------------------------------------------------------"
)

message(
    STATUS
    "Application target: ${TARGET_NAME}"
)

message(
    STATUS
    "Source directory: ${CMAKE_CURRENT_SOURCE_DIR}"
)

message(
    STATUS
    "Binary directory: ${CMAKE_CURRENT_BINARY_DIR}"
)

message(
    STATUS
    "QML installation directory: "
    "${CMAKE_INSTALL_PREFIX}/${APP_DATA_DIR}/qml"
)

message(
    STATUS
    "Translation installation directory: "
    "${CMAKE_INSTALL_PREFIX}/${APP_DATA_DIR}/translations"
)

message(
    STATUS
    "Calendar export support is enabled."
)

message(
    STATUS
    "------------------------------------------------------------"
)
