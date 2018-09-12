import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.0
import org.kde.kirigami 2.4 as Kirigami

import Mycroft 1.0 as Mycroft

Mycroft.DelegateBase {
    //property alias recipeTitle: title.text
    //property alias recipeImage: img.source
    //property alias recipeCalories: contentCalorie.text
    //property alias recipeDietType: contentDietType.text
    //property alias recipeHealthTag: contentHealthTag.text
    //property alias recipeSource: contentSource.text
    //property var recipeIngredients
    property var recipeBlob: JSON.parse(recipeLayout.model)
    property var recipeModel: recipeBlob.hits
    property var uiWidth: parent.width
    backgroundImage: "https://source.unsplash.com/1920x1080/?+food"

    Rectangle {
        id: backgroundRect
        color: "#00222222"
        anchors.fill: parent

        GridLayout { //maybe a flickable in case there's too much text instead of Eliding (Flickable delegate base?)
            id: uiGridView
            anchors.fill: parent
            anchors.margins: Kirigami.Units.largeSpacing
            columns: width > 800 ? 2 : 1
            flow: width > 800 ? GridLayout.LeftToRight : GridLayout.TopToBottom
            rows: recipeLayout.count

            Repeater {
                id: recipeLayout
                model: recipeModel
                
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    Image {
                        id: recipeFrontImage
                        fillMode: Image.PreserveAspectCrop
                        source: modelData.recipe.image
                        Layout.preferredWidth: uiGridView.width > 800 ? Kirigami.Units.gridUnit * 4 : Kirigami.Units.gridUnit * 2
                        Layout.preferredHeight: uiGridView.width > 800 ? Kirigami.Units.gridUnit * 4 : Kirigami.Units.gridUnit * 2
                    }
                    Label {
                        id: recipeFrontLabel
                        anchors.verticalCenter: recipeFrontImage.verticalCenter
                        Layout.fillWidth: true
                        text: modelData.recipe.label
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var sendReadRecipe = "read recipe " + recipeFrontLabel.text.replace(/[^A-Z0-9]+/ig, "");
                            console.log(sendReadRecipe)
                            Mycroft.MycroftController.sendText(sendReadRecipe)
                        }
                    }
                }
            }
        }
    }
}

