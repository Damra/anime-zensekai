import QtQuick 2.0
import QtGraphicalEffects 1.0

LinearGradient {
    property variant control
    anchors.fill: control
    source: control
    start: Qt.point(control.y, control.x + 55)
    end: Qt.point(control.x, control.height)
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#ff9c27b0" }
        GradientStop { position: 0.5; color: "#ff4a148c" }
        GradientStop { position: 1.0; color: "#ff4a148c" }
    }
}
