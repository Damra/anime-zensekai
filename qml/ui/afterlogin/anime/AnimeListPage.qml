import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import EnumEndpoint 1.0
import QtQuick.Layouts 1.1
import QtQml 2.11
import QtQuick.Window 2.11

import "../../../../js/fonts/MdiFont.js" as MdiFont
import "../../../../js/service/backend.js" as Backend
import "../../../widgets" as Widgets

Page {
    id: animeListPage

    Component.onCompleted: {

    }

    background: Rectangle {
        color:"#212121"
    }

    Item {
        id: modelWrapper

        property int pageSize : 12
        property int page     : 1
        property variant model: animeListModel

        signal isLoaded;
        signal isMoreLoaded;

        ListModel {
            id: animeListModel
        }

        function reload() {
            if (page != 1){
                return;
            }

            console.log("reload");
            animeListModel.clear();

            AnimeRisutoApi.animeListAll({"page":1, "pageSize":pageSize}, function(x){
                animeListCallback(x, isLoaded)
            });
        }

        function loadMore() {
            console.log("loadMore : " + page + " => " + (page+1));
            page++;
            console.log(JSON.stringify({"page":page, "pageSize":pageSize}));
            AnimeRisutoApi.animeListAll({"page":page, "pageSize":pageSize}, function(x){
                animeListCallback(x, isMoreLoaded)
            });
        }

        function animeListCallback(x, callback){

            if (x.statusCode == 200) {
                var jsonResult = JSON.parse(x.result.toString())
                var items = jsonResult["data"]["items"];

                console.log("items size: "+ items.length);

                console.log(items[0]);
                console.log(items[0].primaryTitle);

                items.forEach(function(item){
                    console.log(Object.keys(item));
                    if(!!item && item.primaryTitle!==undefined){
                        animeListModel.append(item);
                    }
                })

                callback();

                //animeInstantiator.model = items.reverse();
            } else {
                popup.popMessage = x.statusMessage
                popup.open()
            }
        }
    }

    Item { id : video; anchors.top: parent.top} /// anchors.top: parent.top

    GridView {
        id:gridLayout

        property real columnWidth: gridLayout.width * 0.32
        property real columnHeight: gridLayout.height * 0.4
        property real cIndex : 0 ;

        anchors.fill: parent
        width: rootWindow.width
        height:parent.height
        clip:true
        model: animeListModel

        cellHeight: columnHeight;
        cellWidth: columnWidth;

        delegate: AnimeListColumnItem {
            x:16
            y:16
            maxHeight:gridLayout.cellHeight
            maxWidth: gridLayout.cellWidth
            parent:gridLayout
            animeModel:animeListModel.get(index)
        }

        onMovementEnded: {
            if(atYEnd) {
                modelWrapper.loadMore();
            }
        }

        onMovementStarted: {
            modelWrapper.reload();
        }

        function clear() {
            ids = new Array()
            model.clear()
        }

        Component.onCompleted: {
            modelWrapper.reload();
        }

        signal autoPuller(string category)
    }

    /*
    Instantiator {
        id:animeInstantiator
        asynchronous: true
        delegate:
    }

    */

}
