import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.0
import org.kde.kirigami 2.4 as Kirigami

import Mycroft 1.0 as Mycroft

Mycroft.PaginationBase {
    property alias recipeTitle: title.text
    property alias recipeImage: img.source
    property alias recipeCalories: contentCalorie.text
    property alias recipeSource: contentSource.text
    property var recipeIngredients
    property var recipeDietType
    property var recipeHealthTag
    graceTime: 30000

        GridLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            columns: 2

            Image {
                id: img
                fillMode: Image.PreserveAspectCrop
                Layout.preferredWidth: Kirigami.Units.gridUnit * 4
                Layout.preferredHeight: Kirigami.Units.gridUnit * 4
            }

            ColumnLayout {
                Layout.fillWidth: true
                Kirigami.Heading {
                    id: title
                    level: 1
                    Layout.fillWidth: true
                    //text: modelData.title
                    wrapMode: Text.WordWrap
                }


                Row {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    Label {
                        id: contentSourceLabel
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                        text: "Source:"
                    }

                    Label {
                        id: contentSource
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                    }

                }

                Row {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    Label {
                        id: contentCalorieLabel
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                        text: "Calories:"
                    }

                    Label {
                        id: contentCalorie
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                    }

                }

                Row {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    Label {
                        id: contentDietTypeLabel
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                        text: "Diet Type:"
                    }

                    Repeater {
                        id: contentDietTypeLv
                        model: recipeDietType.dietTags
                        Label {
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                            text: modelData
                        }
                    }
                }

                Row {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    Label {
                        id: contentHealthTagLabel
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                        text: "Health Tags:"
                    }

                    Repeater {
                        id: contentHealthTag
                        model: recipeHealthTag.healthTags
                        Label {
                            Layout.columnSpan: 2
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                            //text: recipeHealthTag.healthTags
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            //Layout.columnSpan: 2

            ColumnLayout{
                Layout.fillWidth: true

                Kirigami.Heading {
                    id: ingredientsLabel
                    level: 1
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: "Ingredients:"
                }

                ListView {
                    id: ingredientsList
                    Layout.fillWidth: true
                    implicitHeight: 200
                    delegate: Label {
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                        text: modelData
                    }
                    model: recipeIngredients.ingredients
                }
            }
        }
    }
