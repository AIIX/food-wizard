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
import "code/helper.js" as HelperJS

Mycroft.Delegate {
    id: root
    skillBackgroundSource: "https://source.unsplash.com/1920x1080/?+food"
    property bool compactMode: parent.height >= 550 ? 0 : 1
    property bool horizontalMode: width > height ? 1 : 0
    fillWidth: true

    Kirigami.Icon {
        anchors.bottom: parent.bottom 
        anchors.horizontalCenter: parent.horizontalCenter
        width: 150
        height: 60
        opacity: 0.7
        source: HelperJS.isLight(Kirigami.Theme.backgroundColor) ? Qt.resolvedUrl("images/edamam-dark.svg") : Qt.resolvedUrl("images/edamam-light.svg")
    }

    Component.onCompleted: {
        txtFld.forceActiveFocus()
    }

    Item {
        anchors.fill: parent

        Item {
            width: parent.width
            height: parent.height / 2
            anchors.verticalCenter: compactMode ? undefined : parent.verticalCenter
            anchors.top: compactMode ? parent.top : undefined

            Rectangle {
                id: heads
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: horizontalMode ? Mycroft.Units.gridUnit * 3.5 : Mycroft.Units.gridUnit * 5
                radius: 10
                color: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.7)

                Image {
                    id: headsImage
                    anchors.left: parent.left
                    anchors.leftMargin: Mycroft.Units.gridUnit / 2
                    anchors.verticalCenter: parent.verticalCenter
                    width: Mycroft.Units.gridUnit * 2
                    height: Mycroft.Units.gridUnit * 2
                    source: Qt.resolvedUrl("images/foodwizz.png")
                }

                Kirigami.Heading {
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: "Find Something To Cook With Custom Ingredients"
                    anchors.left: headsImage.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: Mycroft.Units.gridUnit / 2
                    wrapMode: Text.WordWrap
                }
            }

            Item {
                id: sep
                anchors.top: heads.bottom
                width: parent.width
                height: Kirigami.Units.largeSpacing
            } 
            
            Rectangle {
                id: txtFld
                anchors.top: sep.bottom
                width: parent.width
                height: compactMode ? Kirigami.Units.gridUnit * 4 : Kirigami.Units.gridUnit * 6
                color: "transparent"
                border.width: 2
                radius: Kirigami.Units.gridUnit
                border.color: txtFld.activeFocus ? Kirigami.Theme.linkColor : "transparent"
                KeyNavigation.down: answerButton
                focus: true

                Keys.onReturnPressed: { 
                    txtFldInternal.forceActiveFocus()
                }
                
                TextField {
                    id: txtFldInternal
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.gridUnit
                    KeyNavigation.down: answerButton
                    placeholderText: "Add a list of ingredients e.g., orange, cheese, chicken, lime"
                    onAccepted: {
                        triggerGuiEvent("foodwizard.searchrecipe", {"query": txtFldInternal.text})
                    }
                    Keys.onReturnPressed: {
                        triggerGuiEvent("foodwizard.searchrecipe", {"query": txtFldInternal.text})
                    }
                }
            }
            
            Button {
                id: answerButton
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: txtFld.bottom
                anchors.margins: Kirigami.Units.gridUnit
                height: !compactMode ? Kirigami.Units.gridUnit * 4 : Kirigami.Units.gridUnit * 3
                KeyNavigation.up: txtFld
                
                background: Rectangle {
                    color: answerButton.activeFocus ? "#4169E1" : "#4124AA" 
                    radius: Kirigami.Units.gridUnit
                }

                contentItem: Item {
                    Kirigami.Heading {
                        anchors.centerIn: parent
                        text: "Get Food Recipes!"
                        level: compactMode ? 3 : 1
                    }
                }

                onClicked: {
                    triggerGuiEvent("foodwizard.searchrecipe", {"query": txtFldInternal.text})
                }

                Keys.onReturnPressed: {
                    clicked()
                }
            }
        }
    }
}
