
import QtQuick 2.6
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0


Button {
    id: control
    text: qsTr("Push me!")
    font.pointSize: 14

    property alias name: control.text
    property color baseColor
    property color borderColor

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "#ffffff" : "#ffffff"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        id: bgrect
        implicitWidth: 100
        implicitHeight: 48
        opacity: control.down ? 0.7 : 1
        radius: height / 6
        color: baseColor != null ? baseColor: "transparent"
        border.color:  borderColor
        border.width: control.activeFocus ? 3 : 2
    }
}
