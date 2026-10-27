import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: contentColumn.height + Theme.paddingLarge
        VerticalScrollDecorator { flickable: flickable }

        Column {
            id: contentColumn
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader { title: qsTr("AI-SCORE-luokitus") }

            Image {
                id: aiScoreImage
                width: Math.min(300, parent.width - Theme.horizontalPageMargin * 2)
                height: status === Image.Ready && implicitWidth > 0
                        ? width * implicitHeight / implicitWidth
                        : 0
                anchors.horizontalCenter: parent.horizontalCenter
                source: Qt.resolvedUrl("../images/AI-score-V.png")
                fillMode: Image.PreserveAspectFit
                smooth: true
                visible: status === Image.Ready
            }

            Rectangle {
                width: parent.width - Theme.horizontalPageMargin * 2
                height: selectedColumn.height + Theme.paddingLarge * 2
                anchors.horizontalCenter: parent.horizontalCenter
                radius: Theme.paddingSmall
                color: Theme.rgba("#92008F", 0.18)
                border.width: 2
                border.color: "#A000A0"

                Column {
                    id: selectedColumn
                    width: parent.width - Theme.paddingLarge * 2
                    anchors.centerIn: parent
                    spacing: Theme.paddingSmall

                    Label {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        font.bold: true
                        color: "#D47AD2"
                        font.pixelSize: Theme.fontSizeLarge
                        text: qsTr("V – Fully or almost fully vibe-coded")
                    }

                    Label {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.secondaryColor
                        text: qsTr(
                            "Sovellus on toteutettu kokonaan tai lähes kokonaan " +
                            "tekoälyavusteisella vibe coding -menetelmällä."
                        )
                    }

                    Label {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.highlightColor
                        font.bold: true
                        text: qsTr("Tämän sovelluksen valittu luokitus")
                    }
                }
            }

            SectionHeader { text: qsTr("Kehityksessä käytetty tekoäly") }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: Theme.highlightColor
                font.bold: true
                text: qsTr("Microsoft Copilot")
            }

            SectionHeader { text: qsTr("Luokitukset") }

            Repeater {
                model: [
                    { title: qsTr("H – Human written code"), colorValue: "#008548", description: qsTr("Koodi on kokonaan ihmisen kirjoittamaa. Tekoälyä ei ole käytetty lainkaan.") },
                    { title: qsTr("A – No AI-written code"), colorValue: "#86BF2A", description: qsTr("Tekoäly ei ole kirjoittanut koodia, mutta sitä on käytetty kehitysprosessin muissa osissa.") },
                    { title: qsTr("B – AI-assisted"), colorValue: "#FFBF00", description: qsTr("Tekoälyä on käytetty avustajana. Ihminen on tarkistanut tai kirjoittanut uudelleen kaiken koodin.") },
                    { title: qsTr("C – Some parts AI-coded"), colorValue: "#EC00D9", description: qsTr("Osa sovelluksen koodista on tekoälyn tuottamaa.") },
                    { title: qsTr("V – Fully or almost fully vibe-coded"), colorValue: "#D47AD2", description: qsTr("Sovellus on toteutettu kokonaan tai lähes kokonaan vibe coding -menetelmällä.") },
                    { title: qsTr("X – Not disclosed"), colorValue: Theme.primaryColor, description: qsTr("Sovelluksen paketoija ei ilmoita tekoälyn käytön määrää.") }
                ]

                Column {
                    width: contentColumn.width - Theme.horizontalPageMargin * 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: Theme.paddingSmall

                    Label {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        font.bold: true
                        color: modelData.colorValue
                        text: modelData.title
                    }

                    Label {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        text: modelData.description
                    }

                    Separator {
                        width: parent.width
                        color: Theme.secondaryColor
                        horizontalAlignment: Qt.AlignHCenter
                    }
                }
            }

            Item { width: 1; height: Theme.paddingLarge }
        }
    }
}
