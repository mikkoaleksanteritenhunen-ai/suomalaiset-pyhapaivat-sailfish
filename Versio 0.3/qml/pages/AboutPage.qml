import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: aboutColumn.height + Theme.paddingLarge

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
            id: aboutColumn
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader { title: "Tietoa sovelluksesta" }

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
                text: qsTr("Versio 0.3")
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                text: qsTr("Suomalaiset Pyhäpäivät on Sailfish OS -sovellus, joka näyttää suomalaiset pyhäpäivät, liputuspäivät, viikkonumerot ja kalenteritiedot.")
            }

            SectionHeader { text: "Version 0.3 muutokset" }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                text: qsTr("• Lisätty ISO-viikkonumerot\n") +
                      "• Korjattu kalenterin tasaus ilman viikkonumeroita\n" +
                      "• Lisätty pyhäpäivien ja liputuspäivien värivalinnat\n" +
                      "• Lisätty piirretty Suomen lippu\n" +
                      "• Lisätty asetusten pysyvä tallennus\n" +
                      "• Lisätty ilmoitusasetukset ja testi-ilmoitus\n" +
                      "• Siirretty sovelluksen tiedot omalle sivulle\n• Lisätty aidot Suomen lipun kuvat pyhä- ja liputuspäiväsivuille\n• Eroteltu viralliset ja vakiintuneet liputuspäivät\n• Lisätty vaalipäivien ja presidentin toimeenastumispäivän tiedot\n• Yhtenäistetty kaikkien sivujen vetovalikot"
            }

            SectionHeader { text: "Ominaisuudet" }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                text: qsTr("• Kuukausikalenteri\n") +
                      "• Suomalaisten pyhäpäivien näyttäminen\n" +
                      "• Suomen liputuspäivien näyttäminen\n" +
                      "• Liikkuvien pyhäpäivien laskenta\n" +
                      "• ISO-viikkonumerot\n" +
                      "• Päivän valinta kalenterista\n" +
                      "• Väriasetukset\n" +
                      "• Käyttäjäasetusten tallennus\n" +
                      "• Käynnistyksen yhteydessä julkaistavat ilmoitukset"
            }

            SectionHeader { text: "Tietosuojaseloste" }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                text: qsTr("Tämä sovellus toimii täysin offline-tilassa.\n\n") +
                      "Sovellus ei kerää, käsittele, tallenna tai lähetä henkilötietoja.\n\n" +
                      "Sovellus ei käytä analytiikkaa, evästeitä, mainosverkkoja tai kolmannen osapuolen seurantapalveluita.\n\n" +
                      "Kaikki kalenteri-, pyhäpäivä- ja liputuspäivätiedot käsitellään paikallisesti käyttäjän laitteella."
            }

            SectionHeader { text: "Verkkosivu" }

            Button {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Avaa sovelluksen verkkosivu")
                onClicked: Qt.openUrlExternally("https://www.mikko-tenhunen.com/sovellukset/suomalaiset-pyhapaivat-kalenteri")
            }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAnywhere
                color: Theme.secondaryColor
                text: qsTr("www.mikko-tenhunen.com/sovellukset/suomalaiset-pyhapaivat-kalenteri")
            }

            SectionHeader { text: "Tekijä" }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: qsTr("Mikko Tenhunen\n© 2026")
            }

            SectionHeader { text: "Valmistettu Suomessa ja Euroopassa" }

            Row {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingLarge

                Column {
                    width: (parent.width - parent.spacing) / 2
                    spacing: Theme.paddingSmall

                    Item {
                        width: 90
                        height: 60
                        anchors.horizontalCenter: parent.horizontalCenter
                        Rectangle { anchors.fill: parent; color: "white"; border.width: 1; border.color: "#B0B0B0" }
                        Rectangle { width: parent.width; height: 13; anchors.verticalCenter: parent.verticalCenter; color: "#003580" }
                        Rectangle { width: 13; height: parent.height; x: 28; color: "#003580" }
                    }

                    Label { width: parent.width; horizontalAlignment: Text.AlignHCenter; font.bold: true; text: "Made in Finland" }
                }

                Column {
                    width: (parent.width - parent.spacing) / 2
                    spacing: Theme.paddingSmall

                    Canvas {
                        id: europeFlag
                        width: 90
                        height: 60
                        anchors.horizontalCenter: parent.horizontalCenter
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)
                            ctx.fillStyle = "#003399"
                            ctx.fillRect(0, 0, width, height)
                            ctx.fillStyle = "#FFCC00"
                            var cx = width / 2
                            var cy = height / 2
                            var ring = 20
                            for (var n = 0; n < 12; n++) {
                                var angle = -Math.PI / 2 + n * Math.PI / 6
                                var sx = cx + Math.cos(angle) * ring
                                var sy = cy + Math.sin(angle) * ring
                                ctx.beginPath()
                                for (var p = 0; p < 10; p++) {
                                    var a = -Math.PI / 2 + p * Math.PI / 5
                                    var r = p % 2 === 0 ? 3.2 : 1.35
                                    var x = sx + Math.cos(a) * r
                                    var y = sy + Math.sin(a) * r
                                    if (p === 0) ctx.moveTo(x, y)
                                    else ctx.lineTo(x, y)
                                }
                                ctx.closePath()
                                ctx.fill()
                            }
                        }
                    }

                    Label { width: parent.width; horizontalAlignment: Text.AlignHCenter; font.bold: true; text: "Made in Europe" }
                }
            }
        }
    }
}
