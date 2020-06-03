    import QtQuick 2.9
    import QtQuick.Controls 2.2
    import QtQuick.Layouts 1.3
    import org.kde.kirigami 2.5 as Kirigami
    import QtGraphicalEffects 1.0
    import Mycroft 1.0 as Mycroft

    Mycroft.Delegate {
        id: rootItem
        property var recipeModel: sessionData.recipeBlob.hits
        skillBackgroundSource: "https://source.unsplash.com/1920x1080/?+gloomy"

        
        Mycroft.SlideShow {
            model: recipeModel
            interval: 5000
            running: true
            anchors.fill: parent
            focus: true
            delegate: Kirigami.AbstractCard {
                id: cardNItem
                showClickFeedback: true
                width: rootItem.width
                height: rootItem.height
                contentItem: ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing * 2
                    Item {
                        height: rootItem.height > Kirigami.Units.gridUnit * 20 ? Kirigami.Units.gridUnit * 0 : Kirigami.Units.gridUnit * 2
                    }
                    Kirigami.Heading {
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        level: 3
                        text: modelData.recipe.label
                    }
                    Kirigami.Separator {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 1
                    }
                    Image {
                        Layout.fillWidth: true
                        Layout.preferredHeight: rootItem.height / 4
                        source: modelData.recipe.image
                        fillMode: Image.PreserveAspectCrop
                        Component.onCompleted: {
                            if(source == ""){
                                cardNItem.visible = false
                                cardNItem.height = 0
                                cardNItem.width = 0
                            }
                        }
                    }
                    Kirigami.Separator {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 1
                    }
                    Kirigami.FormLayout {
                        id: form
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft
                        
                        Label {
                            id: contentSource
                            Kirigami.FormData.label: "Source:"
                            //Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                            text: modelData.recipe.source
                        }
                        Kirigami.Separator {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 1
                        }
                        Label {
                            id: contentCalorie
                            text: Math.round(modelData.recipe.calories)
                            Kirigami.FormData.label: "Calories:"
                            //Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                        }
                        Kirigami.Separator {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 1
                        }
                        ColumnLayout {
                            id: dietTypeColumn
                            Kirigami.FormData.label: "Diet Type:"
                            Repeater {
                                id: dietTypeRepeater
                                model: modelData.recipe.dietLabels
                                delegate: Label {
                                    text: modelData
                                    //Layout.fillWidth: true
                                    wrapMode: Text.WordWrap
                                    elide: Text.ElideRight
                                }
                                Component.onCompleted: {
                                    if(dietTypeRepeater.count < 0) {
                                        dietTypeColumn.visible = false;
                                    }
                                }
                            }
                        }
                        Kirigami.Separator {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 1
                        }
                        ColumnLayout {
                            //Layout.fillWidth: true
                            visible: healthRepeater.count > 0
                            Kirigami.FormData.label: "Health Tags:"
                            Repeater {
                                id: healthRepeater
                                model: modelData.recipe.healthLabels
                                delegate: Label {
                                    text: modelData
                                    Layout.fillWidth: true
                                    wrapMode: Text.WordWrap
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }
            }
        }
    }
