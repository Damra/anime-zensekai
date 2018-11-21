import QtQuick 2.0
import QtQuick.Layouts 1.2

ColumnLayout {
    property variant animeModel;
    property int maxWidth; // however you want to define the max width
    property int maxHeight;

    parent: parent;
    width: maxWidth
    height: imageAnime.height + animeTitleRect.height ;
    visible: model ? true: false

    Layout.margins: 16
    Image {
        id: imageAnime
        smooth: true
        z: 14
        Layout.preferredWidth: maxWidth
        Layout.preferredHeight: maxHeight
        fillMode: Image.PreserveAspectFit
        source: animeModel.coverImageUrl
        width: maxWidth
        height: maxHeight;
        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter;
    }

    Rectangle {
        id:animeTitleRect
        width: parent.width  // width of the actual text, so your bubble will change to match the text width
        height: animeTitle.height + 5
        color: animeModel.primaryTitle ? "grey":"blue"

        property var isTitleMoreLetter: animeModel.primaryTitle.length > 25;
        property var moreLetterSuffix: isTitleMoreLetter ? "...":"";
        property var title: isTitleMoreLetter ? animeModel.primaryTitle.substring(0, 25) + moreLetterSuffix : animeModel.primaryTitle;

        Text {
            id:animeTitle
            color: "white"
            text: title
            width: maxWidth  // max width that your text can reach before wrapping
            wrapMode: "WordWrap"
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log(animeModel.uniqueId)
            console.log("uniqueId", animeModel.uniqueId);
            goToAnimeDetail(animeModel.uniqueId)
        }
    }

    Component.onCompleted: {
        console.log(animeModel)
    }
}
