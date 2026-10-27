import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    property string eventName: "Päivän tiedot"
    property string eventDateText: ""
    property string eventLongDateText: ""
    property string eventType: "Pyhäpäivä"
    property string eventDescription: ""
    property bool eventIsFlagDay: false
    property string eventFlagDayType: ""
    property string eventFlagDayDescription: ""

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: detailColumn.height + Theme.paddingLarge

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
            id: detailColumn
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader { title: eventName }

            Rectangle {
                width: parent.width - Theme.horizontalPageMargin * 2
                height: eventHeaderColumn.height + Theme.paddingLarge * 2
                anchors.horizontalCenter: parent.horizontalCenter
                radius: Theme.paddingMedium
                color: eventIsFlagDay || eventType.indexOf("Liputuspäivä") >= 0 ? "#005BBB" : "#0A4D68"

                Column {
                    id: eventHeaderColumn
                    width: parent.width - Theme.paddingLarge * 2
                    x: Theme.paddingLarge
                    y: Theme.paddingLarge
                    spacing: Theme.paddingSmall

                    Item {
                        visible: eventIsFlagDay || eventType.indexOf("Liputuspäivä") >= 0
                        width: parent.width
                        height: visible ? 38 : 0

                        Image {
                            width: 72
                            height: 44
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "../images/finnish_flag.png"
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }
                    }

                    Label {
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        color: "white"
                        font.bold: true
                        font.pixelSize: Theme.fontSizeLarge
                        text: eventLongDateText
                    }

                    Label {
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        color: "white"
                        text: eventDateText
                    }

                    Label {
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        color: "#A0D8FF"
                        font.bold: true
                        text: eventType
                    }
                }
            }

            SectionHeader { text: "Päivän merkitys" }

            Label {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                text: eventDescription
            }

            SectionHeader {
                visible: eventIsFlagDay || eventType.indexOf("Liputuspäivä") >= 0
                text: qsTr("Liputuspäivätieto")
            }

            Label {
                visible: eventIsFlagDay || eventType.indexOf("Liputuspäivä") >= 0
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                color: Theme.highlightColor
                font.bold: true
                text: eventFlagDayType !== "" ? eventFlagDayType : eventType
            }

            Label {
                visible: eventIsFlagDay && eventFlagDayDescription !== ""
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
                text: eventFlagDayDescription
            }

            Button {
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Takaisin"
                onClicked: pageStack.pop()
            }
        }
    }
}
