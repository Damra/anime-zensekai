import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0
import QtQuick.Window 2.11

import EnumEndpoint 1.0

import "qml/widgets" as Widgets

import "js/service/UIHelper.js" as UIHelper
import "js/service/backend.js" as Backend

ApplicationWindow {
    id: rootWindow
    visible: true
    width: 360
    height: 640
    title: qsTr("Anime Risuto")

    property var userToken : "";
    property color backgroundColor : "#394454"
    property color mainAppColor: "#394454"
    property color mainTextColor: "#f0f0f0"
    property color popupBackGroundColor: "#E1BEE7"
    property color popupTextCOlor: "#AB47BC"
    property var dataBase
    property bool isBusy: false

    function getUserToken() {
        if (userToken != null && userToken.length > 25){
            return userToken;
        }else {
            dataBase.transaction(function(tx) {
                var rs = tx.executeSql('SELECT * FROM token where token is not null limit 1');

                var r = ""
                for (var i = 0; i < rs.rows.length; i++) {
                    console.log("token record", rs.rows.item(i).token);
                    userToken = rs.rows.item(i).token
                    AnimeRisutoApi.setUserTokenFromQML(userToken);
                    return;
                }
            })
        }

    }

    function registerCallback(x) {
        console.log(x)

        if(x !== null){
            if (x.statusCode === 200) {
                var jsonResult = JSON.parse(x.result.toString())
                saveUserToken(jsonResult["data"]["token"])
                showUserInfo()
            }else {
                popup.popMessage = x.statusMessage
                popup.open()
            }
        }
    }

    function loginCallback(x){
        if(x !== null){
            if (x.statusCode === 200) {
                var jsonResult = JSON.parse(x.result.toString())
                saveUserToken(jsonResult["data"]["token"])
                showUserInfo()
            }else {
                popup.popMessage = x.statusMessage
                popup.open()
            }
        }
    }


    //*/
    FontLoader {
        id: materialIcon
        name: "materialIcon"
        source: "qrc:/res/fonts/material/materialdesignicons-webfont.ttf"
    }

    FontLoader {
        id: fontAwesome
        name: "fontawesome"
        source: "qrc:/res/fonts/fontawesome/fontawesome-webfont.ttf"
    }

    FontLoader {
        id: robotoBold
        name: "robotoBold"
        source: "qrc:/res/fonts/roboto/Roboto-Bold.ttf"
    }

    FontLoader {
        id: robotoMedium
        name: "robotoMedium"
        source: "qrc:/res/fonts/roboto/Roboto-Medium.ttf"
    }

    FontLoader {
        id: robotoLight
        name: "robotoLight"
        source: "qrc:/res/fonts/roboto/Roboto-Light.ttf"
    }

    FontLoader {
        id: robotoThin
        name: "robotoThin"
        source: "qrc:/res/fonts/roboto/Roboto-Thin.ttf"
    }

    FontLoader {
        id: robotoRegular
        name: "robotoRegular"
        source: "qrc:/res/fonts/roboto/Roboto-Regular.ttf"
    }

    Widgets.ProgressCircle {
        id:progressCircle
        size: 50
        z: 15
        colorCircle: "#FF3333"
        colorBackground: "#E6E6E6"
        showBackground: true
        anchors.centerIn: parent
        arcBegin: 0
        arcEnd: 220
        visible: false

    }

    // Main stackview
    StackView {
        id: stackView
        focus: true
        anchors.fill: parent
        clip: true
        height: Screen.height * .9;
        anchors.bottom:adHolder.top

        Keys.onPressed: {
            console.log("KEY_PRESSED: " + event.key)

            if (event.key === Qt.Key_Back) {
                event.accepted = true;
                if (stackView.depth > 1) {
                    stackView.pop();
                } else if(stackView.depth==1) {

                    console.log("Cıkılsın mı ?");
                    messageDialog.visible = true
                } else {
                    Qt.quit();
                }
            }
        }
    }

    Widgets.CustomBusyIndicator  {
        running: isBusy || AnimeRisutoApi.busy
        anchors.centerIn: parent
    }

    Rectangle {
        id:adHolder
        objectName: "adHolder"
        visible: false;
        z:0
        color:"#000"
        width: Screen.width;
        anchors.top: stackView.bottom
        anchors.topMargin: -adHolder.height
    }

    function request(url, callback) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                callback(myxhr);
            }
        })(xhr);
        xhr.open('GET', url, true);
        xhr.send('');
    }
    //Popup to show messages or warnings on the bottom postion of the screen
    Popup {
        id: popup
        property alias popMessage: message.text
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: rootWindow.width - 64
        Layout.bottomMargin: 16

        background: Rectangle {
            implicitWidth: rootWindow.width - 64
            implicitHeight: 48
            radius: height / 6
            color: popupBackGroundColor
        }
        y: (rootWindow.height - 48 + 16)
        modal: true
        focus: true
        closePolicy: Popup.CloseOnPressOutside
        Text {
            id: message
            anchors.centerIn: parent
            font.pointSize: 8
            color: popupTextCOlor
        }
        onOpened: popupClose.start()
        Component.onCompleted: {

        }
    }

    // Popup will be closed automatically in 2 seconds after its opened
    Timer {
        id: popupClose
        interval: 2000
        onTriggered: popup.close()
    }

    // Create and initialize the database
    function userDataBase() {
        var db = LocalStorage.openDatabaseSync("AnimeRisutoApp", "1.0", "UserStorage", 1000000);
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS token(token TEXT)');
        })

        db.transaction(function(tx){
            var rs = tx.executeSql('SELECT * FROM token where token is not null limit 1');

            var r = ""
            for (var i = 0; i < rs.rows.length; i++) {
                console.log("token record", rs.rows.item(i).token);
                userToken = rs.rows.item(i).token
            }
        })

        return db;
    }

    // save user token
    function saveUserToken(token){
        dataBase.transaction(function(tx) {
            tx.executeSql('INSERT INTO token VALUES(?)', [ token ]);
        })
    }

    // delete user token
    function deleteUserToken(){
        dataBase.transaction(function(tx) {
            tx.executeSql('DELETE FROM token');
        })
    }

    // Send to loggedin email addres;
    function sendMyPassword(email) {
        var ret  = Backend.validateUserCredentials(email)
        var message = ""
        var pword = ""
        if(ret)
        {
            message = "Missing credentials!"
            popup.popMessage = message
            popup.open()
            return ""
        }

        stackView.replace("qrc:/qml/ui/beforelogin/LoginPage.qml", {"userName": uname})
    }

    // Retrieve password using password hint
    function retrievePassword(email, phint)
    {
        var ret  = Backend.validateUserCredentials(email, phint)
        var message = ""
        var pword = ""
        if(ret)
        {
            message = "Missing credentials!"
            popup.popMessage = message
            popup.open()
            return ""
        }

        console.log(uname, phint)
        dataBase.transaction(function(tx) {
            var results = tx.executeSql('SELECT password FROM UserDetails WHERE username=? AND hint=?;', [uname, phint]);
            if(results.rows.length === 0)
            {
                message = "User not found!"
                popup.popMessage = message
                popup.open()
            }
            else
            {
                pword = results.rows.item(0).password
            }
        })
        return pword
    }

    // Show UserInfo page
    function showUserInfo()
    {
        stackView.replace("qrc:/qml/ui/afterlogin/MainPage.qml")
    }

    // Logout and show login page
    function logoutSession()
    {
        console.log("Logout and show login page")
        deleteUserToken();
        stackView.replace("qrc:/qml/ui/beforelogin/LoginPage.qml")
    }

    // Show Password reset page
    function forgotPassword()
    {
        stackView.push("qrc:/qml/ui/beforelogin/PasswordResetPage.qml")
    }

    // Show all users
    function showAllUsers()
    {
        dataBase.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM user');
            var data = ""
            for(var i = 0; i < rs.rows.length; i++) {
                data += rs.rows.item(i).username + "\n"
            }
            console.log(data)
        })

    }

    function loadAdsOption(){
        AnimeRisutoApi.get("http://139.59.149.88:88/options", null, function (x){

            if (x.statusCode == 200) {
                var data = JSON.parse(x.result);

                console.log(data);
            }
        })
    }

    // After loading show initial Login Page
    Component.onCompleted: {
        dataBase = userDataBase()

        if(userToken!= null && userToken.length>20){
            showUserInfo()

            loadAdsOption();
        }else{
            stackView.push("qrc:/qml/ui/beforelogin/LoginPage.qml")   //initial page
        }

        console.log(dataBase.version)
    }

}
