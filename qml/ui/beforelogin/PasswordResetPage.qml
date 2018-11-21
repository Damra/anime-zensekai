import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

import "../../../js/service/backend.js" as Backend
import "../../widgets" as Widgets

Page {
    id: passswordPage

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

    Text {
        id: resetText
        text: qsTr("Retrieve Password")
        font.pointSize: 24
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        color: mainTextColor
    }

    ColumnLayout {
        width: parent.width
        anchors.top: resetText.bottom
        anchors.topMargin: 30
        spacing: 20

        TextField {
            id: registeredUsername
            placeholderText: qsTr("User name")
            Layout.preferredWidth: parent.width - 20
            Layout.alignment: Qt.AlignHCenter
            color: mainTextColor
            font.pointSize: 14
            font.family: "fontawesome"
            leftPadding: 30
            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 50
                radius: implicitHeight / 2
                color: "transparent"

                Text {
                    text: "\uf007"
                    font.pointSize: 14
                    font.family: "fontawesome"
                    color: mainAppColor
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: 10
                }

                Rectangle {
                    width: parent.width - 10
                    height: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    color: mainAppColor
                }
            }
        }

        TextField {
            id: registeredHint
            placeholderText: qsTr("Password Hint")
            Layout.preferredWidth: parent.width - 20
            Layout.alignment: Qt.AlignHCenter
            color: mainTextColor
            font.pointSize: 14
            font.family: "fontawesome"
            leftPadding: 30
            echoMode: TextField.PasswordEchoOnEdit
            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 50
                radius: implicitHeight / 2
                color: "transparent"
                Text {
                    text: "\uf023"
                    font.pointSize: 14
                    font.family: "fontawesome"
                    color: mainAppColor
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: 10
                }

                Rectangle {
                    width: parent.width - 10
                    height: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    color: mainAppColor
                }
            }
        }

        Item {
            height: 20
        }

        Widgets.CButton{
            height: 50
            Layout.preferredWidth: parent.width - 20
            Layout.alignment: Qt.AlignHCenter
            name: "Retrieve"
            baseColor: mainAppColor
            borderColor: mainAppColor
            onClicked: initiateRetrieval()
        }

        Item {
            height: 40
        }

        Text {
            id: helpText
            text: qsTr("Your Password is,")
            font.pointSize: 16
            Layout.preferredWidth: parent.width - 20
            Layout.alignment: Qt.AlignLeft
            leftPadding: 15
            color: mainTextColor
            visible: false
        }

        Text {
            id: password
            font.pointSize: 13
            Layout.preferredWidth: parent.width - 20
            Layout.alignment: Qt.AlignLeft
            leftPadding: 15
            color: mainTextColor
            visible: false
        }

        Item {
            height: 20
        }

        Widgets.CButton {
            visible: false
            height: 48
            Layout.preferredWidth: parent.width - 64
            Layout.alignment: Qt.AlignHCenter
            name: "CANCEL"
            font.pointSize: 10
            font.family: "robotoRegular"
            baseColor: "transparent"
            borderColor: "white"
            onClicked: stackView.pop()
        }

    }

    function initiateRetrieval()
    {
        var ret = retrievePassword(registeredUsername.text, registeredHint.text)
        if(ret !== "")
        {
            helpText.visible = true
            password.visible = true
            password.text = ret
        }
    }
}
