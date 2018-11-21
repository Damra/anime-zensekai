import QtQuick 2.0

Item {

    height: header.height
    width: header.width
    property alias mainListView

    property bool refresh: state == "pulled" ? true : false

    Row {

        spacing: 6
        height: header.height
        anchors.horizontalCenter:  parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.centerIn: parent

        Image {
            id: arrow
            source: "qrc:/res/images/icon-refresh.png"
            transformOrigin: Item.Center
            Behavior on rotation { NumberAnimation { duration: 200 } }
        }

        Text {
            id: label
            anchors.verticalCenter: arrow.verticalCenter
            text: "Daha fazlası için çekin...    "
            font.pointSize:  18
            color: "#999999"
        }

    }

    Timer {
        id: timer
        interval: 100;
       // running: mainListView.contentY;
        repeat: true
        onTriggered: {

            console.log("mainListView.contentY",mainListView.contentY)

        }
    }


    states: [
        State {
            name: "base"; when: mainListView.contentY >= 60
            PropertyChanges { target: arrow; rotation: 360 }
        },
        State {
            name: "pulled"; when: mainListView.contentY < 60
            PropertyChanges { target: label; text: "Daha fazlası için bırakın..." }
            PropertyChanges { target: arrow; rotation: 180 }
        }
    ]
}
