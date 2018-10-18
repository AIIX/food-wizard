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
