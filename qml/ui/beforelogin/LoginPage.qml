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

    signal loginClicked()

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
            text: "kocdamra@gmail.com";
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

        TextField {
            id: loginPassword
            text:"";
            placeholderText: qsTr("Password")
            Layout.preferredWidth: parent.width - 64
            Layout.alignment: Qt.AlignHCenter
            color: "#424242"
            font.pointSize: 10
            font.family: "robotoRegular"
            leftPadding: 48
            echoMode: TextField.PasswordEchoOnEdit
            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 48
                radius: implicitHeight / 6
                color: "#E6FFFFFF"

                Text {
                    text: MdiFont.Icon.lock
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
            id: loginControl
            Layout.topMargin: 8
            height: 50
            Layout.preferredWidth: parent.width - 64
            Layout.alignment: Qt.AlignHCenter
            name: "SIGN IN"

            onClicked:{
                loginControl.enabled = false;

                AnimeRisutoApi.accountLogin(
                            {"email":loginEmail.text, "password":loginPassword.text},
                            function (x){
                                loginControl.enabled = true;
                                console.log(x.statusCode, x.statusMessage, x.path);
                                loginCallback(x)
                            });
            }
            font.pointSize: 10
            font.family: "robotoRegular"
            Widgets.AccountGradientButton {
                control: loginControl
            }

        }

        Widgets.CButton {
            height: 48
            Layout.preferredWidth: parent.width - 64
            Layout.alignment: Qt.AlignHCenter
            name: "SIGN UP"
            font.pointSize: 10
            font.family: "robotoRegular"
            baseColor: "transparent"
            borderColor: "white"
            onClicked: stackView.replace("qrc:/qml/ui/beforelogin/RegisterPage.qml", {"uname": "damra", "pword": "sdamraome"}) //registerClicked()
        }

        Button {
            id: forgotPasswordButton
            background: Rectangle {
                anchors.fill: parent
                color:"transparent"
            }
            contentItem: Text {
                text: "Forgot my password"
                font.pointSize: 10
                font.family: "robotoRegular"
                color: forgotPasswordButton.down ? "#ffffff" : "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: 10
            onClicked: stackView.replace("qrc:/qml/ui/beforelogin/ForgotPasswordPage.qml")
        }
    }
}
