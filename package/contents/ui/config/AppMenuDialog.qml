/*
 * Copyright 2016  Daniel Faust <hessijames@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

PlasmaComponents.Dialog {
    id: appMenuDialog

    property string selectedMenuId: null
        
    PlasmaCore.DataSource {
        id: appsSource
        engine: 'apps'
        connectedSources: sources
    }

    content: Item {
        id: contentItem
        width: 300
        height: 400
        
//         RowLayout {
//             anchors.left: parent.left
//             anchors.right: parent.right
//
//             Label {
//                 id: filterLabel
//                 text: i18n('Filter:')
//             }
//
//             TextField {
//                 id: filter
//                 anchors.left: filterLabel.right
//                 anchors.right: parent.right
//                 anchors.leftMargin: units.smallSpacing
//             }
//         }
        
        Rectangle {
            x: 0
            y: filter.height + units.smallSpacing
            width: parent.width
//             height: parent.height - filter.height - units.smallSpacing
            height: parent.height

            PlasmaExtras.ScrollArea {
                anchors.fill: parent

                ListView {
                    id: apps
                    anchors.fill: parent
                    clip: true

                    highlight: PlasmaComponents.Highlight {}
                    highlightMoveDuration: 0
                    highlightResizeDuration: 0

                    delegate: Item {
                        id: appItem
                        width: parent.width
                        height: units.iconSizes.small + 10

                        property bool isHovered: false

                        MouseArea {
                            id: container
                            anchors.fill: parent

                            hoverEnabled: true
                            onEntered: {
                                apps.currentIndex = index
                                isHovered = true
                            }
                            onExited: {
                                isHovered = false
                            }

                            onClicked: {
                                selectedMenuId = modelData
                                appMenuDialog.accept()
                            }

                            RowLayout {
                                x: 5
                                y: 5

                                Item { // Hack - since setting the dimensions of PlasmaCore.IconItem won't work
                                    height: units.iconSizes.small
                                    width: height

                                    PlasmaCore.IconItem {
                                        anchors.fill: parent
                                        source: appsSource.data[modelData].iconName
                                        active: isHovered
                                    }
                                }

                                PlasmaComponents.Label {
                                    text: appsSource.data[modelData].name
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }
                    }

                    Component.onCompleted: {
                        model = listMenuEntries('/')
                    }
                }
            }
        }
    }

    buttons: PlasmaComponents.ButtonRow {
        PlasmaComponents.Button {
            id: cancelButton
            text: i18n('Cancel')
            iconSource: 'dialog-cancel'
            onClicked: {
                appMenuDialog.reject()
            }
        }
    }

    function listMenuEntries(menuId) {
        var m = []

        for (var i = 0; i < appsSource.data[menuId].entries.length; i++) {
            var entry = appsSource.data[menuId].entries[i]
            if (/\.desktop$/.test(entry)) {
                m.push(entry)
            } else if (/\/$/.test(entry) && entry != '.hidden/') {
                m = m.concat(listMenuEntries(entry))
            }
        }

        return m
    }
}
