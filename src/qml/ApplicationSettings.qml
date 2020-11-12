import QtQuick 2.14

import Backend 1.0

QtObject {
    property bool stayOnTopHint
    property string selectedTheme: "default"

    function limitRange(value, lowerBound, upperBound) {
        if (value > upperBound) {
            return upperBound
        } else if (value < lowerBound) {
            return lowerBound
        } else {
            return value
        }
    }

    function loadAllSettings() {
        stayOnTopHint = Backend.loadSetting("stayOnTopHint", true);
        selectedTheme = Backend.loadSetting("selectedTheme", "default");

        Backend.loadTheme(selectedTheme)
    }

    function saveAllSettings() {
        Backend.saveSetting("stayOnTopHint", stayOnTopHint)
        Backend.saveSetting("selectedTheme", selectedTheme)
    }

    Component.onCompleted: loadAllSettings()
}