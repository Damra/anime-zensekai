import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

import "../../../js/service/backend.js" as Backend
import "../../widgets" as Widgets


Page {
    id: userInfoPage

    property string userName: ""

    background: Rectangle {
        color: backgroundColor
    }

    header: ToolBar {
        background:
            Rectangle {
            implicitHeight: 50
            implicitWidth: 200
            color: "transparent"
        }

        RowLayout {
            anchors.fill: parent
            Item { Layout.fillWidth: true }
            ToolButton {
                id: control
                font.family: "fontawesome"
                text: qsTr("\uf08b")
                font.pointSize: 30
                rightPadding: 10
                contentItem: Text {
                    text: control.text
                    font: control.font
                    opacity: enabled ? 1.0 : 0.3
                    color: mainTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                onClicked: logoutSession()
            }
        }
    }

    Text {
        id: welcometext
        text: "Welcome, \n" + userName
        anchors.centerIn: parent
        font.pointSize: 22
        color: mainTextColor
    }
}
