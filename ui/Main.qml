import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.0
import org.kde.kirigami 2.4 as Kirigami

import Mycroft 1.0 as Mycroft

Mycroft.DelegateBase {
    property var recipeBlob: JSON.parse(recipeLayout.model)
    property var recipeModel: recipeBlob.hits
    property int uiWidth: parent.width
    backgroundImage: "https://source.unsplash.com/1920x1080/?+food"

    Kirigami.CardsGridView {
        id: uiGridView
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        maximumColumnWidth: Kirigami.Units.gridUnit * 12
        cellWidth: width > maximumColumnWidth ? width / 2 : width / 2
        cellHeight: Kirigami.Units.gridUnit * 15
        model: recipeModel
        delegate:
            Kirigami.Card {
            id: card
            banner {
                title: modelData.recipe.label
                imageSource: modelData.recipe.image
            }
            contentItem: Label {
                wrapMode: Text.WordWrap
                text: modelData.recipe.source
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var sendReadRecipe = "read recipe " + modelData.recipe.label.replace(/[^A-Z0-9]+/ig, "");
                    Mycroft.MycroftController.sendText(sendReadRecipe)
                }
            }
        }
    }
}
