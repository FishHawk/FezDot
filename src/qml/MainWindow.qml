import QtQuick 2.12
import QtQuick.Controls 2.12

import Backend 1.0

ApplicationWindow {
    id: mainWindow

    property int size: Backend.size

    function calculateFlags(){
        let flags = Qt.Window | Qt.Tool | Qt.FramelessWindowHint | Qt.WindowSystemMenuHint
        if (Backend.layer == Backend.AboveOthers) flags = flags | Qt.WindowStaysOnTopHint
        else if (Backend.layer == Backend.BelowOthers) flags = flags | Qt.WindowStaysOnBottomHint
        return flags
    }

    x: Backend.x
    y: Backend.y

    width: size
    height: size

    maximumHeight: size
    maximumWidth: size

    minimumHeight: size
    minimumWidth: size

    onXChanged: Backend.x = x
    onYChanged: Backend.y = y
    onSizeChanged: Backend.size = size

    visible: true
    title: qsTr("Dot Render")
    color: "transparent"
    flags: calculateFlags()

    DotView { anchors.fill: parent }

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
            Action {
                checkable: true
                checked: Backend.layer == Backend.AboveOthers
                icon.name: "window-keep-above"
                text: qsTr("Keep Above Others")
                onTriggered: {
                    if (checked) Backend.layer = Backend.AboveOthers
                    else Backend.layer = Backend.Normal
                }
            }
            Action {
                checkable: true
                checked: Backend.layer == Backend.BelowOthers
                icon.name: "window-keep-below"
                text: qsTr("Keep Below Others")
                onTriggered: {
                    if (checked) Backend.layer = Backend.BelowOthers
                    else Backend.layer = Backend.Normal
                }
            }
            Action {
                icon.name: "edit"
                shortcut: "Ctrl+E"
                text: qsTr("Edit")
                onTriggered: editWindow.visible = true
            }
            Action {
                icon.name: "window-close"
                shortcut: "Ctrl+Q"
                text: qsTr("Close")
                onTriggered: Qt.quit()
            }
        }
    }

    EditWindow { id: editWindow; visible: false }
}
