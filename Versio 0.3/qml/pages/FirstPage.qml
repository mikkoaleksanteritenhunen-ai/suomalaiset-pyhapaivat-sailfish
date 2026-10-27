import QtQuick 2.6
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0
import org.nemomobile.notifications 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    property date currentDate: new Date()
    property int selectedDay: (new Date()).getDate()
    property string selectedHoliday: qsTr("Ei pyhäpäivää")
    property string selectedFlagDay: qsTr("Ei liputuspäivää")
    property string holidayListText: ""
    property bool startupNotificationsPublished: false

    property bool todayIsFlagDay: false
    property string todayFlagDayName: ""
    property real flagProgress: 0.0
    property bool flagRaised: false

    ListModel { id: calendarModel }

    ConfigurationValue { id: highlightHolidaysSetting; key: "/apps/suomalaisetpyhapaivat/highlightHolidays"; defaultValue: true }
    ConfigurationValue { id: highlightWeekendsSetting; key: "/apps/suomalaisetpyhapaivat/highlightWeekends"; defaultValue: true }
    ConfigurationValue { id: showFlagDaysSetting; key: "/apps/suomalaisetpyhapaivat/showFlagDays"; defaultValue: true }
    ConfigurationValue { id: showWeekNumbersSetting; key: "/apps/suomalaisetpyhapaivat/showWeekNumbers"; defaultValue: true; onValueChanged: buildCalendar() }
    ConfigurationValue { id: highlightTodaySetting; key: "/apps/suomalaisetpyhapaivat/highlightToday"; defaultValue: true }
    ConfigurationValue { id: showNextHolidaySetting; key: "/apps/suomalaisetpyhapaivat/showNextHoliday"; defaultValue: true }
    ConfigurationValue { id: showNextFlagDaySetting; key: "/apps/suomalaisetpyhapaivat/showNextFlagDay"; defaultValue: true }
    ConfigurationValue { id: dimPastDaysSetting; key: "/apps/suomalaisetpyhapaivat/dimPastDays"; defaultValue: false }
    ConfigurationValue { id: largeCalendarSetting; key: "/apps/suomalaisetpyhapaivat/largeCalendar"; defaultValue: true }
    ConfigurationValue { id: holidayColorSetting; key: "/apps/suomalaisetpyhapaivat/holidayColor"; defaultValue: "#C62828" }
    ConfigurationValue { id: flagDayColorSetting; key: "/apps/suomalaisetpyhapaivat/flagDayColor"; defaultValue: "#005BBB" }
    ConfigurationValue { id: holidayNotificationSetting; key: "/apps/suomalaisetpyhapaivat/holidayNotification"; defaultValue: false }
    ConfigurationValue { id: flagDayNotificationSetting; key: "/apps/suomalaisetpyhapaivat/flagDayNotification"; defaultValue: false }
    ConfigurationValue { id: startupNotificationSetting; key: "/apps/suomalaisetpyhapaivat/startupNotification"; defaultValue: false }

    Notification {
        id: startupNotification
        appName: qsTr("Suomalaiset Pyhäpäivät")
        summary: qsTr("Kalenteri avattu")
        body: qsTr("Kalenteri- ja pyhäpäivätiedot ovat käytettävissä.")
    }
    Notification { id: holidayNotification; appName: qsTr("Suomalaiset Pyhäpäivät"); summary: qsTr("Seuraava pyhäpäivä") }
    Notification { id: flagDayNotification; appName: qsTr("Suomalaiset Pyhäpäivät"); summary: qsTr("Seuraava liputuspäivä") }

    function pad2(value) { return value < 10 ? "0" + value : value.toString() }
    function formatDate(dateValue) { return pad2(dateValue.getDate()) + "." + pad2(dateValue.getMonth() + 1) + "." + dateValue.getFullYear() }
    function selectedDateText() { return pad2(selectedDay) + "." + pad2(currentDate.getMonth() + 1) + "." + currentDate.getFullYear() }
    function sameDate(a, b) { return a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth() && a.getDate() === b.getDate() }

    function isPastDate(year, monthIndex, day) {
        var today = new Date(); today.setHours(0, 0, 0, 0)
        var testDate = new Date(year, monthIndex, day); testDate.setHours(0, 0, 0, 0)
        return testDate.getTime() < today.getTime()
    }

    function isoWeekNumber(dateValue) {
        var date = new Date(Date.UTC(dateValue.getFullYear(), dateValue.getMonth(), dateValue.getDate()))
        var dayNumber = date.getUTCDay()
        if (dayNumber === 0) dayNumber = 7
        date.setUTCDate(date.getUTCDate() + 4 - dayNumber)
        var yearStart = new Date(Date.UTC(date.getUTCFullYear(), 0, 1))
        return Math.ceil((((date.getTime() - yearStart.getTime()) / 86400000) + 1) / 7)
    }

    function easterSunday(year) {
        var a = year % 19; var b = Math.floor(year / 100); var c = year % 100
        var d = Math.floor(b / 4); var e = b % 4; var f = Math.floor((b + 8) / 25)
        var g = Math.floor((b - f + 1) / 3); var h = (19 * a + b - d - g + 15) % 30
        var i = Math.floor(c / 4); var k = c % 4; var l = (32 + 2 * e + 2 * i - h - k) % 7
        var m = Math.floor((a + 11 * h + 22 * l) / 451)
        var month = Math.floor((h + l - 7 * m + 114) / 31)
        var day = ((h + l - 7 * m + 114) % 31) + 1
        return new Date(year, month - 1, day)
    }

    function dateWithOffset(dateValue, days) { return new Date(dateValue.getFullYear(), dateValue.getMonth(), dateValue.getDate() + days) }

    function nthWeekday(year, monthIndex, weekday, occurrence) {
        var d = new Date(year, monthIndex, 1)
        while (d.getDay() !== weekday) d.setDate(d.getDate() + 1)
        d.setDate(d.getDate() + (occurrence - 1) * 7)
        return d
    }

    function lastWeekday(year, monthIndex, weekday) {
        var d = new Date(year, monthIndex + 1, 0)
        while (d.getDay() !== weekday) d.setDate(d.getDate() - 1)
        return d
    }

    function midsummerDay(year) {
        var d = new Date(year, 5, 20)
        while (d.getDay() !== 6) d.setDate(d.getDate() + 1)
        return d
    }

    function allSaintsDay(year) {
        var d = new Date(year, 9, 31)
        while (d.getDay() !== 6) d.setDate(d.getDate() + 1)
        return d
    }

    function holidayName(year, month, day) {
        var testDate = new Date(year, month - 1, day)
        var easter = easterSunday(year)
        if (month === 1 && day === 1) return qsTr("Uudenvuodenpäivä")
        if (month === 1 && day === 6) return qsTr("Loppiainen")
        if (sameDate(testDate, dateWithOffset(easter, -2))) return qsTr("Pitkäperjantai")
        if (sameDate(testDate, easter)) return qsTr("Pääsiäispäivä")
        if (sameDate(testDate, dateWithOffset(easter, 1))) return qsTr("Toinen pääsiäispäivä")
        if (month === 5 && day === 1) return qsTr("Vappu")
        if (sameDate(testDate, dateWithOffset(easter, 39))) return qsTr("Helatorstai")
        if (sameDate(testDate, dateWithOffset(easter, 49))) return qsTr("Helluntaipäivä")
        if (sameDate(testDate, midsummerDay(year))) return qsTr("Juhannuspäivä")
        if (sameDate(testDate, allSaintsDay(year))) return qsTr("Pyhäinpäivä")
        if (month === 12 && day === 6) return qsTr("Itsenäisyyspäivä")
        if (month === 12 && day === 24) return qsTr("Jouluaatto")
        if (month === 12 && day === 25) return qsTr("Joulupäivä")
        if (month === 12 && day === 26) return qsTr("Tapaninpäivä")
        return ""
    }

    function flagDayName(year, month, day) {
        var testDate = new Date(year, month - 1, day)
        var easter = easterSunday(year)
        if (month === 2 && day === 5) return qsTr("J. L. Runebergin päivä")
        if (month === 2 && day === 28) return qsTr("Kalevalan päivä ja suomalaisen kulttuurin päivä")
        if (month === 3 && day === 19) return qsTr("Minna Canthin päivä ja tasa-arvon päivä")
        if (month === 4 && day === 9) return qsTr("Mikael Agricolan päivä ja suomen kielen päivä")
        if (month === 4 && day === 27) return qsTr("Kansallinen veteraanipäivä")
        if (month === 5 && day === 1) return qsTr("Vappu ja suomalaisen työn päivä")
        if (month === 5 && day === 9) return qsTr("Eurooppa-päivä")
        if (month === 5 && day === 12) return qsTr("J. V. Snellmanin päivä ja suomalaisuuden päivä")
        if (sameDate(testDate, nthWeekday(year, 4, 0, 2))) return qsTr("Äitienpäivä")
        if (sameDate(testDate, nthWeekday(year, 4, 0, 3))) return qsTr("Kaatuneitten muistopäivä")
        if (sameDate(testDate, dateWithOffset(easter, 49))) return qsTr("Helluntaipäivä")
        if (month === 6 && day === 4) return qsTr("Puolustusvoimain lippujuhlan päivä")
        if (sameDate(testDate, midsummerDay(year))) return qsTr("Suomen lipun päivä")
        if (month === 7 && day === 6) return qsTr("Eino Leinon päivä ja runon ja suven päivä")
        if (sameDate(testDate, lastWeekday(year, 7, 6))) return qsTr("Suomen luonnon päivä")
        if (month === 10 && day === 1) return qsTr("Miina Sillanpään päivä ja kansalaisvaikuttamisen päivä")
        if (month === 10 && day === 10) return qsTr("Aleksis Kiven päivä ja suomalaisen kirjallisuuden päivä")
        if (month === 10 && day === 24) return qsTr("Yhdistyneiden kansakuntien päivä")
        if (month === 11 && day === 6) return qsTr("Ruotsalaisuuden päivä")
        if (sameDate(testDate, nthWeekday(year, 10, 0, 2))) return qsTr("Isänpäivä")
        if (month === 11 && day === 20) return qsTr("Lapsen oikeuksien päivä")
        if (month === 12 && day === 6) return qsTr("Itsenäisyyspäivä")
        if (month === 12 && day === 8) return qsTr("Jean Sibeliuksen päivä ja suomalaisen musiikin päivä")
        if (year === 2027 && month === 4 && day === 18) return qsTr("Eduskuntavaalien vaalipäivä")
        if (year === 2029 && month === 4 && day === 15) return qsTr("Alue- ja kuntavaalien vaalipäivä")
        if (year === 2029 && month === 6 && day === 10) return qsTr("Euroopan parlamentin vaalien vaalipäivä")
        if (year === 2030 && month === 1 && day === 27) return qsTr("Presidentinvaalin vaalipäivä")
        if (year === 2031 && month === 4 && day === 6) return qsTr("Eduskuntavaalien vaalipäivä")
        return ""
    }

    function findNextEvent(eventFunction) {
        var start = new Date(); start.setHours(0, 0, 0, 0)
        for (var offset = 0; offset < 800; ++offset) {
            var d = new Date(start.getFullYear(), start.getMonth(), start.getDate() + offset)
            var name = eventFunction(d.getFullYear(), d.getMonth() + 1, d.getDate())
            if (name !== "") return { date: d, name: name }
        }
        return null
    }

    function findNextHoliday() { return findNextEvent(holidayName) }
    function findNextFlagDay() { return findNextEvent(flagDayName) }

    function buildCalendar() {
        calendarModel.clear()
        var year = currentDate.getFullYear(); var month = currentDate.getMonth()
        var firstDay = new Date(year, month, 1); var firstWeekDay = firstDay.getDay()
        if (firstWeekDay === 0) firstWeekDay = 7
        var calendarStart = new Date(year, month, 1 - (firstWeekDay - 1))
        for (var week = 0; week < 6; ++week) {
            var monday = new Date(calendarStart.getFullYear(), calendarStart.getMonth(), calendarStart.getDate() + week * 7)
            if (showWeekNumbersSetting.value) calendarModel.append({ itemType: "week", day: 0, selectable: false, weekNumber: isoWeekNumber(monday), weekDay: -1, holiday: "", flagDay: "", pastDay: false })
            for (var wd = 0; wd < 7; ++wd) {
                var cellDate = new Date(monday.getFullYear(), monday.getMonth(), monday.getDate() + wd)
                var inMonth = cellDate.getMonth() === month && cellDate.getFullYear() === year
                calendarModel.append({
                    itemType: "day", day: inMonth ? cellDate.getDate() : 0, selectable: inMonth,
                    weekNumber: 0, weekDay: wd,
                    holiday: inMonth ? holidayName(cellDate.getFullYear(), cellDate.getMonth() + 1, cellDate.getDate()) : "",
                    flagDay: inMonth ? flagDayName(cellDate.getFullYear(), cellDate.getMonth() + 1, cellDate.getDate()) : "",
                    pastDay: inMonth ? isPastDate(cellDate.getFullYear(), cellDate.getMonth(), cellDate.getDate()) : false
                })
            }
        }
    }

    function updateSelectedDayInfo() {
        var holiday = holidayName(currentDate.getFullYear(), currentDate.getMonth() + 1, selectedDay)
        var flagDay = flagDayName(currentDate.getFullYear(), currentDate.getMonth() + 1, selectedDay)
        selectedHoliday = holiday !== "" ? holiday : qsTr("Ei pyhäpäivää")
        selectedFlagDay = flagDay !== "" ? flagDay : qsTr("Ei liputuspäivää")
    }

    function updateHolidayList() {
        var year = currentDate.getFullYear(); var month = currentDate.getMonth()
        var count = new Date(year, month + 1, 0).getDate(); var list = []
        for (var d = 1; d <= count; ++d) {
            var name = holidayName(year, month + 1, d)
            if (name !== "") list.push(pad2(d) + "." + pad2(month + 1) + " " + name)
        }
        holidayListText = list.length === 0 ? qsTr("Tässä kuukaudessa ei ole pyhäpäiviä.") : "• " + list.join("\n• ")
    }

    function updateTodayFlagDay() {
        var now = new Date()
        todayFlagDayName = flagDayName(now.getFullYear(), now.getMonth() + 1, now.getDate())
        todayIsFlagDay = todayFlagDayName !== ""
    }

    function restartFlagAnimation() {
        flagRaiseTimer.stop(); flagProgress = 0.0; flagRaised = false
        if (todayIsFlagDay && page.status === PageStatus.Active) flagRaiseTimer.restart()
    }

    function refreshCalendar() {
        buildCalendar(); updateHolidayList(); updateSelectedDayInfo(); updateTodayFlagDay(); restartFlagAnimation()
        nextEventsCard.nextHoliday = showNextHolidaySetting.value ? findNextHoliday() : null
        nextEventsCard.nextFlagDay = showNextFlagDaySetting.value ? findNextFlagDay() : null
    }

    function previousMonth() { currentDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1); selectedDay = 1; refreshCalendar() }
    function nextMonth() { currentDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1); selectedDay = 1; refreshCalendar() }
    function goToday() { currentDate = new Date(); selectedDay = currentDate.getDate(); refreshCalendar() }

    function publishStartupNotifications() {
        if (startupNotificationsPublished) return
        startupNotificationsPublished = true
        if (startupNotificationSetting.value) startupNotification.publish()
        if (holidayNotificationSetting.value) {
            var h = findNextHoliday(); if (h !== null) { holidayNotification.body = formatDate(h.date) + "\n" + h.name; holidayNotification.publish() }
        }
        if (flagDayNotificationSetting.value) {
            var f = findNextFlagDay(); if (f !== null) { flagDayNotification.body = formatDate(f.date) + "\n" + f.name; flagDayNotification.publish() }
        }
    }

    Timer {
        id: flagRaiseTimer
        interval: 90; repeat: true; running: false
        onTriggered: {
            if (page.flagProgress < 1.0) page.flagProgress = Math.min(1.0, page.flagProgress + 0.06)
            else { stop(); page.flagRaised = true }
        }
    }

    Component.onCompleted: { refreshCalendar(); publishStartupNotifications() }
    onStatusChanged: {
        if (status === PageStatus.Active) refreshCalendar()
        else flagRaiseTimer.stop()
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: contentColumn.height + Theme.paddingLarge

        PullDownMenu {
            MenuItem { text: qsTr("Asetukset"); onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml")) }
            MenuItem { text: qsTr("Haku"); onClicked: pageStack.push(Qt.resolvedUrl("SearchPage.qml")) }
            MenuItem { text: qsTr("Suomen liputuspäivät"); onClicked: pageStack.push(Qt.resolvedUrl("FlagDaysPage.qml")) }
            MenuItem { text: qsTr("Vuoden pyhäpäivät"); onClicked: pageStack.push(Qt.resolvedUrl("YearHolidaysPage.qml")) }
            MenuItem { text: qsTr("Tietoa sovelluksesta"); onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml")) }
            MenuItem { text: qsTr("Tänään"); onClicked: goToday() }
        }

        VerticalScrollDecorator { }

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader { title: qsTr("Kalenteri ja pyhäpäivät") }

            Item {
                id: flagAnimationCard
                visible: page.todayIsFlagDay
                width: parent.width - Theme.horizontalPageMargin * 2
                height: visible ? Math.min(width * 0.58, 340) : 0
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true

                Rectangle { anchors.fill: parent; radius: Theme.paddingMedium; color: "#78B8D8"; border.width: 1; border.color: Theme.rgba(Theme.primaryColor, 0.30) }
                Rectangle { x: parent.width * 0.08; y: parent.height * 0.13; width: parent.width * 0.18; height: Math.max(6, parent.height * 0.035); color: "#E8F4F8" }
                Rectangle { x: parent.width * 0.14; y: parent.height * 0.09; width: parent.width * 0.13; height: Math.max(6, parent.height * 0.035); color: "#E8F4F8" }
                Rectangle { x: parent.width * 0.26; y: parent.height * 0.13; width: parent.width * 0.10; height: Math.max(6, parent.height * 0.035); color: "#E8F4F8" }
                Rectangle { x: 0; y: parent.height * 0.72; width: parent.width; height: parent.height * 0.28; color: "#3F8F3A" }
                Rectangle { x: 0; y: parent.height * 0.90; width: parent.width; height: parent.height * 0.10; color: "#775238" }

                Item {
                    id: flagPole
                    x: Math.round(parent.width * 0.62); y: parent.height * 0.07; width: 10; height: parent.height * 0.80
                    Rectangle { x: 3; y: 5; width: 5; height: parent.height - 5; color: "#EEEEEE" }
                    Rectangle { x: 2; y: 0; width: 7; height: 7; radius: width / 2; color: "#FFD34E" }
                    Rectangle { x: 9; y: 10; width: 1; height: parent.height - 18; color: "#FFF1C7" }

                    Item {
                        id: animatedFlag
                        x: 9
                        width: Math.min(flagAnimationCard.width * 0.27, 112)
                        height: width * 0.60
                        y: (flagPole.height - height - 14) * (1.0 - page.flagProgress) + 10
                        transformOrigin: Item.Left
                        scale: 0.96 + 0.04 * page.flagProgress
                        opacity: 0.75 + 0.25 * page.flagProgress
                        Rectangle { anchors.fill: parent; color: "white"; border.width: 1; border.color: "#CCCCCC" }
                        Rectangle { x: 0; y: parent.height * 0.40; width: parent.width; height: parent.height * 0.20; color: "#003580" }
                        Rectangle { x: parent.width * 0.31; y: 0; width: parent.width * 0.12; height: parent.height; color: "#003580" }
                        SequentialAnimation on rotation {
                            running: page.todayIsFlagDay && page.status === PageStatus.Active && page.flagRaised
                            loops: Animation.Infinite
                            NumberAnimation { from: -1.5; to: 1.5; duration: 650; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 1.5; to: -1.5; duration: 650; easing.type: Easing.InOutSine }
                        }
                    }
                }

                Item {
                    id: flagRaiser
                    x: flagPole.x - width - Theme.paddingMedium; y: parent.height * 0.61
                    width: Math.min(parent.width * 0.15, 58); height: parent.height * 0.28
                    Rectangle { x: parent.width * 0.30; y: 0; width: parent.width * 0.40; height: width; color: "#F2C49B" }
                    Rectangle { x: parent.width * 0.22; y: 0; width: parent.width * 0.50; height: Math.max(5, parent.height * 0.08); color: "#5A3A24" }
                    Rectangle { x: parent.width * 0.20; y: parent.height * 0.27; width: parent.width * 0.56; height: parent.height * 0.38; color: "#D73A31" }
                    Rectangle {
                        x: parent.width * 0.70; y: parent.height * 0.34; width: parent.width * 0.30; height: Math.max(5, parent.height * 0.08); color: "#F2C49B"
                        SequentialAnimation on y {
                            running: page.todayIsFlagDay && page.status === PageStatus.Active && !page.flagRaised
                            loops: Animation.Infinite
                            NumberAnimation { from: flagRaiser.height * 0.31; to: flagRaiser.height * 0.45; duration: 180 }
                            NumberAnimation { from: flagRaiser.height * 0.45; to: flagRaiser.height * 0.31; duration: 180 }
                        }
                    }
                    Rectangle { x: parent.width * 0.25; y: parent.height * 0.65; width: parent.width * 0.18; height: parent.height * 0.35; color: "#263A5A" }
                    Rectangle { x: parent.width * 0.60; y: parent.height * 0.65; width: parent.width * 0.18; height: parent.height * 0.35; color: "#263A5A" }
                }

                Rectangle {
                    width: Math.min(parent.width - Theme.paddingLarge * 2, flagDayText.implicitWidth + Theme.paddingLarge)
                    height: flagDayText.implicitHeight + Theme.paddingMedium
                    anchors.left: parent.left; anchors.bottom: parent.bottom; anchors.margins: Theme.paddingMedium
                    radius: Theme.paddingSmall; color: Theme.rgba("#071E2A", 0.88)
                    Label { id: flagDayText; width: parent.width - Theme.paddingMedium * 2; anchors.centerIn: parent; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap; color: "white"; font.bold: true; font.pixelSize: Theme.fontSizeSmall; text: page.todayFlagDayName }
                }
                MouseArea { anchors.fill: parent; onClicked: page.restartFlagAnimation() }
            }

            Row {
                id: monthNavigation
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingSmall
                Button { width: (monthNavigation.width - monthNavigation.spacing * 2) / 3; text: qsTr("Edellinen"); onClicked: previousMonth() }
                Label { width: (monthNavigation.width - monthNavigation.spacing * 2) / 3; height: parent.height; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter; font.bold: true; font.pixelSize: Theme.fontSizeMedium; elide: Text.ElideRight; text: currentDate.toLocaleDateString(Qt.locale(), "MMMM yyyy") }
                Button { width: (monthNavigation.width - monthNavigation.spacing * 2) / 3; text: qsTr("Seuraava"); onClicked: nextMonth() }
            }

            SectionHeader { text: qsTr("Kalenteri") }

            Row {
                id: weekdayRow
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                Label { visible: showWeekNumbersSetting.value; width: visible ? weekdayRow.width / 8 : 0; text: qsTr("Vk"); horizontalAlignment: Text.AlignHCenter; font.bold: true; color: Theme.secondaryColor }
                Repeater {
                    model: [qsTr("Ma"), qsTr("Ti"), qsTr("Ke"), qsTr("To"), qsTr("Pe"), qsTr("La"), qsTr("Su")]
                    Label { width: showWeekNumbersSetting.value ? weekdayRow.width / 8 : weekdayRow.width / 7; text: modelData; horizontalAlignment: Text.AlignHCenter; font.bold: true; color: index >= 5 ? Theme.highlightColor : Theme.primaryColor }
                }
            }

            GridView {
                id: calendarGrid
                width: parent.width - Theme.horizontalPageMargin * 2
                height: cellHeight * 6
                anchors.horizontalCenter: parent.horizontalCenter
                cellWidth: showWeekNumbersSetting.value ? width / 8 : width / 7
                cellHeight: largeCalendarSetting.value ? 70 : 56
                interactive: false; clip: true; model: calendarModel

                delegate: Rectangle {
                    width: calendarGrid.cellWidth; height: calendarGrid.cellHeight; radius: Theme.paddingSmall
                    property int dayNumber: day
                    property bool isWeekCell: itemType === "week"
                    property bool isHoliday: holiday !== ""
                    property bool isFlagDay: flagDay !== ""
                    property bool isWeekend: weekDay === 5 || weekDay === 6
                    property bool isToday: !isWeekCell && dayNumber > 0 && dayNumber === (new Date()).getDate() && currentDate.getMonth() === (new Date()).getMonth() && currentDate.getFullYear() === (new Date()).getFullYear()
                    property bool isSelected: !isWeekCell && selectable && dayNumber === selectedDay
                    opacity: dimPastDaysSetting.value && pastDay && !isSelected ? 0.42 : 1.0
                    color: {
                        if (isWeekCell) return Theme.rgba(Theme.primaryColor, 0.08)
                        if (isSelected) return "#005BBB"
                        if (isHoliday && highlightHolidaysSetting.value) return holidayColorSetting.value
                        if (isWeekend && highlightWeekendsSetting.value) return Theme.rgba(Theme.highlightColor, 0.16)
                        return "transparent"
                    }
                    border.width: {
                        if (isWeekCell || dayNumber === 0) return 0
                        if (isSelected || (isToday && highlightTodaySetting.value) || (isFlagDay && showFlagDaysSetting.value)) return 3
                        return 1
                    }
                    border.color: {
                        if (isSelected) return "#FFFFFF"
                        if (isToday && highlightTodaySetting.value) return "#FFD700"
                        if (isFlagDay && showFlagDaysSetting.value) return flagDayColorSetting.value
                        return Theme.secondaryColor
                    }
                    Label {
                        anchors.centerIn: parent
                        visible: isWeekCell || dayNumber > 0
                        text: isWeekCell ? weekNumber.toString() : dayNumber.toString()
                        color: {
                            if (isWeekCell) return Theme.secondaryColor
                            if (isSelected) return "#FFFFFF"
                            if (isHoliday && highlightHolidaysSetting.value) return "#FFFFFF"
                            if (isWeekend && highlightWeekendsSetting.value) return Theme.highlightColor
                            return Theme.primaryColor
                        }
                        style: isSelected ? Text.Outline : Text.Normal
                        styleColor: isSelected ? "#66000000" : "transparent"
                        font.pixelSize: isWeekCell ? Theme.fontSizeSmall : Theme.fontSizeLarge
                        font.bold: isWeekCell || isToday || isSelected || isHoliday || isFlagDay
                    }
                    Rectangle { visible: !isWeekCell && isHoliday && highlightHolidaysSetting.value; width: Theme.paddingSmall; height: Theme.paddingSmall; radius: width / 2; anchors.left: parent.left; anchors.top: parent.top; anchors.margins: Theme.paddingSmall; color: isSelected ? "#FFD700" : "#FFFFFF" }
                    Rectangle { visible: !isWeekCell && isFlagDay && showFlagDaysSetting.value; width: Theme.paddingSmall; height: Theme.paddingSmall; radius: width / 2; anchors.right: parent.right; anchors.top: parent.top; anchors.margins: Theme.paddingSmall; color: isSelected ? "#FFFFFF" : flagDayColorSetting.value }
                    MouseArea { anchors.fill: parent; enabled: !isWeekCell && selectable && dayNumber > 0; onClicked: { selectedDay = dayNumber; updateSelectedDayInfo() } }
                }
            }

            Button { text: qsTr("Tänään"); width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; onClicked: goToday() }

            SectionHeader { text: qsTr("Valittu päivä") }
            Label { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; font.bold: true; font.pixelSize: Theme.fontSizeExtraLarge; text: selectedDateText() }
            Label { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; wrapMode: Text.WordWrap; text: qsTr("Pyhäpäivä: %1").arg(selectedHoliday) }
            Label { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; wrapMode: Text.WordWrap; visible: showFlagDaysSetting.value; text: qsTr("Liputuspäivä: %1").arg(selectedFlagDay) }

            SectionHeader { text: qsTr("Kuukauden tiedot") }
            Label { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; wrapMode: Text.WordWrap; text: qsTr("Kuukausi: %1").arg(currentDate.toLocaleDateString(Qt.locale(), "MMMM yyyy")) }
            Label { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; text: qsTr("Päiviä kuukaudessa: %1").arg(new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0).getDate()) }

            SectionHeader { visible: showNextHolidaySetting.value || showNextFlagDaySetting.value; text: qsTr("Seuraavat tapahtumat") }
            Rectangle {
                id: nextEventsCard
                property var nextHoliday: null
                property var nextFlagDay: null
                visible: showNextHolidaySetting.value || showNextFlagDaySetting.value
                width: parent.width - Theme.horizontalPageMargin * 2
                height: visible ? nextEventsColumn.height + Theme.paddingLarge * 2 : 0
                anchors.horizontalCenter: parent.horizontalCenter
                radius: Theme.paddingMedium; color: "#0A4D68"
                Column {
                    id: nextEventsColumn
                    width: parent.width - Theme.paddingLarge * 2; x: Theme.paddingLarge; y: Theme.paddingLarge; spacing: Theme.paddingSmall
                    Label { width: parent.width; visible: showNextHolidaySetting.value; horizontalAlignment: Text.AlignHCenter; color: "white"; font.bold: true; text: qsTr("Seuraava pyhäpäivä") }
                    Label { width: parent.width; visible: showNextHolidaySetting.value; horizontalAlignment: Text.AlignHCenter; color: "white"; font.pixelSize: Theme.fontSizeLarge; text: nextEventsCard.nextHoliday !== null ? formatDate(nextEventsCard.nextHoliday.date) : "" }
                    Label { width: parent.width; visible: showNextHolidaySetting.value; horizontalAlignment: Text.AlignHCenter; color: "white"; wrapMode: Text.WordWrap; text: nextEventsCard.nextHoliday !== null ? nextEventsCard.nextHoliday.name : qsTr("Ei tulevaa pyhäpäivää") }
                    Rectangle { width: parent.width; height: 1; visible: showNextHolidaySetting.value && showNextFlagDaySetting.value; color: "white"; opacity: 0.3 }
                    Item {
                        width: parent.width; height: 32; visible: showNextFlagDaySetting.value
                        Item {
                            id: finnishFlag
                            width: 42; height: 28; anchors.left: parent.left; anchors.leftMargin: Theme.paddingSmall; anchors.verticalCenter: parent.verticalCenter
                            Rectangle { anchors.fill: parent; color: "white"; border.width: 1; border.color: "#B0B0B0" }
                            Rectangle { width: parent.width; height: 6; anchors.verticalCenter: parent.verticalCenter; color: "#003580" }
                            Rectangle { width: 6; height: parent.height; x: 13; color: "#003580" }
                        }
                        Label { anchors.left: finnishFlag.right; anchors.leftMargin: Theme.paddingMedium; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; color: "#A0D8FF"; font.bold: true; wrapMode: Text.WordWrap; text: qsTr("Seuraava liputuspäivä") }
                    }
                    Label { width: parent.width; visible: showNextFlagDaySetting.value; horizontalAlignment: Text.AlignHCenter; color: "white"; font.pixelSize: Theme.fontSizeLarge; text: nextEventsCard.nextFlagDay !== null ? formatDate(nextEventsCard.nextFlagDay.date) : "" }
                    Label { width: parent.width; visible: showNextFlagDaySetting.value; horizontalAlignment: Text.AlignHCenter; color: "white"; wrapMode: Text.WordWrap; text: nextEventsCard.nextFlagDay !== null ? nextEventsCard.nextFlagDay.name : qsTr("Ei tulevaa liputuspäivää") }
                }
            }

            SectionHeader { text: qsTr("Kuukauden pyhäpäivät") }
            Label { width: parent.width - Theme.horizontalPageMargin * 2; anchors.horizontalCenter: parent.horizontalCenter; wrapMode: Text.WordWrap; text: holidayListText }
            Item { width: 1; height: Theme.paddingLarge }
        }
    }
}
