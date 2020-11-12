import QtQuick 2.14

import Backend 1.0

QtObject {
    property string selectedTheme: "default"

    function loadAllSettings() {
        selectedTheme = Backend.loadSetting("selectedTheme", "default");
        Backend.loadTheme(selectedTheme)
    }

    function saveAllSettings() {
        Backend.saveSetting("selectedTheme", selectedTheme)
    }

    Component.onCompleted: loadAllSettings()
}