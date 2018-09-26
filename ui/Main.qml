import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.2
import org.kde.kirigami 2.4 as Kirigami

import Mycroft 1.0 as Mycroft

Mycroft.ScrollableDelegate {
    id: delegate
    property var recipeBlob: JSON.parse(recipeLayout.model)
    property var recipeModel: recipeBlob.hits
    property int uiWidth: parent.width
    backgroundImage: "https://source.unsplash.com/1920x1080/?+food"
    graceTime: 30000

    Kirigami.CardsGridView {
        id: uiGridView
        maximumColumnWidth: Kirigami.Units.gridUnit * 12
        cellWidth: width > maximumColumnWidth ? width / 2 : width / 2
        cellHeight: Kirigami.Units.gridUnit * 15
        model: recipeModel
        delegate: Kirigami.Card {
            id: card
            showClickFeedback: true
            banner {
                title: modelData.recipe.label
                source: modelData.recipe.image
                titleWrapMode: Text.WordWrap
                titleLevel: 2
            }
            contentItem: Label {
                wrapMode: Text.WordWrap
                text: modelData.recipe.source
            }
            onClicked: {
                var sendReadRecipe = "read recipe " + modelData.recipe.label.replace(/[^A-Z0-9]+/ig, "");
                Mycroft.MycroftController.sendText(sendReadRecipe)
            }
        }
    }
}
