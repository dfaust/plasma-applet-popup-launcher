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
import QtQuick.Dialogs 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    property alias cfg_title: title.text
    property alias cfg_icon: icon.text
    property var cfg_apps: []
    property alias cfg_widgetWidth: widgetWidth.value

    PlasmaCore.DataSource {
        id: appsSource
        engine: 'apps'
        connectedSources: sources
    }
    
    GridLayout {
        columns: 2

        PlasmaComponents.Label {
            text: i18n('Title:')
        }

        TextField {
            id: title
        }

        PlasmaComponents.Label {
            text: i18n('Icon:')
        }

        RowLayout {
            TextField {
                id: icon
            }

            PlasmaComponents.Button {
                iconSource: 'folder'
                onClicked: {
                    iconDialog.open()
                }
            }
        }

        Label {
            text: i18n('Applications:')
        }

        ColumnLayout {
            Rectangle {
                width: 200
                height: 200

                PlasmaExtras.ScrollArea {
                    anchors.fill: parent

                    ListView {
                        id: apps
                        anchors.fill: parent
                        clip: true

                        delegate: Item {
                            id: appItem
                            width: parent.width
                            height: units.iconSizes.small + 2*units.smallSpacing

                            property bool isHovered: false
                            property bool isUpHovered: false
                            property bool isDownHovered: false
                            property bool isRemoveHovered: false

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

                                RowLayout {
                                    x: units.smallSpacing
                                    y: units.smallSpacing

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

                                Rectangle {
                                    height: units.iconSizes.small
                                    width: 3*units.iconSizes.small + 4*units.smallSpacing
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    visible: isHovered

                                    radius: units.iconSizes.small / 4
                                    color: 'white'
                                    opacity: 0.8

                                    Behavior on opacity { NumberAnimation { duration: units.shortDuration * 3 } }

                                    RowLayout {
                                        x: units.smallSpacing
                                        spacing: units.smallSpacing

                                        Item {
                                            id: upIcon
                                            height: units.iconSizes.small
                                            width: height
                                            opacity: 1.0

                                            PlasmaCore.IconItem {
                                                anchors.fill: parent
                                                source: 'arrow-up'
                                                active: isUpHovered

                                                MouseArea {
                                                    anchors.fill: parent

                                                    hoverEnabled: true
                                                    onEntered: {
                                                        isUpHovered = true
                                                    }
                                                    onExited: {
                                                        isUpHovered = false
                                                    }

                                                    onClicked: {
                                                        var m = moveUp(apps.model, modelData)
                                                        cfg_apps = m
                                                        apps.model = m
                                                    }
                                                }
                                            }
                                        }

                                        Item {
                                            id: downIcon
                                            height: units.iconSizes.small
                                            width: height
                                            opacity: 1.0

                                            PlasmaCore.IconItem {
                                                anchors.fill: parent
                                                source: 'arrow-down'
                                                active: isDownHovered

                                                MouseArea {
                                                    anchors.fill: parent

                                                    hoverEnabled: true
                                                    onEntered: {
                                                        isDownHovered = true
                                                    }
                                                    onExited: {
                                                        isDownHovered = false
                                                    }

                                                    onClicked: {
                                                        var m = moveDown(apps.model, modelData)
                                                        cfg_apps = m
                                                        apps.model = m
                                                    }
                                                }
                                            }
                                        }

                                        Item {
                                            id: removeIcon
                                            height: units.iconSizes.small
                                            width: height
                                            opacity: 1.0

                                            PlasmaCore.IconItem {
                                                anchors.fill: parent
                                                source: 'remove'
                                                active: isRemoveHovered

                                                MouseArea {
                                                    anchors.fill: parent

                                                    hoverEnabled: true
                                                    onEntered: {
                                                        isRemoveHovered = true
                                                    }
                                                    onExited: {
                                                        isRemoveHovered = false
                                                    }

                                                    onClicked: {
                                                        var m = apps.model
                                                        var i = null
                                                        while ((i = m.indexOf(modelData)) !== -1) {
                                                            m.splice(i, 1)
                                                        }
                                                        cfg_apps = m
                                                        apps.model = m
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Component.onCompleted: {
                            model = plasmoid.configuration.apps
                        }
                    }
                }
            }
        
            PlasmaComponents.Button {
                id: addAppButton
                anchors.right: parent.right
                text: i18n('Add application')
                iconSource: 'list-add'
                onClicked: {
                    appMenuDialog.open()
                }
            }        
        }

        PlasmaComponents.Label {
            text: i18n('Widget width:')
        }

        SpinBox {
            id: widgetWidth
            minimumValue: units.iconSizes.medium + 2*units.smallSpacing
            maximumValue: 1000
            decimals: 0
            stepSize: 10
            suffix: ' px'
        }
    }
    
    FileDialog {
        id: iconDialog
        title: 'Please choose an image file'
        folder: '/usr/share/icons/breeze/'
        nameFilters: [ 'Image files (*.png *.jpg *.xpm *.svg)', 'All files (*)' ]
        onAccepted: {
            icon.text = iconDialog.fileUrl
        }
    }
    
    AppMenuDialog {
        id: appMenuDialog
        onAccepted: {
            var m = apps.model
            m.push(selectedMenuId)
            cfg_apps = m
            apps.model = m
        }
    }

   function moveUp(m, value) {
        var index = m.indexOf(value)
        var newPos = index - 1

        if (newPos < 0)
            newPos = 0

        m.splice(index, 1)
        m.splice(newPos, 0, value)

        return m
    }

    function moveDown(m, value) {
        var index = m.indexOf(value)
        var newPos = index + 1

        if (newPos >= m.length)
            newPos = m.length

        m.splice(index, 1)
        m.splice(newPos, 0, value)

        return m
    }
}
