import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import EnumEndpoint 1.0

import "../../../../js/fonts/MdiFont.js" as MdiFont
import "../../../../js/service/backend.js" as Backend
import "../../../widgets" as Widgets

Page {
    id: animeDetailPage
    property string uniqueId : ""
    property var resultData;

    background: Rectangle {
        color:"#212121"
    }

    Component.onCompleted: {
        AnimeRisutoApi.animeDetail(uniqueId, function (x) {
            console.log(x.statusCode, x.statusMessage, x.path);
            resultData = JSON.parse(x.result["data"]["items"]);
        })
    }

    onResultDataChanged: {
        animeTitle.text = resultData.primaryTitle;
    }

    ScrollView {
        anchors.top: toolbar.bottom
        anchors.fill: parent
        height: parent.height
        width: parent.width

        Text {
            id: animeTitle;
            anchors.fill: parent;

        }
    }
}
