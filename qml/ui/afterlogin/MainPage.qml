import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import "../../../js/fonts/MdiFont.js" as MdiFont
import "../../../js/service/backend.js" as Backend
import "../../widgets" as Widgets

import "anime"

Page {
    id: mainPage
    property string userName: ""

    property bool drawerState:false

    background: Rectangle {
        color:"#212121"
    }

    function toggleDrawerMenu() {
        drawerState = !drawerState;

        if(drawerState) {
            drawerMenu.open()
        } else {
            drawerMenu.close()
        }
    }

    function toolbarMenuMore() {

    }

    function toolbarViewStream() {

    }

    function toolbarSearch() {

    }

    function toolbarOtherButton() {

    }

    header: ToolBar {
        id:toolbar
        anchors.top: parent.top
        height: 56

        background: Rectangle {
            id:rect
            anchors.fill: parent
            LinearGradient {
                anchors.fill: parent
                source: rect
                start: Qt.point(0, parent.height/2)
                end: Qt.point(parent.width, parent.height/2)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#250a46" }
                    GradientStop { position: 1.0; color: "#4a148c" }
                }
            }
        }

        RowLayout {
            z: 15
            anchors.fill: parent
            ToolButton {
                id: backButton
                font.family: "Material Design Icons"
                text: MdiFont.Icon.arrowLeftBold
                font.pointSize: 16
                visible: false
                padding: 12
                contentItem: Text {
                    text: backButton.text
                    font: backButton.font
                    opacity: enabled ? 1.0 : 0.3
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background : Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }

                onClicked: onBackClicked()
            }
            ToolButton {
                id: menu
                font.family: "fontawesome"
                text: qsTr("\uf0c9")
                font.pointSize: 16
                padding: 12
                contentItem: Text {
                    text: menu.text
                    font: menu.font
                    opacity: enabled ? 1.0 : 0.3
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background : Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }

                onClicked: toggleDrawerMenu()
            }
            Item { Layout.fillWidth: true }


            ToolButton {

                contentItem: Text {
                    text: "All"
                    font.pointSize: 12
                    font.family: "robotoRegular"

                    opacity: enabled ? 1.0 : 0.3
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background : Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
            }

            ToolButton {
                id: otherButton

                rightPadding: 10
                contentItem: Text {
                    text: MdiFont.Icon.arrowDown
                    font.pointSize: 12
                    font.family: "Material Design Icons"

                    opacity: enabled ? 1.0 : 0.3
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background : Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
                onClicked: toolbarOtherButton()
            }

            ToolButton {
                id: search

                rightPadding: 10
                contentItem: Text {
                    text: MdiFont.Icon.accountSearch
                    font.pointSize: 16
                    font.family: "Material Design Icons"

                    opacity: enabled ? 1.0 : 0.3
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background : Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
                onClicked: toolbarSearch()
            }
            ToolButton {
                id: viewStream

                rightPadding: 10
                contentItem: Text {
                    text: MdiFont.Icon.viewStream
                    font.pointSize: 16
                    font.family: "Material Design Icons"

                    opacity: enabled ? 1.0 : 0.3
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background : Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
                onClicked: toolbarViewStream()
            }
            ToolButton {
                id: more

                rightPadding: 10
                contentItem: Text {
                    text: MdiFont.Icon.more
                    font.pointSize: 16
                    font.family: "Material Design Icons"

                    opacity: enabled ? 1.0 : 0.3
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background : Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
                onClicked: toolbarMenuMore()
            }
            ToolButton {
                id: logout
                font.family: "fontawesome"
                text: qsTr("\uf08b")
                font.pointSize: 16
                rightPadding: 10
                contentItem: Text {
                    text: logout.text
                    font: logout.font
                    opacity: enabled ? 1.0 : 0.3
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background : Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                }
                onClicked: logoutSession()
            }
        }
    }

    Drawer {
        id : drawerMenu
        x: -width;
        y: 0
        z: 10
        width: parent.width / 4 * 3
        height: parent.height

        NumberAnimation {
            id: openDrawerMenu
            target: drawerMenu
            property: "x"
            from:-width
            to:0
            duration: 500
        }
        NumberAnimation {
            target: drawerMenu
            id: closeDrawerMenu
            property: "x"
            from:0
            to:-width
            duration: 500
        }

        Rectangle {
            id: drawerHeader
            height: 180
            width: parent.width
            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 300)
                end: Qt.point(0, 0)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#250a46" }
                    GradientStop { position: 1.0; color: "#4a148c" }
                }
            }

            Image {
                id: profileImage
                source: '../../../res/images/goku_dragon_ball_super_2-wallpaper-1440x2560.jpg'
                width: 48
                height: 48
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 16
                anchors.topMargin: 40

                fillMode: Image.PreserveAspectCrop
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: mask
                }
            }

            Rectangle {
                id: mask
                width: 48
                height: 48
                radius: 24
                visible: false
            }

            Text {
                anchors.left:parent.left
                anchors.top:profileImage.bottom
                anchors.topMargin: 20
                anchors.leftMargin: 16
                id: textUserFullName
                text: "DAMRA KOÇ"
                color: "#ffffff"
                font.pointSize: 18
                font.family: "robotoRegular"
            }

            Text {
                anchors.left:parent.left
                anchors.top:textUserFullName.bottom
                anchors.topMargin: 2
                anchors.leftMargin: 16
                id: textUserName
                text: "damrakoc"
                color: "#ffffff"
                font.pointSize: 14
                font.family: "robotoRegular"
            }


        }

        Rectangle {

            width: parent.width
            height: parent.height - drawerHeader.height
            anchors.top: drawerHeader.bottom
            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(0, 300)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#6a1b9a" }
                    GradientStop { position: 1.0; color: "#350e4d" }
                }
            }

            Rectangle {
                height: 1
                anchors.top:drawerHeader.bottom
                id: bufferRect
                width: parent.width
                color:"transparent"
            }

            ListView {
                id: listView
                currentIndex: -1
                width: parent.width
                height: parent.height - drawerHeader.height
                anchors.top: bufferRect.bottom
                anchors.topMargin: 24

                delegate: ItemDelegate {
                    id:wrapper
                    width: parent.width
                    height:icon.height * 1.5
                    highlighted: ListView.isCurrentItem


                    RowLayout {
                        anchors.fill:parent
                        Layout.alignment: Qt.AlignLeft
                        Text {
                            id: icon
                            text: model.icon
                            Layout.leftMargin: 16
                            Layout.rightMargin: 16
                            Layout.topMargin: 8
                            Layout.bottomMargin: 8

                            //anchors.verticalCenter: parent.verticalCenter

                            font.pointSize: 24
                            font.family: "fontawesome"
                            color: "white"
                        }

                        Text {
                            id: label
                            width: parent.width;
                            height:parent.height
                           // anchors.verticalCenter: parent.verticalCenter
                            text: model.title
                            Layout.leftMargin: 16
                            Layout.rightMargin: 16
                            Layout.topMargin: 8
                            Layout.bottomMargin: 8
                            Layout.alignment: Qt.AlignLeft
                            font.pointSize: 13
                            font.family: "robotoLight"
                            color: "white"
                        }
                    }

                    onClicked: {
                        if (listView.currentIndex != index) {
                            listView.currentIndex = index
                            label.text = model.title
                            userStackView.replace(model.source)
                        }
                        drawerState = !drawerState
                        drawerMenu.close()
                    }
                }

                model: ListModel {
                    ListElement { icon: qsTr("\uf169"); title: "Anime List"; source: "qrc:/qml/ui/afterlogin/anime/AnimeListPage.qml" }
                    ListElement { icon: qsTr("\uf169"); title: "My Watch List"; source: "qrc:/qml/ui/afterlogin/anime/AnimeListPage.qml" }
                    ListElement { icon: qsTr("\uf169"); title: "Genres List"; source: "qrc:/qml/ui/afterlogin/anime/AnimeListPage.qml" }
                }

                ScrollIndicator.vertical: ScrollIndicator { }
            }
        }
    }

    StackView {
        anchors.top: toolbar.bottom
        id: userStackView
        height: parent.height
        width: parent.width;
        focus: true
        clip: true
        initialItem:AnimeListPage {}
    }

    function onBackClicked(){
        backButton.visible = false
        menu.visible = true
        userStackView.depth > 1 ? userStackView.pop() : userStackView.clear()
    }

    function goToAnimeDetail(uniqueId) {
        backButton.visible = true
        menu.visible = false
        userStackView.push("qrc:/qml/ui/afterlogin/anime/AnimeDetailPage.qml", {uniqueId:uniqueId})
    }

}
