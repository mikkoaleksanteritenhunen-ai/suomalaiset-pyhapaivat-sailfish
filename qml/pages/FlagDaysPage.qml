import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All
    property int selectedYear: (new Date()).getFullYear()

    ListModel { id: flagModel }

    function pad2(v) { return v < 10 ? "0" + v : v.toString() }
    function formatDate(d) { return pad2(d.getDate()) + "." + pad2(d.getMonth() + 1) + "." + d.getFullYear() }
    function weekdayName(d) { return [qsTr("sunnuntai"), qsTr("maanantai"), qsTr("tiistai"), qsTr("keskiviikko"), qsTr("torstai"), qsTr("perjantai"), qsTr("lauantai")][d.getDay()] }
    function monthName(d) { return [qsTr("tammikuuta"), qsTr("helmikuuta"), qsTr("maaliskuuta"), qsTr("huhtikuuta"), qsTr("toukokuuta"), qsTr("kesäkuuta"), qsTr("heinäkuuta"), qsTr("elokuuta"), qsTr("syyskuuta"), qsTr("lokakuuta"), qsTr("marraskuuta"), qsTr("joulukuuta")][d.getMonth()] }
    function longDate(d) { return weekdayName(d) + " " + d.getDate() + ". " + monthName(d) + " " + d.getFullYear() }

    function nthWeekday(year, month, weekday, occurrence) {
        var d = new Date(year, month, 1)
        while (d.getDay() !== weekday) d.setDate(d.getDate() + 1)
        d.setDate(d.getDate() + (occurrence - 1) * 7)
        return d
    }

    function midsummerDay(year) {
        var d = new Date(year, 5, 20)
        while (d.getDay() !== 6) d.setDate(d.getDate() + 1)
        return d
    }


    function mothersDay(year) { return nthWeekday(year, 4, 0, 2) }
    function fathersDay(year) { return nthWeekday(year, 10, 0, 2) }

    function flagType(name) {
        if (name === "Kalevalan päivä ja suomalaisen kulttuurin päivä" ||
                name === "Vappu ja suomalaisen työn päivä" ||
                name === "Äitienpäivä" ||
                name === "Puolustusvoimain lippujuhlan päivä" ||
                name === "Suomen lipun päivä" ||
                name === "Isänpäivä" ||
                name === "Itsenäisyyspäivä" ||
                name.indexOf("vaalipäivä") >= 0)
            return "Virallinen liputuspäivä"
        return "Vakiintunut liputuspäivä"
    }

    function description(name) {
        switch (name) {
        case "J. L. Runebergin päivä": return qsTr("Päivä kunnioittaa kansallisrunoilija J. L. Runebergia ja suomalaista kirjallisuutta.")
        case "Kalevalan päivä ja suomalaisen kulttuurin päivä": return qsTr("Päivä juhlistaa Kalevalaa ja suomalaista kulttuuria.")
        case "Minna Canthin päivä ja tasa-arvon päivä": return qsTr("Päivä kunnioittaa kirjailija Minna Canthia ja tasa-arvotyötä.")
        case "Mikael Agricolan päivä ja suomen kielen päivä": return qsTr("Päivä kunnioittaa Mikael Agricolaa ja suomen kirjakielen kehitystä.")
        case "Kansallinen veteraanipäivä": return qsTr("Päivänä kunnioitetaan Suomen sotien veteraaneja ja heidän työtään Suomen hyväksi.")
        case "Vappu ja suomalaisen työn päivä": return qsTr("Vappu on kevään ja opiskelijoiden juhla sekä suomalaisen työn liputuspäivä.")
        case "Eurooppa-päivä": return qsTr("Eurooppa-päivä juhlistaa rauhaa ja eurooppalaista yhteistyötä.")
        case "J. V. Snellmanin päivä ja suomalaisuuden päivä": return qsTr("Päivä kunnioittaa J. V. Snellmania ja suomalaisuutta.")
        case "Kaatuneitten muistopäivä": return "Päivänä muistetaan sodissa ja palvelustehtävissä kaatuneita."
        case "Äitienpäivä": return qsTr("Äitienpäivänä kunnioitetaan äitejä ja äitiyttä. Päivä on virallinen liputuspäivä.")
        case "Isänpäivä": return qsTr("Isänpäivänä kunnioitetaan isiä ja isyyttä. Päivä on virallinen liputuspäivä.")
        case "Eduskuntavaalien vaalipäivä": return qsTr("Vaalipäivä on virallinen liputuspäivä. Seuraavat eduskuntavaalit toimitetaan sunnuntaina 18. huhtikuuta 2027.")
        case "Puolustusvoimain lippujuhlan päivä": return qsTr("Päivä on Suomen puolustusvoimien juhla- ja liputuspäivä.")
        case "Suomen lipun päivä": return qsTr("Juhannuspäivänä vietetään Suomen lipun päivää ja Suomen lippu voi olla salossa läpi valoisan yön.")
        case "Eino Leinon päivä ja runon ja suven päivä": return qsTr("Päivä kunnioittaa Eino Leinoa, runoutta ja Suomen suvea.")
        case "Suomen luonnon päivä": return qsTr("Päivänä juhlistetaan Suomen luontoa ja luonnon merkitystä.")
        case "Miina Sillanpään päivä ja kansalaisvaikuttamisen päivä": return qsTr("Päivä kunnioittaa Miina Sillanpäätä ja kansalaisvaikuttamista.")
        case "Aleksis Kiven päivä ja suomalaisen kirjallisuuden päivä": return qsTr("Päivä kunnioittaa Aleksis Kiveä ja suomalaista kirjallisuutta.")
        case "Ruotsalaisuuden päivä": return qsTr("Päivä juhlistaa Suomen ruotsinkielistä kulttuuria ja kaksikielisyyttä.")
        case "Lapsen oikeuksien päivä": return qsTr("Päivä muistuttaa lasten oikeuksista ja hyvinvoinnista.")
        case "Itsenäisyyspäivä": return qsTr("Päivänä juhlistetaan Suomen itsenäisyyttä.")
        case "Jean Sibeliuksen päivä ja suomalaisen musiikin päivä": return qsTr("Päivä kunnioittaa Jean Sibeliusta ja suomalaista musiikkia.")
        }
        return qsTr("Suomen virallinen tai vakiintunut liputuspäivä.")
    }

    function flagsForYear(year) {
        var list = [
            { name: "J. L. Runebergin päivä", d: new Date(year, 1, 5) },
            { name: "Kalevalan päivä ja suomalaisen kulttuurin päivä", d: new Date(year, 1, 28) },
            { name: "Minna Canthin päivä ja tasa-arvon päivä", d: new Date(year, 2, 19) },
            { name: "Mikael Agricolan päivä ja suomen kielen päivä", d: new Date(year, 3, 9) },
            { name: "Kansallinen veteraanipäivä", d: new Date(year, 3, 27) },
            { name: "Vappu ja suomalaisen työn päivä", d: new Date(year, 4, 1) },
            { name: "Eurooppa-päivä", d: new Date(year, 4, 9) },
            { name: "J. V. Snellmanin päivä ja suomalaisuuden päivä", d: new Date(year, 4, 12) },
            { name: "Äitienpäivä", d: mothersDay(year) },
            { name: "Kaatuneitten muistopäivä", d: nthWeekday(year, 4, 0, 3) },
            { name: "Puolustusvoimain lippujuhlan päivä", d: new Date(year, 5, 4) },
            { name: "Suomen lipun päivä", d: midsummerDay(year) },
            { name: "Eino Leinon päivä ja runon ja suven päivä", d: new Date(year, 6, 6) },
            { name: "Suomen luonnon päivä", d: nthWeekday(year, 7, 6, 4) },
            { name: "Miina Sillanpään päivä ja kansalaisvaikuttamisen päivä", d: new Date(year, 9, 1) },
            { name: "Aleksis Kiven päivä ja suomalaisen kirjallisuuden päivä", d: new Date(year, 9, 10) },
            { name: "Ruotsalaisuuden päivä", d: new Date(year, 10, 6) },
            { name: "Isänpäivä", d: fathersDay(year) },
            { name: "Lapsen oikeuksien päivä", d: new Date(year, 10, 20) },
            { name: "Itsenäisyyspäivä", d: new Date(year, 11, 6) },
            { name: "Jean Sibeliuksen päivä ja suomalaisen musiikin päivä", d: new Date(year, 11, 8) }
        ]
        if (year === 2027)
            list.push({ name: "Eduskuntavaalien vaalipäivä", d: new Date(2027, 3, 18) })
        list.sort(function(a, b) { return a.d.getTime() - b.d.getTime() })
        return list
    }

    function rebuildModel() {
        flagModel.clear()
        var list = flagsForYear(selectedYear)
        for (var i = 0; i < list.length; i++) {
            flagModel.append({
                eventName: list[i].name,
                eventDateText: formatDate(list[i].d),
                eventLongDateText: longDate(list[i].d),
                eventDescriptionText: description(list[i].name),
                eventTypeText: flagType(list[i].name)
            })
        }
    }

    function openDetail(name, dateText, longText, explanation) {
        pageStack.push(Qt.resolvedUrl("DayDetailPage.qml"), {
            eventName: name,
            eventDateText: dateText,
            eventLongDateText: longText,
            eventType: flagType(name),
            eventDescription: explanation
        })
    }

    Component.onCompleted: rebuildModel()

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

            PageHeader { title: "Suomen liputuspäivät" }

            Image {
                width: 126
                height: 77
                anchors.horizontalCenter: parent.horizontalCenter
                source: "../images/finnish_flag.png"
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: Theme.secondaryColor
                text: qsTr("Viralliset liputuspäivät perustuvat asetukseen. Vakiintuneina liputuspäivinä liputtamista suositellaan.")
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

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                text: qsTr("Valitse liputuspäivä nähdäksesi päivän merkityksen.")
            }

            Repeater {
                model: flagModel
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
                        Label { width: parent.width; text: qsTr(eventName); font.bold: true; font.pixelSize: Theme.fontSizeMedium; wrapMode: Text.WordWrap }
                        Label { width: parent.width; text: eventLongDateText; color: Theme.secondaryColor; wrapMode: Text.WordWrap }
                        Label { width: parent.width; text: eventDateText + "  •  " + eventTypeText; color: Theme.highlightColor }
                        Rectangle { width: parent.width; height: 1; color: Theme.secondaryColor; opacity: 0.3 }
                    }
                    onClicked: openDetail(eventName, eventDateText, eventLongDateText, eventDescriptionText)
                }
            }


            SectionHeader { text: "Vaalipäivät ja presidentin toimeenastuminen" }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                text: qsTr("Vaalipäivä on virallinen liputuspäivä, kun toimitetaan kuntavaalit, eduskuntavaalit, presidentinvaali, Euroopan parlamentin vaalit, aluevaalit tai kansanäänestys. Seuraavat eduskuntavaalit toimitetaan sunnuntaina 18.4.2027.")
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                color: Theme.secondaryColor
                text: qsTr("Viimeksi toimitetut: alue- ja kuntavaalit 13.4.2025, eduskuntavaalit 2.4.2023, presidentinvaalin toinen kierros 11.2.2024, Euroopan parlamentin vaalit 9.6.2024 ja EU-kansanäänestys 16.10.1994. Tasavallan presidentin toimeenastumispäivä on virallinen liputuspäivä; viimeksi 1.3.2024.")
            }

            SectionHeader { text: "Liputuspäivien luokittelu" }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                color: Theme.secondaryColor
                text: qsTr("Virallisina liputuspäivinä valtion virastot ja laitokset liputtavat. Vakiintuneet liputuspäivät eivät perustu asetukseen, mutta liputtamista suositellaan. Erillisiä suositeltuja liputuspäiviä voidaan vahvistaa vuosittain.")
            }
        }
    }
}
