import QtQuick 2.0
import "../../js/service/UIHelper.js" as UIHelper

Rectangle {
    color: "black"
    width: rootWindow.width;
    height: rootWindow.height;

    property string alpha: ""

    Image {
       id: image
       width: rootWindow.width;
       height: rootWindow.height;
       source: UIHelper.getRandomBackgroundImagePath()
       fillMode: Image.PreserveAspectCrop
       opacity: image.status == Image.Ready ? 1 : 0
       Behavior on opacity { NumberAnimation { duration: 100 } }
    }

    Rectangle {
        id:transparentRect1
        opacity: .35
        width: parent.width * 2;
        y: parent.height / 2.5
        height: 150;
        transform: Rotation { origin.x: 150 ; origin.y: parent.width; angle: -15}
        color:"#"+alpha+"4A148C"
    }

    Rectangle {
        opacity: .35
        anchors.top: transparentRect1.bottom
        width: parent.width * 2;
        y: parent.height / 2.5
        height: 150;
        transform: Rotation { origin.x: 168 ; origin.y: parent.width; angle: -15}
        color:"#"+alpha+"9C27B0"
    }
}
