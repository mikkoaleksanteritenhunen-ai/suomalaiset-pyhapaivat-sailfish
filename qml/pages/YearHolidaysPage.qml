import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    property int selectedYear: (new Date()).getFullYear()
    property var nextHoliday: null

    ListModel { id: holidayModel }

    function pad2(v) { return v < 10 ? "0" + v : v.toString() }
    function formatDate(d) { return pad2(d.getDate()) + "." + pad2(d.getMonth() + 1) + "." + d.getFullYear() }

    function weekdayName(d) {
        return ["sunnuntai", "maanantai", "tiistai", "keskiviikko", "torstai", "perjantai", "lauantai"][d.getDay()]
    }

    function monthName(d) {
        return ["tammikuuta", "helmikuuta", "maaliskuuta", "huhtikuuta", "toukokuuta", "kesäkuuta",
                "heinäkuuta", "elokuuta", "syyskuuta", "lokakuuta", "marraskuuta", "joulukuuta"][d.getMonth()]
    }

    function longDate(d) { return weekdayName(d) + " " + d.getDate() + ". " + monthName(d) + " " + d.getFullYear() }

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
        var l = (32 + 2 * e + 2 * i - h - k) % 7
        var m = Math.floor((a + 11 * h + 22 * l) / 451)
        var month = Math.floor((h + l - 7 * m + 114) / 31)
        var day = ((h + l - 7 * m + 114) % 31) + 1
        return new Date(year, month - 1, day)
    }

    function offsetDate(d, days) { return new Date(d.getFullYear(), d.getMonth(), d.getDate() + days) }

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

    function description(name) {
        if (isElectionDay(name))
            return electionDescription(name)

        switch (name) {
        case "Uudenvuodenpäivä": return "Uudenvuodenpäivä aloittaa kalenterivuoden. Päivään liittyy uuden vuoden vastaanottaminen sekä tulevan vuoden toivotukset."
        case "Loppiainen": return "Loppiainen päättää joulun kirkollisen juhlakauden. Päivä liittyy itämaan tietäjien vierailuun Jeesuksen luona."
        case "Pitkäperjantai": return "Pitkäperjantaina muistetaan Jeesuksen ristiinnaulitsemista ja kuolemaa."
        case "Pääsiäispäivä": return "Pääsiäispäivä on kristillisen pääsiäisen pääjuhla ja Jeesuksen ylösnousemuksen päivä."
        case "Toinen pääsiäispäivä": return "Toinen pääsiäispäivä jatkaa pääsiäisen juhlaa pääsiäissunnuntaita seuraavana maanantaina."
        case "Vappu": return "Vappu on kevään, opiskelijoiden ja suomalaisen työn juhla."
        case "Helatorstai": return "Helatorstaita vietetään 39 päivää pääsiäispäivän jälkeen. Päivä liittyy Kristuksen taivaaseenastumiseen."
        case "Helluntaipäivä": return "Helluntaipäivää vietetään 49 päivää pääsiäispäivän jälkeen. Päivä liittyy Pyhän Hengen vuodattamiseen."
        case "Juhannusaatto": return "Juhannusaatto aloittaa keskikesän juhlan. Se on Suomessa vakiintunut vapaapäivä, mutta ei varsinainen pyhäpäivä."
        case "Juhannuspäivä": return "Juhannuspäivä on keskikesän juhla ja samalla Suomen lipun päivä."
        case "Pyhäinpäivä": return "Pyhäinpäivänä muistetaan pyhiä ja edesmenneitä läheisiä. Haudoille viedään usein kynttilöitä."
        case "Itsenäisyyspäivä": return "Itsenäisyyspäivänä juhlistetaan Suomen itsenäisyyttä 6. joulukuuta."
        case "Jouluaatto": return "Jouluaatto aloittaa suomalaisen joulun pääjuhlan. Se on vakiintunut vapaapäivä, mutta ei varsinainen pyhäpäivä."
        case "Joulupäivä": return "Joulupäivänä vietetään kristillisessä perinteessä Jeesuksen syntymän juhlaa."
        case "Tapaninpäivä": return "Tapaninpäivä eli toinen joulupäivä jatkaa joulun juhlaa 26. joulukuuta."
        }
        return "Suomalainen juhla- tai pyhäpäivä."
    }

    function isHolidayFlagDay(name) {
        return name === "Vappu" ||
               name === "Juhannuspäivä" ||
               name === "Itsenäisyyspäivä" ||
               isElectionDay(name)
    }

    function holidayFlagDayType(name) {
        if (isHolidayFlagDay(name))
            return "Virallinen liputuspäivä"
        return ""
    }

    function holidayFlagDayDescription(name) {
        if (isElectionDay(name))
            return electionDescription(name)

        switch (name) {
        case "Vappu":
            return "Vappu on suomalaisen työn päivä ja virallinen liputuspäivä."
        case "Juhannuspäivä":
            return "Juhannuspäivä on Suomen lipun päivä ja virallinen liputuspäivä."
        case "Itsenäisyyspäivä":
            return "Itsenäisyyspäivä on Suomen itsenäisyyden juhlapäivä ja virallinen liputuspäivä."
        }
        return ""
    }

    function electionDaysForYear(year) {
        var elections = []

        if (year === 2027) {
            elections.push({
                name: "Eduskuntavaalien vaalipäivä",
                dateValue: new Date(2027, 3, 18),
                type: "Virallinen liputuspäivä"
            })
        }

        if (year === 2029) {
            elections.push({
                name: "Alue- ja kuntavaalien vaalipäivä",
                dateValue: new Date(2029, 3, 15),
                type: "Virallinen liputuspäivä"
            })

            elections.push({
                name: "Euroopan parlamentin vaalien vaalipäivä",
                dateValue: new Date(2029, 5, 10),
                type: "Virallinen liputuspäivä"
            })
        }

        if (year === 2030) {
            elections.push({
                name: "Presidentinvaalin vaalipäivä",
                dateValue: new Date(2030, 0, 27),
                type: "Virallinen liputuspäivä"
            })
        }

        if (year === 2031) {
            elections.push({
                name: "Eduskuntavaalien vaalipäivä",
                dateValue: new Date(2031, 3, 6),
                type: "Virallinen liputuspäivä"
            })
        }

        return elections
    }

    function isElectionDay(name) {
        return name.indexOf("vaalipäivä") >= 0
    }

    function electionDescription(name) {
        if (name === "Eduskuntavaalien vaalipäivä")
            return "Eduskuntavaaleissa valitaan Suomen eduskunnan kansanedustajat. Vaalipäivä on virallinen liputuspäivä."

        if (name === "Alue- ja kuntavaalien vaalipäivä")
            return "Alue- ja kuntavaaleissa valitaan aluevaltuustojen ja kuntien valtuustojen jäsenet. Vaalipäivä on virallinen liputuspäivä."

        if (name === "Euroopan parlamentin vaalien vaalipäivä")
            return "Euroopan parlamentin vaaleissa valitaan Suomen edustajat Euroopan parlamenttiin. Vaalipäivä on virallinen liputuspäivä."

        if (name === "Presidentinvaalin vaalipäivä")
            return "Presidentinvaalissa valitaan Suomen tasavallan presidentti. Vaalipäivä on virallinen liputuspäivä."

        return "Vaalipäivä on Suomessa virallinen liputuspäivä."
    }

    function holidaysForYear(year) {
        var easter = easterSunday(year)
        var midsummer = midsummerDay(year)
        var list = [
            { name: "Uudenvuodenpäivä", dateValue: new Date(year, 0, 1), type: "Pyhäpäivä" },
            { name: "Loppiainen", dateValue: new Date(year, 0, 6), type: "Pyhäpäivä" },
            { name: "Pitkäperjantai", dateValue: offsetDate(easter, -2), type: "Pyhäpäivä" },
            { name: "Pääsiäispäivä", dateValue: easter, type: "Pyhäpäivä" },
            { name: "Toinen pääsiäispäivä", dateValue: offsetDate(easter, 1), type: "Pyhäpäivä" },
            { name: "Vappu", dateValue: new Date(year, 4, 1), type: "Pyhäpäivä" },
            { name: "Helatorstai", dateValue: offsetDate(easter, 39), type: "Pyhäpäivä" },
            { name: "Helluntaipäivä", dateValue: offsetDate(easter, 49), type: "Pyhäpäivä" },
            { name: "Juhannusaatto", dateValue: offsetDate(midsummer, -1), type: "Aattopäivä" },
            { name: "Juhannuspäivä", dateValue: midsummer, type: "Pyhäpäivä" },
            { name: "Pyhäinpäivä", dateValue: allSaintsDay(year), type: "Pyhäpäivä" },
            { name: "Itsenäisyyspäivä", dateValue: new Date(year, 11, 6), type: "Pyhäpäivä" },
            { name: "Jouluaatto", dateValue: new Date(year, 11, 24), type: "Aattopäivä" },
            { name: "Joulupäivä", dateValue: new Date(year, 11, 25), type: "Pyhäpäivä" },
            { name: "Tapaninpäivä", dateValue: new Date(year, 11, 26), type: "Pyhäpäivä" }
        ]

        var elections = electionDaysForYear(year)
        for (var index = 0; index < elections.length; index++)
            list.push(elections[index])

        list.sort(function(first, second) {
            return first.dateValue.getTime() - second.dateValue.getTime()
        })

        return list
    }

    function rebuildModel() {
        holidayModel.clear()
        var list = holidaysForYear(selectedYear)
        for (var i = 0; i < list.length; i++) {
            holidayModel.append({
                eventName: list[i].name,
                eventDateText: formatDate(list[i].dateValue),
                eventLongDateText: longDate(list[i].dateValue),
                eventTypeText: list[i].type,
                eventDescriptionText: description(list[i].name),
                eventIsFlagDay: isHolidayFlagDay(list[i].name),
                eventFlagDayTypeText: holidayFlagDayType(list[i].name),
                eventFlagDayDescriptionText: holidayFlagDayDescription(list[i].name)
            })
        }
    }

    function findNextHoliday() {
        var now = new Date()
        var today = new Date(now.getFullYear(), now.getMonth(), now.getDate())
        for (var year = today.getFullYear(); year <= today.getFullYear() + 2; year++) {
            var list = holidaysForYear(year)
            for (var i = 0; i < list.length; i++) {
                if (list[i].type === "Pyhäpäivä" && list[i].dateValue.getTime() >= today.getTime())
                    return list[i]
            }
        }
        return null
    }

    function openDetail(name, dateText, longText, typeText, explanation, isFlagDay, flagDayType, flagDayDescription) {
        pageStack.push(Qt.resolvedUrl("DayDetailPage.qml"), {
            eventName: name,
            eventDateText: dateText,
            eventLongDateText: longText,
            eventType: typeText,
            eventDescription: explanation,
            eventIsFlagDay: isFlagDay,
            eventFlagDayType: flagDayType,
            eventFlagDayDescription: flagDayDescription
        })
    }

    Component.onCompleted: {
        rebuildModel()
        nextHoliday = findNextHoliday()
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: contentColumn.height + Theme.paddingLarge

        PullDownMenu {
            MenuItem { text: "Etusivu"; onClicked: pageStack.clear() }
            MenuItem { text: "Haku"; onClicked: pageStack.push(Qt.resolvedUrl("SearchPage.qml")) }
            MenuItem { text: "Suomen liputuspäivät"; onClicked: pageStack.push(Qt.resolvedUrl("FlagDaysPage.qml")) }
            MenuItem { text: "Vuoden pyhäpäivät"; onClicked: pageStack.push(Qt.resolvedUrl("YearHolidaysPage.qml")) }
            MenuItem { text: "Asetukset"; onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml")) }
            MenuItem { text: "Tietoa sovelluksesta"; onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml")) }
        }

        VerticalScrollDecorator { }

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader { title: "Vuoden pyhäpäivät" }

            Image {
                width: 108
                height: 66
                anchors.horizontalCenter: parent.horizontalCenter
                source: "../images/finnish_flag.png"
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Row {
                id: yearRow
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingSmall

                Button { width: (yearRow.width - yearRow.spacing * 2) / 3; text: "Edellinen"; onClicked: { selectedYear--; rebuildModel() } }
                Label { width: (yearRow.width - yearRow.spacing * 2) / 3; height: parent.height; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; font.bold: true; text: selectedYear.toString() }
                Button { width: (yearRow.width - yearRow.spacing * 2) / 3; text: "Seuraava"; onClicked: { selectedYear++; rebuildModel() } }
            }

            SectionHeader { text: "Seuraava pyhäpäivä" }

            BackgroundItem {
                width: parent.width
                height: nextColumn.height + Theme.paddingLarge * 2
                enabled: nextHoliday !== null
                onClicked: openDetail(nextHoliday.name, formatDate(nextHoliday.dateValue), longDate(nextHoliday.dateValue), nextHoliday.type, description(nextHoliday.name), isHolidayFlagDay(nextHoliday.name), holidayFlagDayType(nextHoliday.name), holidayFlagDayDescription(nextHoliday.name))

                Rectangle {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.horizontalPageMargin
                    anchors.rightMargin: Theme.horizontalPageMargin
                    radius: Theme.paddingMedium
                    color: "#0A4D68"
                }

                Column {
                    id: nextColumn
                    width: parent.width - Theme.horizontalPageMargin * 2 - Theme.paddingLarge * 2
                    x: Theme.horizontalPageMargin + Theme.paddingLarge
                    y: Theme.paddingLarge
                    spacing: Theme.paddingSmall

                    Image {
                        visible: nextHoliday !== null && isHolidayFlagDay(nextHoliday.name)
                        width: 72
                        height: visible ? 44 : 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: "../images/finnish_flag.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    Label { width: parent.width; horizontalAlignment: Text.AlignHCenter; color: "white"; font.bold: true; font.pixelSize: Theme.fontSizeLarge; text: nextHoliday ? nextHoliday.name : "Ei tulevaa pyhäpäivää" }
                    Label { width: parent.width; horizontalAlignment: Text.AlignHCenter; color: "white"; text: nextHoliday ? longDate(nextHoliday.dateValue) : "" }
                    Label { width: parent.width; horizontalAlignment: Text.AlignHCenter; color: "#A0D8FF"; text: nextHoliday ? formatDate(nextHoliday.dateValue) : "" }
                }
            }

            SectionHeader { text: "Pyhä-, aatto- ja vaalipäivät " + selectedYear }

            Repeater {
                model: holidayModel
                delegate: BackgroundItem {
                    width: parent.width
                    height: resultColumn.height + Theme.paddingMedium * 2

                    Column {
                        id: resultColumn
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: Theme.horizontalPageMargin
                        anchors.rightMargin: Theme.horizontalPageMargin
                        spacing: Theme.paddingSmall
                        Row {
                            width: parent.width
                            spacing: Theme.paddingMedium

                            Image {
                                visible: eventIsFlagDay
                                width: visible ? 48 : 0
                                height: visible ? 29 : 0
                                source: "../images/finnish_flag.png"
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                            }

                            Label {
                                width: parent.width - (eventIsFlagDay ? 48 + parent.spacing : 0)
                                text: eventName
                                font.bold: true
                                font.pixelSize: Theme.fontSizeMedium
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        Label { width: parent.width; text: eventLongDateText; color: Theme.secondaryColor; wrapMode: Text.WordWrap }
                        Label { width: parent.width; text: eventDateText + "  •  " + eventTypeText; color: eventTypeText === "Virallinen liputuspäivä"
                                   ? "#4EA5FF"
                                   : eventTypeText === "Pyhäpäivä"
                                     ? Theme.highlightColor
                                     : Theme.secondaryColor }
                        Label {
                            visible: eventIsFlagDay
                            width: parent.width
                            text: eventFlagDayTypeText
                            color: "#4EA5FF"
                            font.bold: true
                        }
                        Rectangle { width: parent.width; height: 1; color: Theme.secondaryColor; opacity: 0.3 }
                    }

                    onClicked: openDetail(eventName, eventDateText, eventLongDateText, eventTypeText, eventDescriptionText, eventIsFlagDay, eventFlagDayTypeText, eventFlagDayDescriptionText)
                }
            }
        }
    }
}
