import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        id: flickable

        anchors.fill: parent
        contentHeight: aboutColumn.height + Theme.paddingLarge

        PullDownMenu {
            MenuItem {
                text: qsTr("Etusivu")
                onClicked: pageStack.clear()
            }

            MenuItem {
                text: qsTr("Haku")
                onClicked: pageStack.push(
                               Qt.resolvedUrl("SearchPage.qml"))
            }

            MenuItem {
                text: qsTr("Suomen liputuspäivät")
                onClicked: pageStack.push(
                               Qt.resolvedUrl("FlagDaysPage.qml"))
            }

            MenuItem {
                text: qsTr("Vuoden pyhäpäivät")
                onClicked: pageStack.push(
                               Qt.resolvedUrl("YearHolidaysPage.qml"))
            }

            MenuItem {
                text: qsTr("Asetukset")
                onClicked: pageStack.push(
                               Qt.resolvedUrl("SettingsPage.qml"))
            }
        }

        VerticalScrollDecorator {
            flickable: flickable
        }

        Column {
            id: aboutColumn

            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Tietoa sovelluksesta")
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                font.pixelSize: Theme.fontSizeLarge

                text: qsTr("Suomalaiset Pyhäpäivät")
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                horizontalAlignment: Text.AlignHCenter
                color: Theme.highlightColor
                font.bold: true

                text: qsTr("Versio 0.5")
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                wrapMode: Text.WordWrap

                text: qsTr(
                    "Suomalaiset Pyhäpäivät on Sailfish OS -sovellus, joka näyttää " +
                    "suomalaiset pyhäpäivät, juhlapäivien aatot, liputuspäivät, " +
                    "vaalipäivät, viikkonumerot ja kalenteritiedot. Sovellus toimii " +
                    "kokonaan offline-tilassa."
                )
            }

            SectionHeader {
                text: qsTr("Ominaisuudet")
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                wrapMode: Text.WordWrap

                text: qsTr(
                    "• Kuukausikalenteri ja ISO-viikkonumerot\n" +
                    "• Suomen pyhäpäivät ja juhlapäivien aatot\n" +
                    "• Viralliset ja vakiintuneet liputuspäivät\n" +
                    "• Vaalipäivät ja niiden liputustiedot\n" +
                    "• Pyhä- ja liputuspäivien haku\n" +
                    "• Ilmoitukset ja muistutukset\n" +
                    "• Kalenteritietojen vienti iCalendar-tiedostoon\n" +
                    "• Monikielinen ja kokonaan offline-tilassa toimiva käyttöliittymä"
                )
            }

            SectionHeader {
                text: qsTr("Versiohistoria")
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                wrapMode: Text.WordWrap

                text: qsTr(
                    "Versiokohtaiset muutokset on siirretty omalle sivulle, " +
                    "jotta tämä tietosivu pysyy selkeänä."
                )
            }

            Button {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr("Avaa muutosloki")

                onClicked: {
                    pageStack.push(
                        Qt.resolvedUrl("ChangeLogPage.qml")
                    )
                }
            }

            SectionHeader {
                text: qsTr("Tekoälyn käyttö")
            }

            Image {
                id: aiScoreImage

                width: Math.min(
                           280,
                           parent.width - Theme.horizontalPageMargin * 2
                       )

                height: status === Image.Ready && implicitWidth > 0
                        ? width * implicitHeight / implicitWidth
                        : 0

                anchors.horizontalCenter: parent.horizontalCenter

                source: Qt.resolvedUrl("../images/AI-score-V.png")
                fillMode: Image.PreserveAspectFit
                smooth: true
                asynchronous: false
                cache: true

                visible: status === Image.Ready
            }

            Rectangle {
                width: parent.width - Theme.horizontalPageMargin * 2
                height: missingImageColumn.height
                        + Theme.paddingMedium * 2

                anchors.horizontalCenter: parent.horizontalCenter

                visible: aiScoreImage.status === Image.Error

                radius: Theme.paddingSmall
                color: Theme.rgba(Theme.highlightColor, 0.08)

                border.width: 1
                border.color: Theme.rgba(
                                  Theme.highlightColor,
                                  0.35
                              )

                Column {
                    id: missingImageColumn

                    width: parent.width - Theme.paddingMedium * 2
                    anchors.centerIn: parent
                    spacing: Theme.paddingSmall

                    Label {
                        width: parent.width

                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.highlightColor
                        font.bold: true
                        font.pixelSize: Theme.fontSizeExtraLarge

                        text: "V"
                    }

                    Label {
                        width: parent.width

                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall

                        text: qsTr(
                            "AI-SCORE-kuvaa ei löytynyt. " +
                            "Luokitustieto näytetään tekstinä."
                        )
                    }
                }
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: Theme.highlightColor
                font.bold: true
                font.pixelSize: Theme.fontSizeLarge

                text: qsTr("AI-SCORE: V")
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                font.bold: true

                text: qsTr("Fully or almost fully vibe-coded")
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: Theme.secondaryColor

                text: qsTr(
                    "Sovellus on toteutettu kokonaan tai lähes kokonaan " +
                    "tekoälyavusteisella vibe coding -menetelmällä."
                )
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall

                text: qsTr(
                    "Kehityksessä käytetty tekoäly:\nMicrosoft Copilot"
                )
            }

            Button {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr("Lisätietoja AI-SCORE-luokituksesta")

                onClicked: {
                    pageStack.push(
                        Qt.resolvedUrl("AiScorePage.qml")
                    )
                }
            }

            SectionHeader {
                text: qsTr("Tietosuojaseloste")
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                wrapMode: Text.WordWrap

                text: qsTr(
                    "Sovellus toimii täysin offline-tilassa eikä kerää, käsittele, " +
                    "tallenna tai lähetä henkilötietoja. Sovellus ei käytä analytiikkaa, " +
                    "evästeitä, mainosverkkoja tai kolmannen osapuolen seurantapalveluita."
                )
            }

            SectionHeader {
                text: qsTr("Verkkosivu")
            }

            Button {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr("Avaa Jolla-sovellusten verkkosivu")

                onClicked: {
                    Qt.openUrlExternally(
                        "https://www.mikko-tenhunen.com/sovellukset/jolla-sovellukset"
                    )
                }
            }

            SectionHeader {
                text: qsTr("Tekijä")
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap

                text: qsTr("Mikko Tenhunen\n© 2026")
            }

            SectionHeader {
                text: qsTr("Valmistettu Suomessa ja Euroopassa")
            }

            /*
             * Suomen ja Euroopan unionin liput piirretään suoraan QML:llä.
             * Erillisiä kuvatiedostoja ei tarvita.
             */
            Row {
                id: flagsRow

                width: parent.width - Theme.horizontalPageMargin * 2
                height: Math.max(finlandFlagSection.height,
                                 europeanFlagSection.height)

                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingLarge

                /*
                 * Suomen lippu
                 */
                Item {
                    id: finlandFlagSection

                    width: (flagsRow.width - flagsRow.spacing) / 2
                    height: finlandFlagColumn.height

                    Column {
                        id: finlandFlagColumn

                        width: parent.width
                        spacing: Theme.paddingMedium

                        Item {
                            id: finlandFlagContainer

                            width: Math.min(200, parent.width)
                            height: width * 18 / 29

                            anchors.horizontalCenter: parent.horizontalCenter

                            Rectangle {
                                id: finlandFlag

                                anchors.fill: parent

                                color: "#FFFFFF"

                                border.width: 1
                                border.color: "#B0B0B0"

                                /*
                                 * Suomen lipun vaakasuora sininen osa.
                                 */
                                Rectangle {
                                    width: parent.width
                                    height: parent.height * 4 / 18

                                    anchors.verticalCenter: parent.verticalCenter

                                    color: "#003580"
                                }

                                /*
                                 * Suomen lipun pystysuora sininen osa.
                                 */
                                Rectangle {
                                    width: parent.width * 4 / 29
                                    height: parent.height

                                    x: parent.width * 9 / 29

                                    color: "#003580"
                                }
                            }
                        }

                        Label {
                            width: parent.width

                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                            font.bold: true

                            text: qsTr("Made in Finland")
                        }
                    }
                }

                /*
                 * Euroopan unionin lippu
                 */
                Item {
                    id: europeanFlagSection

                    width: (flagsRow.width - flagsRow.spacing) / 2
                    height: europeanFlagColumn.height

                    Column {
                        id: europeanFlagColumn

                        width: parent.width
                        spacing: Theme.paddingMedium

                        Item {
                            id: europeanFlagContainer

                            width: Math.min(200, parent.width)
                            height: width * 2 / 3

                            anchors.horizontalCenter: parent.horizontalCenter

                            Rectangle {
                                id: europeanFlag

                                anchors.fill: parent

                                color: "#003399"

                                border.width: 1
                                border.color: "#002766"

                                /*
                                 * Euroopan unionin 12 tähteä.
                                 */
                                Repeater {
                                    model: 12

                                    delegate: Label {
                                        property real starAngle:
                                            (index * 30 - 90)
                                            * Math.PI / 180

                                        property real circleRadius:
                                            europeanFlag.height * 0.30

                                        width: europeanFlag.height * 0.14
                                        height: width

                                        x: europeanFlag.width / 2
                                           + Math.cos(starAngle)
                                           * circleRadius
                                           - width / 2

                                        y: europeanFlag.height / 2
                                           + Math.sin(starAngle)
                                           * circleRadius
                                           - height / 2

                                        horizontalAlignment:
                                            Text.AlignHCenter

                                        verticalAlignment:
                                            Text.AlignVCenter

                                        color: "#FFCC00"
                                        font.bold: true
                                        font.pixelSize:
                                            europeanFlag.height * 0.13

                                        text: "★"
                                    }
                                }
                            }
                        }

                        Label {
                            width: parent.width

                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                            font.bold: true

                            text: qsTr("Made in Europe")
                        }
                    }
                }
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter

                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall

                text: qsTr(
                    "Suunniteltu Suomessa. Toteutettu eurooppalaiselle " +
                    "Sailfish OS -käyttöjärjestelmälle."
                )
            }

            Item {
                width: 1
                height: Theme.paddingLarge
            }
        }
    }
}
