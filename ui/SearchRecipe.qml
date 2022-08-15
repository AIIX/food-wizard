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

Mycroft.ScrollableDelegate {
    id: root
    property int uiWidth: parent.width
    skillBackgroundSource: "https://source.unsplash.com/1920x1080/?+food"
    property bool compactMode: parent.height >= 550 ? 0 : 1
    fillWidth: compactMode ? 1 : 0
    
    Component.onCompleted: {
        uiGridView.forceActiveFocus()
    }
    
    Keys.onBackPressed: {
        parent.parent.parent.currentIndex--
        parent.parent.parent.currentItem.contentItem.forceActiveFocus()
    }
    
    Kirigami.CardsGridView {
        id: uiGridView
        maximumColumnWidth: Kirigami.Units.gridUnit * 12
        cellHeight: Kirigami.Units.gridUnit * 15
        model: sessionData.recipeBlob.hits
        keyNavigationEnabled: true
        highlightFollowsCurrentItem: true
        
        delegate: Kirigami.Card {
            id: card
            //NOTE: force the thumbnail to be square to not make the image resize when loaded (also, saves memory)
            banner.sourceSize.width: width
            banner.sourceSize.height: width

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
                var RecipeUrl = modelData.recipe.url;
                triggerGuiEvent("foodwizard.showrecipe", {"recipe": RecipeUrl});
            }
            Keys.onReturnPressed: {
                clicked()
            }
            
            Rectangle {
                anchors.fill: parent
                visible: card.activeFocus ? 1 : 0
                color: Qt.rgba(0, 0, 3, 0.2)
            }
        }
    }

    Kirigami.Heading {
        text: "No recipes found"
        parent: root
        anchors.centerIn: parent
        visible: uiGridView.count == 0
    }
}
