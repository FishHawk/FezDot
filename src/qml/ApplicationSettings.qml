import QtQuick 2.12

import Backend 1.0

QtObject {
    property string selectedTheme

    function loadAllSettings() {
        selectedTheme = Backend.loadSetting("selectedTheme", "Default");
        Backend.loadTheme(selectedTheme)
    }

    function saveAllSettings() {
        Backend.saveSetting("selectedTheme", selectedTheme)
    }

    Component.onCompleted: loadAllSettings()
}