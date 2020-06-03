/*
 *  Copyright 2018 by Aditya Mehra <aix.m@outlook.com>
 *  Copyright 2018 Marco Martin <mart@kde.org>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick.Layouts 1.4
import QtQuick 2.8
import QtQuick.Controls 2.2
import org.kde.kirigami 2.10 as Kirigami

import Mycroft 1.0 as Mycroft

Mycroft.Delegate {
    id: root
    skillBackgroundSource: img.source

    Component.onCompleted: {
        console.log(JSON.stringify(recipeIngredients))
    }
    
    Keys.onBackPressed: {
        parent.parent.parent.currentIndex--
        parent.parent.parent.currentItem.contentItem.forceActiveFocus()
    }
    
    ColumnLayout {
        anchors.fill: parent
    
        GridLayout {
            id: grid
            Layout.fillWidth: true
            columns: root.wideMode ? 2 : 1
            columnSpacing: Kirigami.Units.largeSpacing
            rowSpacing: Kirigami.Units.largeSpacing * 2
            Kirigami.Heading {
                id: title
                Layout.alignment: root.wideMode ? Qt.AlignLeft : Qt.AlignHCenter
                level: 1
                Layout.fillWidth: true
                Layout.columnSpan: grid.columns
                wrapMode: Text.WordWrap
                text: sessionData.recipeTitle
            }
            Image {
                id: img
                fillMode: Image.PreserveAspectCrop
                Layout.alignment: root.wideMode ? Qt.AlignLeft : Qt.AlignHCenter
                Layout.preferredWidth: Kirigami.Units.gridUnit * 10
                Layout.preferredHeight: Kirigami.Units.gridUnit * 10
                source: sessionData.recipeImage
            }

            Kirigami.FormLayout {
                id: form
                Layout.fillWidth: true
                Layout.minimumWidth: implicitWidth
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom

                Label {
                    id: contentSource
                    Kirigami.FormData.label: "Source:"
                    //Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    text: sessionData.recipeSource
                }
                Label {
                    id: contentCalorie
                    text: Math.round(sessionData.recipeCalories)
                    Kirigami.FormData.label: "Calories:"
                    //Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                }
                ColumnLayout {
                    //Layout.fillWidth: true
                    Kirigami.FormData.label: "Diet Type:"
                    Repeater {
                        model: sessionData.recipeDietType.dietTags
                        delegate: Label {
                            text: modelData
                            //Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                        }
                    }
                }
                ColumnLayout {
                    //Layout.fillWidth: true
                    visible: healthRepeater.count > 0
                    Kirigami.FormData.label: "Health Tags:"
                    Repeater {
                        id: healthRepeater
                        model: sessionData.recipeDietType.healthTags
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
                model: sessionData.recipeIngredients.ingredients
            }
            Item {
                Layout.fillHeight: true
            }
        }
    }
}
