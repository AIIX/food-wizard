import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.0
import org.kde.kirigami 2.4 as Kirigami

import Mycroft 1.0 as Mycroft

Mycroft.PaginatedDelegate {
    id: root
    property alias recipeTitle: title.text
    property alias recipeImage: img.source
    property int recipeCalories
    property alias recipeSource: contentSource.text
    property var recipeIngredients
    property var recipeDietType
    property var recipeHealthTag
    graceTime: 30000

    backgroundImage: img.source

    Component.onCompleted: {
        console.log(JSON.stringify(recipeIngredients))
    }

    //Page 1
    Kirigami.ScrollablePage {
        GridLayout {
            id: grid
            Layout.fillWidth: true
            columns: root.wideMode ? 2 : 1
            columnSpacing: Kirigami.Units.largeSpacing
            Kirigami.Heading {
                id: title
                Layout.alignment: root.wideMode ? Qt.AlignLeft : Qt.AlignHCenter
                level: 1
                //Layout.fillWidth: true
                Layout.columnSpan: grid.columns
                wrapMode: Text.WordWrap
            }
            Image {
                id: img
                fillMode: Image.PreserveAspectCrop
                Layout.alignment: root.wideMode ? Qt.AlignLeft : Qt.AlignHCenter
                Layout.preferredWidth: Kirigami.Units.gridUnit * 10
                Layout.preferredHeight: Kirigami.Units.gridUnit * 10
            }

            Kirigami.FormLayout {
                id: form
                Layout.fillWidth: true
                Layout.minimumWidth: implicitWidth
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom

                Label {
                    id: contentSource
                    Kirigami.FormData.label: "Source:"
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                }
                Label {
                    id: contentCalorie
                    text: Math.round(recipeCalories)
                    Kirigami.FormData.label: "Calories:"
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    Kirigami.FormData.label: "Diet Type:"
                    Repeater {
                        model: recipeDietType.dietTags
                        delegate: Label {
                            text: modelData
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                        }
                    }
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    visible: healthRepeater.count > 0
                    Kirigami.FormData.label: "Health Tags:"
                    Repeater {
                        id: healthRepeater
                        model: recipeDietType.healthTags
                        delegate: Label {
                            text: modelData
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                        }
                    }
                }
            }
            Item {
                Layout.fillHeight: true
            }
        }
    }

    //Page 2
    Kirigami.ScrollablePage {
        ColumnLayout {
            Layout.fillWidth: true

            Kirigami.Heading {
                id: ingredientsLabel
                level: 1
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "Ingredients:"
            }

            Repeater {
                id: ingredientsList
                delegate: Label {
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    text: "• " + modelData
                }
                model: recipeIngredients.ingredients
            }
            Item {
                Layout.fillHeight: true
            }
        }
    }
}
