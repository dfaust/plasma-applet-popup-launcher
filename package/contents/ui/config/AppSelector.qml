
import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Dialog {
    id: dialog
    title: i18n("Select an application to add")
    standardButtons: StandardButton.Cancel

    width: 660
    height: 660

    property string selectedMenuId: ""

    PlasmaCore.DataSource {
        id: appsSource
        engine: 'apps'
        connectedSources: sources
    }

    ListModel {
        id: fullModel
    }

    ListModel {
        id: filteredModel
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: units.smallSpacing

        GroupBox {
            title: i18n("Filter")
            Layout.fillWidth: true

            TextField {
                id: searchField
                width: parent.width

                placeholderText: i18n("filter apps")
                onTextChanged: filterApps(text)
            }
        }

        GroupBox {
            title: i18n("Applications")
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollView {
                anchors.fill: parent

                ListView {
                    id: apps
                    anchors.fill: parent
                    clip: true

                    model: filteredModel

                    highlight: PlasmaComponents.Highlight {}
                    highlightMoveDuration: 50
                    highlightResizeDuration: 0

                    delegate: Item {
                        width: parent.width
                        height: units.iconSizes.small + 2 * units.smallSpacing

                        property bool isHovered: false

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onEntered: {
                                apps.currentIndex = index;
                                isHovered = true;
                            }
                            onExited: isHovered = false
                            onClicked: {
                                selectedMenuId = key;
                                //appMenuDialog.accept();
                                dialog.accept();
                            }

                        }

                        RowLayout {
                            spacing: units.smallSpacing

                            PlasmaCore.IconItem {
                                Layout.preferredWidth: units.iconSizes.small
                                Layout.preferredHeight: units.iconSizes.small
                                source: appsSource.data[key].iconName
                                active: isHovered
                            }

                            Label {
                                text: displayName
                                height: parent.height
                            }

                        }
                        
                    }
                }
            }

        }

    }


    Component.onCompleted: {
        listMenuEntries("/");
    }

    function listMenuEntries(menuId) {
        const menu = appsSource.data[menuId];

        if (menu === undefined) {
            console.log("Error: Menu category " + menuId + " does not exist");
            return;
        }
        if (menu.entries === undefined) {
            console.log("Warning: Menu category " + menuId + " has no entries");
            return;
        }

        //console.log("Entries:", menu.entries);

        const resultMap = new Map();

        for (var i = 0; i < menu.entries.length; i++) {
            const entry = menu.entries[i];
            //console.log("Menu ENTRY", menuId, name);

            if ( /^([^\.\/]+\/)+$/.test(entry) ) {
                // folder so we recurse further into it
                //console.log("FOLDER:", entry);
                listMenuEntries(entry);
            }
            else if ( /\.desktop$/.test(entry) ) {
                // we found an app
                //console.log("APP:", entry);

                const name = appsSource.data[entry].name;
                const displayName = `${name} (${entry})`;

                resultMap.set(entry, {
                    name: name,
                    displayName: displayName
                });
            }
            else {
                // ignore
            }

        }

        // copy set into fullModel
        for (const [key, value] of resultMap) {
            fullModel.append({
                key: key,
                name: value.name,
                displayName: value.displayName
            });
        }

        // copy into filtered model
        for (var i = 0; i < fullModel.count; i++) {
            const entry = fullModel.get(i);
            filteredModel.append(entry);
        }
    }

    function filterApps(query) {
        filteredModel.clear();

        for (var i = 0; i < fullModel.count; i++) {
            const app = fullModel.get(i);

            if (matcher(app.name.toLowerCase(), query.toLowerCase())) {
                filteredModel.append(app);
            }
        }
    }

    function matcher(text, pattern) {
        if (pattern === "") return true;
        var ti = 0;

        for (var pi = 0; pi < pattern.length; pi++) {
            const ch = pattern[pi];
            ti = text.indexOf(ch, ti);

            if (ti === -1) return false;
            ti++;
        }
        return true;
    }

}
