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

import QtQuick 2.12
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.12
import org.kde.kirigami 2.11 as Kirigami
import QtGraphicalEffects 1.0
import Mycroft 1.0 as Mycroft
import "code/helper.js" as HelperJS

Mycroft.Delegate {
    id: root
    skillBackgroundSource: img.source
    property bool horizontalMode: width > height ? 1 : 0
    fillWidth: true
    
    Keys.onBackPressed: {
        parent.parent.parent.currentIndex--
        parent.parent.parent.currentItem.contentItem.forceActiveFocus()
    }

    Keys.onUpPressed: {
        backButton.forceActiveFocus()
    }

    Keys.onDownPressed: {
        readRecipeButton.forceActiveFocus()
    }

    Item {
        id: topAreaHeaderBackground
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Mycroft.Units.gridUnit * 3
        
        Button {
            id: backButton
            anchors.left: parent.left
            anchors.leftMargin: Mycroft.Units.gridUnit
            anchors.verticalCenter: parent.verticalCenter
            width: Mycroft.Units.gridUnit * 3
            height: Mycroft.Units.gridUnit * 3
            
            background: Rectangle {
                color: Kirigami.Theme.backgroundColor
                radius: 10
            }
            
            contentItem: Kirigami.Icon {
                source: "arrow-left"
                width: Mycroft.Units.gridUnit * 2
                height: Mycroft.Units.gridUnit * 2
                color: Kirigami.Theme.textColor

                ColorOverlay {
                    anchors.fill: parent
                    source: parent
                    color: Kirigami.Theme.textColor
                }
            }

            onClicked: {
                root.parent.parent.parent.currentIndex--
                root.parent.parent.parent.currentItem.contentItem.forceActiveFocus()
            }

            onPressed: {
                backButton.opacity = 0.5
            }

            onReleased: {
                backButton.opacity = 1.0
            }
        }

        Rectangle {
            color: Kirigami.Theme.backgroundColor            
            anchors.left: backButton.right
            anchors.leftMargin: Mycroft.Units.gridUnit
            anchors.right: parent.right
            anchors.rightMargin: Mycroft.Units.gridUnit
            height: parent.height
            radius: 10

            Kirigami.Heading {
                id: title                
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: poweredBy.left
                anchors.bottom: parent.bottom
                fontSizeMode: Text.Fit
                minimumPixelSize: 16
                font.pixelSize: Mycroft.Units.gridUnit * 2
                anchors.margins: Mycroft.Units.gridUnit
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft           
                level: 1
                wrapMode: Text.WordWrap
                text: sessionData.recipeTitle
                color: Kirigami.Theme.textColor
            }

            Kirigami.Icon {
                id: poweredBy
                anchors.right: parent.right
                anchors.rightMargin: Mycroft.Units.gridUnit / 2
                anchors.verticalCenter: parent.verticalCenter
                width: height * 2
                height: parent.height
                source: HelperJS.isLight(Kirigami.Theme.backgroundColor) ? Qt.resolvedUrl("images/edamam-dark.svg") : Qt.resolvedUrl("images/edamam-light.svg")
            }
        }
    }
    
    Flickable {
        id: flickContainer
        anchors.top: topAreaHeaderBackground.bottom
        anchors.topMargin: Mycroft.Units.gridUnit
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomBarArea.top
        anchors.bottomMargin: Mycroft.Units.gridUnit + 10
        contentWidth: parent.width
        contentHeight: ingdLay.implicitHeight
        ScrollBar.vertical: ScrollBar {
            active: true
        }

        clip: true
        
        ColumnLayout {
            id: ingdLay
            width: parent.width
            
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 10

                Item {
                    Layout.preferredWidth: root.width < 500 ? Kirigami.Units.gridUnit * 5 : Kirigami.Units.gridUnit * 10
                    Layout.fillHeight: true                    

                    Image {
                        id: img
                        fillMode: Image.PreserveAspectCrop
                        width: root.width < 500 ? Kirigami.Units.gridUnit * 5 : Kirigami.Units.gridUnit * 10
                        height: root.width < 500 ? Kirigami.Units.gridUnit * 5 : Kirigami.Units.gridUnit * 10
                        source: sessionData.recipeImage

                        Rectangle {
                            id: formSourceRect
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.left: parent.left           
                            anchors.margins: Mycroft.Units.gridUnit / 2
                            height: formSourceRow.implicitHeight + Kirigami.Units.gridUnit
                            color: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.5)
                            radius: Kirigami.Units.smallSpacing

                            Label {
                                id: formSourceRow
                                width: parent.width
                                height: parent.height
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                elide: Text.ElideRight
                                text: qsTr("Source") + ": " + sessionData.recipeSource
                                color: Kirigami.Theme.textColor
                            }
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true 

                    Rectangle {
                        id: formCalorieRect
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.topMargin: Kirigami.Units.smallSpacing
                        width: formCalorieRow.implicitWidth + Kirigami.Units.gridUnit
                        height: formCalorieRow.implicitHeight + Kirigami.Units.gridUnit
                        color: Kirigami.Theme.backgroundColor
                        radius: Kirigami.Units.smallSpacing

                        RowLayout {
                            id: formCalorieRow
                            anchors.centerIn: parent

                            Label {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                elide: Text.ElideRight
                                text: qsTr("Calories") + ": "
                                color: Kirigami.Theme.textColor
                            }

                            Label {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                elide: Text.ElideRight
                                text: Math.round(sessionData.recipeCalories)
                                color: Kirigami.Theme.textColor
                            }
                        }
                    }

                    Rectangle {
                        id: formDietTypeRect
                        anchors.top: formCalorieRect.bottom
                        anchors.topMargin: Kirigami.Units.smallSpacing
                        width: formDietTypeTagsRow.implicitWidth + Kirigami.Units.gridUnit
                        height: formDietTypeTagsRow.implicitHeight + Kirigami.Units.gridUnit
                        color: Kirigami.Theme.backgroundColor
                        radius: Kirigami.Units.smallSpacing

                        RowLayout {
                            id: formDietTypeTagsRow
                            anchors.centerIn: parent

                            Label {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                elide: Text.ElideRight
                                text: qsTr("Diet Type") + ": "
                                color: Kirigami.Theme.textColor
                            }

                            ColumnLayout {
                                id: formDietTypeCol
                                
                                Repeater {
                                    model: sessionData.recipeDietType.dietTags
                                    delegate: Label {
                                        text: modelData
                                        //Layout.fillWidth: true
                                        wrapMode: Text.WordWrap
                                        elide: Text.ElideRight
                                        color: Kirigami.Theme.textColor
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: formHealthTypeRect
                        anchors.top: formDietTypeRect.bottom
                        anchors.topMargin: Kirigami.Units.smallSpacing
                        width: formHealthTagsRow.implicitWidth + Kirigami.Units.gridUnit
                        height: formHealthTagsRow.implicitHeight + Kirigami.Units.gridUnit
                        color: Kirigami.Theme.backgroundColor
                        radius: Kirigami.Units.smallSpacing

                        RowLayout {
                            id: formHealthTagsRow
                            anchors.centerIn: parent

                            Label {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                elide: Text.ElideRight
                                text: qsTr("Health Tags") + ": "
                                color: Kirigami.Theme.textColor
                            }

                            ColumnLayout {
                                id: formHealthTagsCol
                                
                                Repeater {
                                    property var limitedTags: sessionData.recipeHealthTag.slice(0, 3)
                                    model: limitedTags
                                    delegate: Label {
                                        text: modelData
                                        wrapMode: Text.WordWrap
                                        elide: Text.ElideRight
                                        color: Kirigami.Theme.textColor
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Mycroft.Units.gridUnit * 3
                radius: 10
                color: Kirigami.Theme.backgroundColor

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: Mycroft.Units.gridUnit / 2
                    radius: 10
                    color: Kirigami.Theme.highlightColor
                }

                Item {
                    anchors.left: parent.left
                    anchors.leftMargin: Mycroft.Units.gridUnit
                    anchors.right: readButtonItems.left
                    height: parent.height

                    Kirigami.Heading {
                        id: ingredientsLabel
                        level: 1
                        width: parent.width
                        height: parent.height
                        elide: Text.ElideRight
                        visible: tabbar.currentIndex == 0
                        enabled: tabbar.currentIndex == 0
                        wrapMode: Text.WordWrap
                        color: Kirigami.Theme.textColor
                        text: qsTr("Recipe Ingredients")
                    }
        
                    Kirigami.Heading {
                        id: instructionsLabel
                        level: 1
                        width: parent.width
                        height: parent.height
                        elide: Text.ElideRight
                        visible: tabbar.currentIndex == 1
                        enabled: tabbar.currentIndex == 1
                        wrapMode: Text.WordWrap
                        color: Kirigami.Theme.textColor
                        text: qsTr("Recipe Instructions")
                    }
                }

                Item {
                    id: readButtonItems
                    anchors.right: parent.right
                    anchors.rightMargin: Mycroft.Units.gridUnit / 2
                    width: Mycroft.Units.gridUnit * 20
                    height: parent.height

                    Button {
                        id: readRecipeButton
                        anchors.fill: parent
                        anchors.margins: Mycroft.Units.gridUnit / 2
                        KeyNavigation.down: ingredientsTabButton
                        KeyNavigation.up: backButton

                        background: Rectangle {
                            color: Kirigami.Theme.highlightColor
                            radius: 10
                        }
                        contentItem: Item { 
                            RowLayout {
                                anchors.centerIn: parent
                                
                                Kirigami.Icon {
                                    id: readRecipeIcon
                                    Layout.alignment: Qt.AlignLeft
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: Mycroft.Units.gridUnit * 2
                                    source: "speaker"
                                    color: Kirigami.Theme.textColor

                                    ColorOverlay {
                                        anchors.fill: parent
                                        source: parent
                                        color: Kirigami.Theme.textColor
                                    }
                                }

                                Label {
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: instructionsLabel.visible ?  qsTr("Read Instructions") : qsTr("Read Ingredients")
                                    color: Kirigami.Theme.textColor
                                }
                            }
                        }

                        onClicked: {
                            if (ingredientsLabel.visible) {
                                triggerGuiEvent("foodwizard.readrecipe.ingredients", {})
                            }
                            if (instructionsLabel.visible) {
                                triggerGuiEvent("foodwizard.readrecipe.instructions", {})
                            }
                        }

                        onPressed: {
                            readRecipeButton.opacity = 0.5
                        }

                        onReleased: {
                            readRecipeButton.opacity = 1.0
                        }
                    }
                }
            }

            Repeater {
                id: ingredientsOrInstructionsList
                model: tabbar.currentIndex == 0 ? sessionData.recipeIngredients : sessionData.recipeInstructions 

                delegate: Kirigami.AbstractListItem {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 3

                    background: Rectangle {
                        color: Kirigami.Theme.backgroundColor
                        radius: 10
                    }

                    RowLayout {
                        id: ingdRow
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: Kirigami.Units.smallSpacing
                        anchors.rightMargin: Kirigami.Units.smallSpacing
                        spacing: Kirigami.Units.smallSpacing

                        Image {
                            id: ingredientImage
                            Layout.preferredWidth: Kirigami.Units.gridUnit * 2
                            Layout.preferredHeight: Kirigami.Units.gridUnit * 2
                            Layout.topMargin: Kirigami.Units.smallSpacing
                            Layout.bottomMargin: Kirigami.Units.smallSpacing
                            fillMode: Image.PreserveAspectFit
                            visible: tabbar.currentIndex == 0 ? 1 : 0
                            enabled: tabbar.currentIndex == 0 ? 1 : 0
                            source: model.image
                        }

                        Label {
                            id: ingredientName
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: Kirigami.Theme.textColor
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            text: tabbar.currentIndex == 0 ? model.name : (index + 1) + ". " + model.step
                        }
                    }
                }
            }
        }
    }

    GridLayout {
        id: bottomBarArea
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: Mycroft.Units.gridUnit * 3
        columns: root.horizontalMode ? 2 : 1
        
        TabBar {
            id: tabbar
            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 3
            currentIndex: 0
            spacing: Kirigami.Units.smallSpacing
            
            background: Rectangle {
                color: "transparent"
            }

            TabButton {
                id: ingredientsTabButton
                onClicked: tabbar.currentIndex = 0
                enabled: true
                visible: true
                height: Kirigami.Units.gridUnit * 1.5
                KeyNavigation.up: readRecipeButton
                KeyNavigation.right: instructionsTabButton
                KeyNavigation.down: backButton

                background: Rectangle {
                    color: ingredientsLabel.visible ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor
                    radius: 10
                }

                contentItem: Item {
                    Label {
                        anchors.centerIn: parent
                        text: qsTr("Ingredients")
                        color: Kirigami.Theme.textColor
                    } 
                }
            }

            TabButton {
                id: instructionsTabButton
                onClicked: tabbar.currentIndex = 1
                enabled: sessionData.hasInstructions
                visible: sessionData.hasInstructions
                height: Kirigami.Units.gridUnit * 1.5
                KeyNavigation.up: readRecipeButton
                KeyNavigation.left: ingredientsTabButton
                KeyNavigation.down: backButton
                
                background: Rectangle {
                    color: instructionsLabel.visible ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor
                    radius: 10
                }

                contentItem: Item { 
                    Label {
                        anchors.centerIn: parent
                        text: qsTr("Instructions")
                        color: Kirigami.Theme.textColor
                    }
                }
            }
        }
    }
}