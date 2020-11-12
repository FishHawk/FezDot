import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Backend 1.0

ApplicationWindow {
    id: mainWindow

    width: 400
    height: 400

    visible: true
    title: qsTr("Dot Render")
    color: "transparent"
    flags: Qt.Window | Qt.Tool | Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.WindowStaysOnTopHint

    ApplicationSettings { id: settings }

    DotView { anchors.fill: parent }

    Shortcut { sequence: "Ctrl+E"; onActivated: editWindow.visible = true }
    Shortcut { sequence: "Ctrl+Q"; onActivated: Qt.quit() }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: contextMenu.popup()
        onPressAndHold: {
            if (mouse.source === Qt.MouseEventNotSynthesized)
                contextMenu.popup()
        }

        Menu {
            id: contextMenu
            Action { text: qsTr("Edit"); onTriggered: editWindow.visible = true }
            Action { text: qsTr("Quit"); onTriggered: Qt.quit() }
        }
    }

    EditWindow { id: editWindow; visible: false }
}
