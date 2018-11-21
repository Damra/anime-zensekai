import QtQuick 2.0
import QtQuick.Controls 1.4
import "../../widgets/"

Item {

    z:4
    width: parent.width

    property bool refresh: state == "pulled" ? true : false

    Row {
        visible: false;
        spacing: 6
        height: childrenRect.height
        anchors.centerIn: parent

        Ctext {
            id: arrow
            font: {
                pointSize:15;
                family:fontAwesome.family
            }

          //  anchors.centerIn: parent.verticalCenter
            text: awesome.icons.fa_arrow_up
            transformOrigin: Item.Center
            Behavior on rotation { NumberAnimation { duration: 200 } }
        }

        Text {
            id: label
            anchors.verticalCenter: arrow.verticalCenter
            text: "Yenilemek için çekin...    "
            font.pointSize: 18
            color: "#999999"
        }

    }

    states: [
        State {
            name: "base"; when: mainListView.contentY >= -60
            PropertyChanges { target: arrow; rotation: 180 }
        },
        State {
            name: "pulled"; when: mainListView.contentY < -60
            PropertyChanges { target: label; text: "Yenilemek için bırakın..." }
            PropertyChanges { target: arrow; rotation: 0 }
        }
    ]

    signal refreshSignal;

    onRefreshChanged: {
        console.log(refresh);
    }

}
