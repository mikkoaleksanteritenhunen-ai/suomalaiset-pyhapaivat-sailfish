import QtQuick 2.6
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0
import org.nemomobile.notifications 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    property bool pageReady: false
    property bool languageComboReady: false
    property bool holidayColorComboReady: false
    property bool flagDayColorComboReady: false
    property bool languageChanged: false
    property bool restartInProgress: false

    Timer {
        id: settingsReadyTimer
        interval: 1
        repeat: false
        onTriggered: {
            pageReady = true
            languageComboReady = true
            holidayColorComboReady = true
            flagDayColorComboReady = true
        }
    }

    Timer {
        id: applicationRestartTimer
        interval: 1200
        repeat: false
        onTriggered: {
            restartRequestedSetting.value = true
            applicationQuitTimer.restart()
        }
    }

    Timer {
        id: applicationQuitTimer
        interval: 700
        repeat: false
        onTriggered: Qt.quit()
    }

    ConfigurationValue { id: languageSetting; key: "/apps/suomalaisetpyhapaivat/language"; defaultValue: "system" }
    ConfigurationValue { id: restartRequestedSetting; key: "/apps/suomalaisetpyhapaivat/restartRequested"; defaultValue: false }
    ConfigurationValue { id: showStartupSummarySetting; key: "/apps/suomalaisetpyhapaivat/showStartupSummary"; defaultValue: true }
    ConfigurationValue { id: highlightHolidaysSetting; key: "/apps/suomalaisetpyhapaivat/highlightHolidays"; defaultValue: true }
    ConfigurationValue { id: highlightWeekendsSetting; key: "/apps/suomalaisetpyhapaivat/highlightWeekends"; defaultValue: true }
    ConfigurationValue { id: showFlagDaysSetting; key: "/apps/suomalaisetpyhapaivat/showFlagDays"; defaultValue: true }
    ConfigurationValue { id: showWeekNumbersSetting; key: "/apps/suomalaisetpyhapaivat/showWeekNumbers"; defaultValue: true }
    ConfigurationValue { id: highlightTodaySetting; key: "/apps/suomalaisetpyhapaivat/highlightToday"; defaultValue: true }
    ConfigurationValue { id: showNextHolidaySetting; key: "/apps/suomalaisetpyhapaivat/showNextHoliday"; defaultValue: true }
    ConfigurationValue { id: showNextFlagDaySetting; key: "/apps/suomalaisetpyhapaivat/showNextFlagDay"; defaultValue: true }
    ConfigurationValue { id: dimPastDaysSetting; key: "/apps/suomalaisetpyhapaivat/dimPastDays"; defaultValue: false }
    ConfigurationValue { id: largeCalendarSetting; key: "/apps/suomalaisetpyhapaivat/largeCalendar"; defaultValue: true }
    ConfigurationValue { id: liveSearchSetting; key: "/apps/suomalaisetpyhapaivat/liveSearch"; defaultValue: true }
    ConfigurationValue { id: showResultCountSetting; key: "/apps/suomalaisetpyhapaivat/showResultCount"; defaultValue: true }
    ConfigurationValue { id: highlightSearchTermsSetting; key: "/apps/suomalaisetpyhapaivat/highlightSearchTerms"; defaultValue: true }
    ConfigurationValue { id: holidayColorSetting; key: "/apps/suomalaisetpyhapaivat/holidayColor"; defaultValue: "#C62828" }
    ConfigurationValue { id: flagDayColorSetting; key: "/apps/suomalaisetpyhapaivat/flagDayColor"; defaultValue: "#005BBB" }
    ConfigurationValue { id: holidayNotificationSetting; key: "/apps/suomalaisetpyhapaivat/holidayNotification"; defaultValue: false }
    ConfigurationValue { id: flagDayNotificationSetting; key: "/apps/suomalaisetpyhapaivat/flagDayNotification"; defaultValue: false }
    ConfigurationValue { id: startupNotificationSetting; key: "/apps/suomalaisetpyhapaivat/startupNotification"; defaultValue: false }

    Notification {
        id: testNotification
        appName: qsTr("Suomalaiset Pyhäpäivät")
        summary: qsTr("Testi-ilmoitus")
        body: qsTr("Sovelluksen ilmoitukset toimivat.")
    }

    function settingBoolean(value, fallbackValue) {
        if (value === undefined || value === null)
            return fallbackValue
        return Boolean(value)
    }

    function languageIndex() {
        var language = languageSetting.value
        if (language === undefined || language === null || String(language).length === 0)
            language = "system"

        switch (String(language)) {
        case "fi": return 1
        case "da": return 2
        case "de": return 3
        case "en": return 4
        case "es": return 5
        case "fr": return 6
        case "it": return 7
        case "nb": return 8
        case "ru": return 9
        case "sv": return 10
        case "uk": return 11
        default: return 0
        }
    }

    function languageCode(index) {
        switch (index) {
        case 1: return "fi"
        case 2: return "da"
        case 3: return "de"
        case 4: return "en"
        case 5: return "es"
        case 6: return "fr"
        case 7: return "it"
        case 8: return "nb"
        case 9: return "ru"
        case 10: return "sv"
        case 11: return "uk"
        default: return "system"
        }
    }

    function holidayColorValue() {
        var value = holidayColorSetting.value
        return value === undefined || value === null || String(value).length === 0 ? "#C62828" : String(value)
    }

    function flagDayColorValue() {
        var value = flagDayColorSetting.value
        return value === undefined || value === null || String(value).length === 0 ? "#005BBB" : String(value)
    }

    function holidayColorIndex() {
        switch (holidayColorValue()) {
        case "#EF6C00": return 1
        case "#7B1FA2": return 2
        case "#2E7D32": return 3
        default: return 0
        }
    }

    function flagDayColorIndex() {
        switch (flagDayColorValue()) {
        case "#039BE5": return 1
        case "#00838F": return 2
        case "#2E7D32": return 3
        default: return 0
        }
    }

    function setHolidayColor(index) {
        switch (index) {
        case 1: holidayColorSetting.value = "#EF6C00"; break
        case 2: holidayColorSetting.value = "#7B1FA2"; break
        case 3: holidayColorSetting.value = "#2E7D32"; break
        default: holidayColorSetting.value = "#C62828"; break
        }
    }

    function setFlagDayColor(index) {
        switch (index) {
        case 1: flagDayColorSetting.value = "#039BE5"; break
        case 2: flagDayColorSetting.value = "#00838F"; break
        case 3: flagDayColorSetting.value = "#2E7D32"; break
        default: flagDayColorSetting.value = "#005BBB"; break
        }
    }

    function resetSettings() {
        pageReady = false
        languageComboReady = false
        holidayColorComboReady = false
        flagDayColorComboReady = false
        settingsReadyTimer.stop()
        applicationRestartTimer.stop()
        applicationQuitTimer.stop()

        languageSetting.value = "system"
        showStartupSummarySetting.value = true
        highlightHolidaysSetting.value = true
        highlightWeekendsSetting.value = true
        showFlagDaysSetting.value = true
        showWeekNumbersSetting.value = true
        highlightTodaySetting.value = true
        showNextHolidaySetting.value = true
        showNextFlagDaySetting.value = true
        dimPastDaysSetting.value = false
        largeCalendarSetting.value = true
        liveSearchSetting.value = true
        showResultCountSetting.value = true
        highlightSearchTermsSetting.value = true
        holidayColorSetting.value = "#C62828"
        flagDayColorSetting.value = "#005BBB"
        holidayNotificationSetting.value = false
        flagDayNotificationSetting.value = false
        startupNotificationSetting.value = false

        languageCombo.currentIndex = 0
        holidayColorCombo.currentIndex = 0
        flagDayColorCombo.currentIndex = 0
        languageChanged = true
        restartInProgress = false
        settingsReadyTimer.start()
    }

    Component.onCompleted: {
        pageReady = false
        languageComboReady = false
        holidayColorComboReady = false
        flagDayColorComboReady = false
        languageChanged = false
        restartInProgress = false
        settingsReadyTimer.stop()
        applicationRestartTimer.stop()
        applicationQuitTimer.stop()
        languageCombo.currentIndex = languageIndex()
        holidayColorCombo.currentIndex = holidayColorIndex()
        flagDayColorCombo.currentIndex = flagDayColorIndex()
        settingsReadyTimer.start()
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: contentColumn.height + Theme.paddingLarge

        PullDownMenu {
            MenuItem { text: qsTr("Etusivu"); onClicked: pageStack.clear() }
            MenuItem { text: qsTr("Haku"); onClicked: pageStack.push(Qt.resolvedUrl("SearchPage.qml")) }
            MenuItem { text: qsTr("Suomen liputuspäivät"); onClicked: pageStack.push(Qt.resolvedUrl("FlagDaysPage.qml")) }
            MenuItem { text: qsTr("Vuoden pyhäpäivät"); onClicked: pageStack.push(Qt.resolvedUrl("YearHolidaysPage.qml")) }
            MenuItem { text: qsTr("Tietoa sovelluksesta"); onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml")) }
        }

        VerticalScrollDecorator { }

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader { title: qsTr("Asetukset") }
            SectionHeader { text: qsTr("Kieli") }

            ComboBox {
                id: languageCombo
                width: parent.width
                label: qsTr("Sovelluksen kieli")
                menu: ContextMenu {
                    MenuItem { text: qsTr("Järjestelmän kieli") }
                    MenuItem { text: "Suomi" }
                    MenuItem { text: "Dansk" }
                    MenuItem { text: "Deutsch" }
                    MenuItem { text: "English" }
                    MenuItem { text: "Español" }
                    MenuItem { text: "Français" }
                    MenuItem { text: "Italiano" }
                    MenuItem { text: "Norsk bokmål" }
                    MenuItem { text: "Русский" }
                    MenuItem { text: "Svenska" }
                    MenuItem { text: "Українська" }
                }
                onCurrentIndexChanged: {
                    if (!languageComboReady || currentIndex < 0 || currentIndex > 11)
                        return

                    var selectedLanguage = languageCode(currentIndex)
                    var currentLanguage = languageSetting.value
                    if (currentLanguage === undefined || currentLanguage === null || String(currentLanguage).length === 0)
                        currentLanguage = "system"

                    if (String(currentLanguage) !== selectedLanguage) {
                        languageSetting.value = selectedLanguage
                        languageChanged = true
                        restartInProgress = false
                    }
                }
            }

            Label {
                visible: languageChanged
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: Theme.highlightColor
                text: qsTr("Kielivalinta on tallennettu. Käynnistä sovellus uudelleen, jotta uusi kieli otetaan käyttöön.")
            }

            Button {
                visible: languageChanged
                enabled: !restartInProgress
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                text: restartInProgress ? qsTr("Käynnistetään uudelleen...") : qsTr("Käynnistä sovellus uudelleen")
                onClicked: {
                    if (restartInProgress)
                        return
                    restartInProgress = true
                    applicationRestartTimer.restart()
                }
            }

            BusyIndicator {
                visible: restartInProgress
                running: restartInProgress
                size: BusyIndicatorSize.Medium
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                color: Theme.secondaryColor
                text: qsTr("Järjestelmän kieli käyttää laitteen kieliasetusta. Jos järjestelmän kielelle ei ole käännöstä, käytetään suomea.")
            }

            SectionHeader { text: qsTr("Näyttö") }
            TextSwitch { width: parent.width; text: qsTr("Näytä käynnistyksen yhteenveto"); checked: settingBoolean(showStartupSummarySetting.value, true); onCheckedChanged: if (pageReady && settingBoolean(showStartupSummarySetting.value, true) !== checked) showStartupSummarySetting.value = checked }
            TextSwitch { width: parent.width; text: qsTr("Korosta pyhäpäivät"); checked: settingBoolean(highlightHolidaysSetting.value, true); onCheckedChanged: if (pageReady && settingBoolean(highlightHolidaysSetting.value, true) !== checked) highlightHolidaysSetting.value = checked }
            TextSwitch { width: parent.width; text: qsTr("Korosta viikonloput"); checked: settingBoolean(highlightWeekendsSetting.value, true); onCheckedChanged: if (pageReady && settingBoolean(highlightWeekendsSetting.value, true) !== checked) highlightWeekendsSetting.value = checked }
            TextSwitch { width: parent.width; text: qsTr("Näytä liputuspäivät"); checked: settingBoolean(showFlagDaysSetting.value, true); onCheckedChanged: if (pageReady && settingBoolean(showFlagDaysSetting.value, true) !== checked) showFlagDaysSetting.value = checked }
            TextSwitch { width: parent.width; text: qsTr("Näytä viikkonumerot"); checked: settingBoolean(showWeekNumbersSetting.value, true); onCheckedChanged: if (pageReady && settingBoolean(showWeekNumbersSetting.value, true) !== checked) showWeekNumbersSetting.value = checked }

            Label { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; wrapMode: Text.WordWrap; color: Theme.secondaryColor; text: qsTr("Viikko alkaa aina maanantaista suomalaisen kalenterikäytännön mukaisesti.") }

            SectionHeader { text: qsTr("Kalenteri") }
            TextSwitch { width: parent.width; text: qsTr("Korosta tämän päivän päivämäärä"); checked: settingBoolean(highlightTodaySetting.value, true); onCheckedChanged: if (pageReady && settingBoolean(highlightTodaySetting.value, true) !== checked) highlightTodaySetting.value = checked }
            TextSwitch { width: parent.width; text: qsTr("Näytä seuraava pyhäpäivä"); checked: settingBoolean(showNextHolidaySetting.value, true); onCheckedChanged: if (pageReady && settingBoolean(showNextHolidaySetting.value, true) !== checked) showNextHolidaySetting.value = checked }
            TextSwitch { width: parent.width; text: qsTr("Näytä seuraava liputuspäivä"); checked: settingBoolean(showNextFlagDaySetting.value, true); onCheckedChanged: if (pageReady && settingBoolean(showNextFlagDaySetting.value, true) !== checked) showNextFlagDaySetting.value = checked }
            TextSwitch { width: parent.width; text: qsTr("Näytä menneet päivät himmennettynä"); checked: settingBoolean(dimPastDaysSetting.value, false); onCheckedChanged: if (pageReady && settingBoolean(dimPastDaysSetting.value, false) !== checked) dimPastDaysSetting.value = checked }
            TextSwitch { width: parent.width; text: qsTr("Suurempi kalenterinäkymä"); checked: settingBoolean(largeCalendarSetting.value, true); onCheckedChanged: if (pageReady && settingBoolean(largeCalendarSetting.value, true) !== checked) largeCalendarSetting.value = checked }

            SectionHeader { text: qsTr("Haku") }
            TextSwitch { width: parent.width; text: qsTr("Reaaliaikainen haku"); checked: settingBoolean(liveSearchSetting.value, true); onCheckedChanged: if (pageReady && settingBoolean(liveSearchSetting.value, true) !== checked) liveSearchSetting.value = checked }
            TextSwitch { width: parent.width; text: qsTr("Näytä hakutulosten määrä"); checked: settingBoolean(showResultCountSetting.value, true); onCheckedChanged: if (pageReady && settingBoolean(showResultCountSetting.value, true) !== checked) showResultCountSetting.value = checked }
            TextSwitch { width: parent.width; text: qsTr("Korosta hakusanat tuloksissa"); checked: settingBoolean(highlightSearchTermsSetting.value, true); onCheckedChanged: if (pageReady && settingBoolean(highlightSearchTermsSetting.value, true) !== checked) highlightSearchTermsSetting.value = checked }

            SectionHeader { text: qsTr("Ulkoasu") }
            Label { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; wrapMode: Text.WordWrap; color: Theme.secondaryColor; text: qsTr("Pyhäpäivän väri näkyy päivän taustana. Liputuspäivän väri näkyy päivän reunuksena.") }

            ComboBox {
                id: holidayColorCombo
                width: parent.width
                label: qsTr("Pyhäpäivän väri")
                menu: ContextMenu {
                    MenuItem { text: qsTr("Punainen") }
                    MenuItem { text: qsTr("Oranssi") }
                    MenuItem { text: qsTr("Violetti") }
                    MenuItem { text: qsTr("Vihreä") }
                }
                onCurrentIndexChanged: if (holidayColorComboReady && currentIndex >= 0 && currentIndex <= 3) setHolidayColor(currentIndex)
            }

            Rectangle { width: parent.width - Theme.horizontalPageMargin * 2; height: Theme.itemSizeSmall / 2; anchors.horizontalCenter: parent.horizontalCenter; radius: Theme.paddingSmall; color: holidayColorValue(); border.width: 1; border.color: Theme.secondaryColor }

            ComboBox {
                id: flagDayColorCombo
                width: parent.width
                label: qsTr("Liputuspäivän väri")
                menu: ContextMenu {
                    MenuItem { text: qsTr("Suomen sininen") }
                    MenuItem { text: qsTr("Vaaleansininen") }
                    MenuItem { text: qsTr("Turkoosi") }
                    MenuItem { text: qsTr("Vihreä") }
                }
                onCurrentIndexChanged: if (flagDayColorComboReady && currentIndex >= 0 && currentIndex <= 3) setFlagDayColor(currentIndex)
            }

            Rectangle { width: parent.width - Theme.horizontalPageMargin * 2; height: Theme.itemSizeSmall / 2; anchors.horizontalCenter: parent.horizontalCenter; radius: Theme.paddingSmall; color: flagDayColorValue(); border.width: 1; border.color: Theme.secondaryColor }

            SectionHeader { text: qsTr("Ilmoitukset") }
            Label { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; wrapMode: Text.WordWrap; color: Theme.secondaryColor; text: qsTr("Ilmoitusvalinnat tallennetaan heti. Nykyinen toteutus julkaisee valitut ilmoitukset sovelluksen käynnistyessä.") }
            TextSwitch { width: parent.width; text: qsTr("Ilmoita seuraavasta pyhäpäivästä"); checked: settingBoolean(holidayNotificationSetting.value, false); onCheckedChanged: if (pageReady && settingBoolean(holidayNotificationSetting.value, false) !== checked) holidayNotificationSetting.value = checked }
            TextSwitch { width: parent.width; text: qsTr("Ilmoita seuraavasta liputuspäivästä"); checked: settingBoolean(flagDayNotificationSetting.value, false); onCheckedChanged: if (pageReady && settingBoolean(flagDayNotificationSetting.value, false) !== checked) flagDayNotificationSetting.value = checked }
            TextSwitch { width: parent.width; text: qsTr("Näytä ilmoitus käynnistyksen yhteydessä"); checked: settingBoolean(startupNotificationSetting.value, false); onCheckedChanged: if (pageReady && settingBoolean(startupNotificationSetting.value, false) !== checked) startupNotificationSetting.value = checked }

            Button { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; text: qsTr("Testaa ilmoitusta"); onClicked: testNotification.publish() }

            SectionHeader { text: qsTr("Asetusten hallinta") }
            Button {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Palauta oletusasetukset")
                onClicked: resetRemorse.execute(qsTr("Palautetaan oletusasetukset"), function() { resetSettings() })
            }

            SectionHeader { text: qsTr("Sovelluksen tiedot") }
            Button { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; text: qsTr("Tietoa sovelluksesta"); onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml")) }
            Item { width: 1; height: Theme.paddingLarge }
        }
    }

    RemorsePopup { id: resetRemorse }
}
