import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import QtQuick.Window 2.11

import "../../../js/service/UIHelper.js" as UIHelper
import "../../../js/fonts/MdiFont.js" as MdiFont
import "../../../js/service/backend.js" as Backend
import "../../widgets" as Widgets

Page {
    id: loginPage

    Component.onCompleted: {
        console.log(" width: rootWindow.width;: "+   rootWindow.width);
        console.log(" height: rootWindow.height;: "+  rootWindow.height);
    }

    signal registerClicked()

    background: Widgets.DynamicBackground { }

    Rectangle {
        visible: false
        id: iconRect
        width: parent.width
        height: 258
        color: backgroundColor

        Text {
            id: icontext
            text: qsTr("\uf169")
            anchors.centerIn: parent
            font.pointSize: 112
            font.family: "fontawesome"
            color: mainAppColor
        }
    }

    ColumnLayout {
        width: parent.width
        anchors.top: iconRect.bottom

        spacing: 16

        TextField {
            id: loginEmail
            placeholderText: qsTr("Email")
            Layout.preferredWidth: parent.width - 64
            Layout.alignment: Qt.AlignHCenter
            color: "#424242"
            font.pointSize: 10
            font.family: "robotoRegular"
            leftPadding: 48
            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 48
                radius: implicitHeight / 6
                color: "#E6FFFFFF"

                Text {
                    text: MdiFont.Icon.email
                    font.pointSize: 16
                    font.family: "Material Design Icons"
                    color: "#9e9e9e"
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: 16
                }

            }
        }

        Widgets.CButton{
            id: control
            Layout.topMargin: 8
            height: 50
            Layout.preferredWidth: parent.width - 64
            Layout.alignment: Qt.AlignHCenter
            name: "SEND MY PASSWORD"
            onClicked: {
                sendMyPassword(loginEmail.text)
            }

            font.pointSize: 10
            font.family: "robotoRegular"
            Widgets.AccountGradientButton {
                control: control
            }

        }

        Widgets.CButton{
            height: 48
            Layout.preferredWidth: parent.width - 64
            Layout.alignment: Qt.AlignHCenter
            name: "SIGN IN"
            font.pointSize: 10
            font.family: "robotoRegular"
            baseColor: "transparent"
            borderColor: "white"
            onClicked: stackView.push("qrc:/qml/ui/beforelogin/LoginPage.qml")
        }

    }
}
