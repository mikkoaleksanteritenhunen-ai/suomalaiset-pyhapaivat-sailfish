import QtQuick 2.6
import Sailfish.Silica 1.0
import "../js/HolidayData.js" as HolidayData

Page {
    id: page
    allowedOrientations: Orientation.All

    property int exportYear: (new Date()).getFullYear()
    property bool includeHolidays: true
    property bool includeFlagDays: true
    property string resultMessage: ""
    property bool exportSuccessful: false

    function pad2(value) { return value < 10 ? "0" + value : value.toString() }
    function isoDate(year, month, day) { return year + "-" + pad2(month) + "-" + pad2(day) }
    function makeUid(type, year, month, day) { return type + "-" + year + "-" + pad2(month) + "-" + pad2(day) + "@suomalaisetpyhapaivat" }

    function buildExportEvents() {
        var events = []
        for (var month = 1; month <= 12; ++month) {
            var dayCount = new Date(exportYear, month, 0).getDate()
            for (var day = 1; day <= dayCount; ++day) {
                if (includeHolidays) {
                    var holiday = HolidayData.holidayName(exportYear, month, day)
                    if (holiday !== "") events.push({ uid: makeUid("holiday", exportYear, month, day), date: isoDate(exportYear, month, day), name: holiday, description: qsTr("Suomalainen pyhäpäivä"), category: qsTr("Pyhäpäivät") })
                }
                if (includeFlagDays) {
                    var flagDay = HolidayData.flagDayName(exportYear, month, day)
                    if (flagDay !== "") events.push({ uid: makeUid("flagday", exportYear, month, day), date: isoDate(exportYear, month, day), name: flagDay, description: qsTr("Suomen liputuspäivä"), category: qsTr("Liputuspäivät") })
                }
            }
        }
        return events
    }

    function exportFileName() {
        if (includeHolidays && includeFlagDays) return "suomen-pyha-ja-liputuspaivat-" + exportYear + ".ics"
        if (includeHolidays) return "suomen-pyhapaivat-" + exportYear + ".ics"
        return "suomen-liputuspaivat-" + exportYear + ".ics"
    }

    function exportCalendar() {
        resultMessage = ""
        exportSuccessful = false
        if (!includeHolidays && !includeFlagDays) { resultMessage = qsTr("Valitse vähintään yksi vietävä tapahtumatyyppi."); return }
        var events = buildExportEvents()
        if (events.length === 0) { resultMessage = qsTr("Valitulle vuodelle ei löytynyt tapahtumia."); return }
        exportSuccessful = calendarExporter.exportEvents(exportFileName(), events)
        resultMessage = exportSuccessful ? qsTr("%1 tapahtumaa vietiin tiedostoon:\n%2").arg(events.length).arg(calendarExporter.lastFilePath) : calendarExporter.lastError
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: exportColumn.height + Theme.paddingLarge
        VerticalScrollDecorator { }

        Column {
            id: exportColumn
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader { title: qsTr("Vie kalenteriin") }
            Label { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; wrapMode: Text.WordWrap; text: qsTr("Luo iCalendar-tiedosto valitun vuoden pyhäpäivistä, liputuspäivistä tai molemmista.") }

            SectionHeader { text: qsTr("Vuosi") }
            Row {
                id: yearRow
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingSmall
                Button { width: (yearRow.width - yearRow.spacing * 2) / 3; text: qsTr("Edellinen"); onClicked: exportYear -= 1 }
                Label { width: (yearRow.width - yearRow.spacing * 2) / 3; height: parent.height; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter; font.bold: true; font.pixelSize: Theme.fontSizeLarge; text: exportYear.toString() }
                Button { width: (yearRow.width - yearRow.spacing * 2) / 3; text: qsTr("Seuraava"); onClicked: exportYear += 1 }
            }
            Button { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; text: qsTr("Kuluva vuosi"); onClicked: exportYear = (new Date()).getFullYear() }

            SectionHeader { text: qsTr("Vietävät tapahtumat") }
            TextSwitch { width: parent.width; text: qsTr("Pyhäpäivät"); description: qsTr("Lisää vuoden suomalaiset pyhäpäivät."); checked: includeHolidays; onCheckedChanged: includeHolidays = checked }
            TextSwitch { width: parent.width; text: qsTr("Liputuspäivät"); description: qsTr("Lisää vuoden suomalaiset liputuspäivät."); checked: includeFlagDays; onCheckedChanged: includeFlagDays = checked }

            SectionHeader { text: qsTr("Tiedosto") }
            Label { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WrapAnywhere; color: Theme.secondaryColor; text: exportFileName() }
            Button { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; text: qsTr("Luo iCalendar-tiedosto"); enabled: includeHolidays || includeFlagDays; onClicked: exportCalendar() }
            Label { visible: resultMessage !== ""; width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WrapAnywhere; color: exportSuccessful ? Theme.highlightColor : Theme.errorColor; text: resultMessage }
            Button { visible: exportSuccessful && calendarExporter.lastFilePath !== ""; width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; text: qsTr("Avaa tiedosto kalenterissa"); onClicked: { if (!calendarExporter.openExportedFile()) { exportSuccessful = false; resultMessage = calendarExporter.lastError } } }
            Label { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap; color: Theme.secondaryColor; font.pixelSize: Theme.fontSizeSmall; text: qsTr("Tiedosto tallennetaan Downloads-hakemistoon.") }
            Item { width: 1; height: Theme.paddingLarge }
        }
    }
}
