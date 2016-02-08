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
import QtQuick 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kio 1.0 as Kio

Item {
    Layout.minimumWidth: widgetWidth
    Layout.minimumHeight: (units.iconSizes.small + 15) * listView.count - 5

    Layout.maximumWidth: Layout.minimumWidth
    Layout.maximumHeight: Layout.minimumHeight

    Layout.preferredWidth: Layout.minimumWidth
    Layout.preferredHeight: Layout.minimumHeight

    Component.onCompleted: {
        // trigger adding all sources already available
        for (var i in appsSource.sources) {
            appsSource.sourceAdded(appsSource.sources[i]);
        }
        console.log('units.iconSizes.small:  ' + units.iconSizes.small)
        console.log('units.iconSizes.medium: ' + units.iconSizes.medium)
    }
    
    PlasmaCore.DataSource {
        id: appsSource
        engine: 'apps'

        onSourceAdded: {
            connectSource(source)
            console.log('Source added: ' + source)
        }

        onSourceRemoved: {
            disconnectSource(source);
            console.log('Source removed: ' + source)
        }
    }
    
    Kio.KRun {
        id: kRun
    }

    PlasmaExtras.ScrollArea {
        anchors.fill: parent
        
        ListView {
            id: listView
            anchors.fill: parent
            spacing: 5

            model: apps

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
                        listView.currentIndex = index
                        isHovered = true
                    }
                    onExited: {
                        isHovered = false
                    }

                    onClicked: {
                        kRun.openUrl(appsSource.data[modelData].entryPath)
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
        }
    }
}
