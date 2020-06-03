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

Mycroft.Delegate {
    id: root
    skillBackgroundSource: "https://source.unsplash.com/1920x1080/?+food"
    
    Item {
        anchors.centerIn: parent
        
        Kirigami.Heading {
            id: heads
            text: "Find Something To Cook With Custom Ingredients"
            anchors.top: parent.top
        }
        
        TextField {
            id: txtFld
            anchors.bottom: heads.bottom
            width: parent.width
            height: Kirigami.Units.gridUnit * 6
            placeholderText: "Add a list of ingredients e.g., orange, cheese, chicken, lime"
            onAccepted: {
                triggerGuiEvent("foodwizard.searchrecipe", { "utterance": txtFld.text})
            }
        }
    }
}
