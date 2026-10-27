import QtQuick 2.6
import Sailfish.Silica 1.0

CoverBackground {
    id: cover

    property var nextHoliday: null
    property var nextFlagDay: null
    property var todayHoliday: null
    property var todayFlagDay: null

    readonly property bool todayHasEvent:
            validEvent(todayHoliday) ||
            validEvent(todayFlagDay)

    readonly property bool todayIsFlagDay:
            validEvent(todayFlagDay)

    property real flagProgress: 0.0
    property bool flagRaised: false

    function validDate(dateValue) {
        return dateValue !== undefined &&
               dateValue !== null &&
               typeof dateValue.getTime === "function" &&
               !isNaN(dateValue.getTime())
    }

    function validEvent(eventValue) {
        return eventValue !== undefined &&
               eventValue !== null &&
               eventValue.name !== undefined &&
               eventValue.name !== null &&
               eventValue.dateValue !== undefined &&
               validDate(eventValue.dateValue)
    }

    function eventName(eventValue, fallbackText) {
        if (!validEvent(eventValue))
            return fallbackText

        return String(eventValue.name)
    }

    function eventDate(eventValue) {
        if (!validEvent(eventValue))
            return null

        return eventValue.dateValue
    }

    function pad2(value) {
        return value < 10
                ? "0" + value
                : value.toString()
    }

    function formatDate(dateValue) {
        if (!validDate(dateValue))
            return ""

        return pad2(dateValue.getDate()) + "." +
               pad2(dateValue.getMonth() + 1) + "." +
               dateValue.getFullYear()
    }

    function sameDate(firstDate, secondDate) {
        if (!validDate(firstDate) ||
                !validDate(secondDate)) {
            return false
        }

        return firstDate.getFullYear() ===
                   secondDate.getFullYear() &&
               firstDate.getMonth() ===
                   secondDate.getMonth() &&
               firstDate.getDate() ===
                   secondDate.getDate()
    }

    function easterSunday(year) {
        var a = year % 19
        var b = Math.floor(year / 100)
        var c = year % 100
        var d = Math.floor(b / 4)
        var e = b % 4
        var f = Math.floor((b + 8) / 25)
        var g = Math.floor((b - f + 1) / 3)
        var h = (19 * a + b - d - g + 15) % 30
        var i = Math.floor(c / 4)
        var k = c % 4

        var l =
                (32 + 2 * e + 2 * i - h - k) % 7

        var m =
                Math.floor(
                    (a + 11 * h + 22 * l) / 451
                )

        var month =
                Math.floor(
                    (h + l - 7 * m + 114) / 31
                )

        var day =
                ((h + l - 7 * m + 114) % 31) + 1

        return new Date(
            year,
            month - 1,
            day
        )
    }

    function offsetDate(dateValue, days) {
        if (!validDate(dateValue))
            return null

        return new Date(
            dateValue.getFullYear(),
            dateValue.getMonth(),
            dateValue.getDate() + days
        )
    }

    function nthWeekday(
            year,
            month,
            weekday,
            occurrence) {
        var dateValue =
                new Date(year, month, 1)

        while (dateValue.getDay() !== weekday) {
            dateValue.setDate(
                dateValue.getDate() + 1
            )
        }

        dateValue.setDate(
            dateValue.getDate() +
            (occurrence - 1) * 7
        )

        return dateValue
    }

    function lastWeekday(
            year,
            month,
            weekday) {
        var dateValue =
                new Date(year, month + 1, 0)

        while (dateValue.getDay() !== weekday) {
            dateValue.setDate(
                dateValue.getDate() - 1
            )
        }

        return dateValue
    }

    function midsummerDay(year) {
        var dateValue =
                new Date(year, 5, 20)

        while (dateValue.getDay() !== 6) {
            dateValue.setDate(
                dateValue.getDate() + 1
            )
        }

        return dateValue
    }

    function allSaintsDay(year) {
        var dateValue =
                new Date(year, 9, 31)

        while (dateValue.getDay() !== 6) {
            dateValue.setDate(
                dateValue.getDate() + 1
            )
        }

        return dateValue
    }

    function holidaysForYear(year) {
        var easter = easterSunday(year)

        return [
            {
                name: qsTr("Uudenvuodenpäivä"),
                dateValue: new Date(year, 0, 1)
            },
            {
                name: qsTr("Loppiainen"),
                dateValue: new Date(year, 0, 6)
            },
            {
                name: qsTr("Pitkäperjantai"),
                dateValue: offsetDate(easter, -2)
            },
            {
                name: qsTr("Pääsiäispäivä"),
                dateValue: easter
            },
            {
                name: qsTr("Toinen pääsiäispäivä"),
                dateValue: offsetDate(easter, 1)
            },
            {
                name: qsTr("Vappu"),
                dateValue: new Date(year, 4, 1)
            },
            {
                name: qsTr("Helatorstai"),
                dateValue: offsetDate(easter, 39)
            },
            {
                name: qsTr("Helluntaipäivä"),
                dateValue: offsetDate(easter, 49)
            },
            {
                name: qsTr("Juhannuspäivä"),
                dateValue: midsummerDay(year)
            },
            {
                name: qsTr("Pyhäinpäivä"),
                dateValue: allSaintsDay(year)
            },
            {
                name: qsTr("Itsenäisyyspäivä"),
                dateValue: new Date(year, 11, 6)
            },
            {
                name: qsTr("Joulupäivä"),
                dateValue: new Date(year, 11, 25)
            },
            {
                name: qsTr("Tapaninpäivä"),
                dateValue: new Date(year, 11, 26)
            }
        ]
    }

    function flagDaysForYear(year) {
        var list = [
            {
                name: qsTr("J. L. Runebergin päivä"),
                dateValue: new Date(year, 1, 5)
            },
            {
                name: qsTr("Kalevalan päivä"),
                dateValue: new Date(year, 1, 28)
            },
            {
                name: qsTr("Minna Canthin päivä"),
                dateValue: new Date(year, 2, 19)
            },
            {
                name: qsTr("Mikael Agricolan päivä"),
                dateValue: new Date(year, 3, 9)
            },
            {
                name: qsTr("Kansallinen veteraanipäivä"),
                dateValue: new Date(year, 3, 27)
            },
            {
                name: qsTr("Vappu"),
                dateValue: new Date(year, 4, 1)
            },
            {
                name: qsTr("Eurooppa-päivä"),
                dateValue: new Date(year, 4, 9)
            },
            {
                name: qsTr("J. V. Snellmanin päivä"),
                dateValue: new Date(year, 4, 12)
            },
            {
                name: qsTr("Äitienpäivä"),
                dateValue: nthWeekday(
                    year,
                    4,
                    0,
                    2
                )
            },
            {
                name: qsTr("Kaatuneitten muistopäivä"),
                dateValue: nthWeekday(
                    year,
                    4,
                    0,
                    3
                )
            },
            {
                name: qsTr(
                    "Puolustusvoimain lippujuhlan päivä"
                ),
                dateValue: new Date(year, 5, 4)
            },
            {
                name: qsTr("Suomen lipun päivä"),
                dateValue: midsummerDay(year)
            },
            {
                name: qsTr("Eino Leinon päivä"),
                dateValue: new Date(year, 6, 6)
            },
            {
                name: qsTr("Suomen luonnon päivä"),
                dateValue: lastWeekday(
                    year,
                    7,
                    6
                )
            },
            {
                name: qsTr("Miina Sillanpään päivä"),
                dateValue: new Date(year, 9, 1)
            },
            {
                name: qsTr("Aleksis Kiven päivä"),
                dateValue: new Date(year, 9, 10)
            },
            {
                name: qsTr(
                    "Yhdistyneiden kansakuntien päivä"
                ),
                dateValue: new Date(year, 9, 24)
            },
            {
                name: qsTr("Ruotsalaisuuden päivä"),
                dateValue: new Date(year, 10, 6)
            },
            {
                name: qsTr("Isänpäivä"),
                dateValue: nthWeekday(
                    year,
                    10,
                    0,
                    2
                )
            },
            {
                name: qsTr("Lapsen oikeuksien päivä"),
                dateValue: new Date(year, 10, 20)
            },
            {
                name: qsTr("Itsenäisyyspäivä"),
                dateValue: new Date(year, 11, 6)
            },
            {
                name: qsTr("Jean Sibeliuksen päivä"),
                dateValue: new Date(year, 11, 8)
            }
        ]

        if (year === 2027) {
            list.push({
                name: qsTr(
                    "Eduskuntavaalien vaalipäivä"
                ),
                dateValue: new Date(
                    2027,
                    3,
                    18
                )
            })
        }

        if (year === 2029) {
            list.push({
                name: qsTr(
                    "Alue- ja kuntavaalien vaalipäivä"
                ),
                dateValue: new Date(
                    2029,
                    3,
                    15
                )
            })

            list.push({
                name: qsTr(
                    "Euroopan parlamentin vaalien vaalipäivä"
                ),
                dateValue: new Date(
                    2029,
                    5,
                    10
                )
            })
        }

        if (year === 2030) {
            list.push({
                name: qsTr(
                    "Presidentinvaalin vaalipäivä"
                ),
                dateValue: new Date(
                    2030,
                    0,
                    27
                )
            })
        }

        if (year === 2031) {
            list.push({
                name: qsTr(
                    "Eduskuntavaalien vaalipäivä"
                ),
                dateValue: new Date(
                    2031,
                    3,
                    6
                )
            })
        }

        list.sort(function(first, second) {
            return first.dateValue.getTime() -
                   second.dateValue.getTime()
        })

        return list
    }

    function findTodayEvent(events, today) {
        if (events === undefined ||
                events === null ||
                !validDate(today)) {
            return null
        }

        for (var index = 0;
                index < events.length;
                index++) {
            var eventValue = events[index]

            if (eventValue !== undefined &&
                    eventValue !== null &&
                    sameDate(
                        eventValue.dateValue,
                        today
                    )) {
                return eventValue
            }
        }

        return null
    }

    function findNextEvent(
            listFunction,
            today) {
        if (typeof listFunction !== "function" ||
                !validDate(today)) {
            return null
        }

        var firstYear = today.getFullYear()
        var todayTime = today.getTime()

        for (var year = firstYear;
                year <= firstYear + 2;
                year++) {
            var events = listFunction(year)

            if (events === undefined ||
                    events === null) {
                continue
            }

            for (var index = 0;
                    index < events.length;
                    index++) {
                var eventValue = events[index]

                if (!validEvent(eventValue))
                    continue

                if (eventValue.dateValue.getTime() >=
                        todayTime) {
                    return eventValue
                }
            }
        }

        return null
    }

    function restartFlagAnimation() {
        raiseTimer.stop()

        flagProgress = 0.0
        flagRaised = false

        if (todayIsFlagDay &&
                status === Cover.Active) {
            raiseTimer.start()
        }
    }

    function updateCover() {
        var now = new Date()

        if (!validDate(now))
            return

        var today = new Date(
            now.getFullYear(),
            now.getMonth(),
            now.getDate()
        )

        var holidays =
                holidaysForYear(
                    today.getFullYear()
                )

        var flagDays =
                flagDaysForYear(
                    today.getFullYear()
                )

        /*
         * Arvot lasketaan ensin paikallisiin muuttujiin.
         * Näin käyttöliittymä ei käsittele tarpeettomia
         * välitiloja päivityksen aikana.
         */
        var newTodayHoliday =
                findTodayEvent(
                    holidays,
                    today
                )

        var newTodayFlagDay =
                findTodayEvent(
                    flagDays,
                    today
                )

        var newNextHoliday =
                findNextEvent(
                    holidaysForYear,
                    today
                )

        var newNextFlagDay =
                findNextEvent(
                    flagDaysForYear,
                    today
                )

        todayHoliday = newTodayHoliday
        todayFlagDay = newTodayFlagDay
        nextHoliday = newNextHoliday
        nextFlagDay = newNextFlagDay

        restartFlagAnimation()
    }

    Component.onCompleted: {
        updateCover()
    }

    onStatusChanged: {
        if (status === Cover.Active) {
            updateCover()
        } else {
            raiseTimer.stop()
        }
    }

    Timer {
        id: raiseTimer

        interval: 90
        repeat: true
        running: false

        onTriggered: {
            if (!cover.todayIsFlagDay) {
                raiseTimer.stop()
                cover.flagProgress = 0.0
                cover.flagRaised = false
                return
            }

            if (cover.flagProgress < 1.0) {
                cover.flagProgress = Math.min(
                    1.0,
                    cover.flagProgress + 0.06
                )
            } else {
                raiseTimer.stop()
                cover.flagRaised = true
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#123C52"
    }

    Item {
        id: flagAnimationBackground

        anchors.fill: parent
        visible: cover.todayIsFlagDay
        opacity: 0.68

        Rectangle {
            anchors.fill: parent
            color: "#78B8D8"
        }

        Rectangle {
            x: 12
            y: 28
            width: 32
            height: 8
            color: "#E8F4F8"
        }

        Rectangle {
            x: 22
            y: 20
            width: 22
            height: 8
            color: "#E8F4F8"
        }

        Rectangle {
            x: 44
            y: 28
            width: 18
            height: 8
            color: "#E8F4F8"
        }

        Rectangle {
            x: 0
            y: parent.height - 70
            width: parent.width
            height: 70
            color: "#3F8F3A"
        }

        Rectangle {
            x: 0
            y: parent.height - 25
            width: parent.width
            height: 25
            color: "#775238"
        }

        Item {
            id: pole

            x: Math.round(parent.width * 0.64)
            y: 24
            width: 8
            height: parent.height - 60

            Rectangle {
                x: 2
                y: 3
                width: 4
                height: parent.height - 3
                color: "#EEEEEE"
            }

            Rectangle {
                x: 1
                y: 0
                width: 6
                height: 6
                color: "#FFD34E"
            }

            Rectangle {
                x: 7
                y: 9
                width: 1
                height: parent.height - 20
                color: "#FFF1C7"
            }

            Item {
                x: 7
                y: (pole.height - 49) *
                   (1.0 - cover.flagProgress) + 8

                width: 58
                height: 35

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    border.width: 1
                    border.color: "#CCCCCC"
                }

                Rectangle {
                    x: 0
                    y: 14
                    width: parent.width
                    height: 7
                    color: "#003580"
                }

                Rectangle {
                    x: 18
                    y: 0
                    width: 7
                    height: parent.height
                    color: "#003580"
                }
            }
        }

        Item {
            x: pole.x - 42
            y: parent.height - 112
            width: 38
            height: 56

            Rectangle {
                x: 12
                y: 0
                width: 16
                height: 16
                color: "#F2C49B"
            }

            Rectangle {
                x: 8
                y: 0
                width: 20
                height: 5
                color: "#5A3A24"
            }

            Rectangle {
                x: 9
                y: 16
                width: 22
                height: 22
                color: "#D73A31"
            }

            Rectangle {
                x: 28
                y: 20
                width: 10
                height: 5
                color: "#F2C49B"

                SequentialAnimation on y {
                    running:
                            cover.status === Cover.Active &&
                            cover.todayIsFlagDay &&
                            !cover.flagRaised

                    loops: Animation.Infinite

                    NumberAnimation {
                        from: 19
                        to: 27
                        duration: 180
                    }

                    NumberAnimation {
                        from: 27
                        to: 19
                        duration: 180
                    }
                }
            }

            Rectangle {
                x: 10
                y: 38
                width: 7
                height: 18
                color: "#263A5A"
            }

            Rectangle {
                x: 24
                y: 38
                width: 7
                height: 18
                color: "#263A5A"
            }
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: Theme.paddingSmall
        spacing: 3

        Rectangle {
            visible: cover.todayHasEvent
            width: parent.width
            height: visible ? todayColumn.height + 10 : 0
            radius: Theme.paddingSmall
            color: Theme.rgba("#071E2A", 0.88)

            Column {
                id: todayColumn

                width: parent.width - 12
                x: 6
                y: 5
                spacing: 1

                Label {
                    width: parent.width
                    color: "#FFD34E"
                    font.bold: true
                    font.pixelSize: Theme.fontSizeExtraSmall
                    text: qsTr("Tänään")
                }

                Label {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    font.bold: true
                    font.pixelSize: Theme.fontSizeSmall

                    text: validEvent(cover.todayHoliday)
                          ? eventName(cover.todayHoliday, "")
                          : eventName(cover.todayFlagDay, "")
                }

                Label {
                    width: parent.width
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeExtraSmall

                    text: validEvent(cover.todayHoliday) &&
                          validEvent(cover.todayFlagDay)
                          ? qsTr("Pyhäpäivä ja liputuspäivä")
                          : validEvent(cover.todayHoliday)
                            ? qsTr("Pyhäpäivä")
                            : validEvent(cover.todayFlagDay)
                              ? qsTr("Liputuspäivä")
                              : ""
                }
            }
        }

        Rectangle {
            width: parent.width
            height: nextHolidayColumn.height + 10
            radius: Theme.paddingSmall
            color: Theme.rgba("#071E2A", 0.82)

            Column {
                id: nextHolidayColumn

                width: parent.width - 12
                x: 6
                y: 5
                spacing: 1

                Label {
                    width: parent.width
                    color: Theme.highlightColor
                    font.bold: true
                    font.pixelSize: Theme.fontSizeExtraSmall
                    text: qsTr("Seuraava pyhäpäivä")
                }

                Label {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    font.bold: true
                    font.pixelSize: Theme.fontSizeSmall

                    text: eventName(
                        cover.nextHoliday,
                        qsTr("Ei tulevaa pyhäpäivää")
                    )
                }

                Label {
                    width: parent.width
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeExtraSmall

                    text: formatDate(
                        eventDate(cover.nextHoliday)
                    )
                }
            }
        }

        Rectangle {
            width: parent.width
            height: nextFlagColumn.height + 10
            radius: Theme.paddingSmall
            color: Theme.rgba("#071E2A", 0.82)

            Column {
                id: nextFlagColumn

                width: parent.width - 12
                x: 6
                y: 5
                spacing: 1

                Row {
                    width: parent.width
                    spacing: 4

                    Item {
                        width: 28
                        height: 17

                        Rectangle {
                            anchors.fill: parent
                            color: "white"
                        }

                        Rectangle {
                            x: 0
                            y: 7
                            width: parent.width
                            height: 4
                            color: "#003580"
                        }

                        Rectangle {
                            x: 9
                            y: 0
                            width: 4
                            height: parent.height
                            color: "#003580"
                        }
                    }

                    Label {
                        width: parent.width - 32
                        color: "#79BFFF"
                        font.bold: true
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: qsTr("Seuraava liputuspäivä")
                    }
                }

                Label {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    font.bold: true
                    font.pixelSize: Theme.fontSizeSmall

                    text: eventName(
                        cover.nextFlagDay,
                        qsTr("Ei tulevaa liputuspäivää")
                    )
                }

                Label {
                    width: parent.width
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeExtraSmall

                    text: formatDate(
                        eventDate(cover.nextFlagDay)
                    )
                }
            }
        }
    }

    CoverActionList {
        enabled: true

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"

            onTriggered: {
                cover.updateCover()
            }
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next"

            onTriggered: {
                if (typeof app !== "undefined" &&
                        app !== null &&
                        typeof app.activate === "function") {
                    app.activate()
                }
            }
        }
    }
}
