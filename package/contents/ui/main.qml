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
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    property var title: plasmoid.configuration.title
    property var icon: plasmoid.configuration.icon
    property var apps: plasmoid.configuration.apps
    property int widgetWidth: plasmoid.configuration.widgetWidth

    Plasmoid.compactRepresentation: PlasmaCore.IconItem {
        source: icon
        width: units.iconSizes.medium
        height: units.iconSizes.medium
        active: mouseArea.containsMouse

        PlasmaCore.ToolTipArea {
            anchors.fill: parent
            icon: parent.source
            mainText: title
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: plasmoid.expanded = !plasmoid.expanded
            hoverEnabled: true
        }
    }

    Plasmoid.fullRepresentation: FullRepresentation {}

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
//     Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
}
