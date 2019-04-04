import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Backend 1.0

ApplicationWindow {
    id: mainWindow

    x: 0
    y: 0
    width: 300
    height: 300

    visible: true
    title: qsTr("Dot Render")
    color: "transparent"
    flags: Qt.Window | Qt.Tool | Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.WindowStaysOnTopHint

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }
    
    DotView {
        anchors.fill: parent

        Binding { target: Dot; property: "height"; value: height; delayed: false}
        Binding { target: Dot; property: "width"; value: width; delayed: false }
    }

    MouseArea {
        anchors.fill: parent;
        property point clickPos

        onPressed: {
            clickPos = Qt.point(mouse.x,mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            mainWindow.x += delta.x;
            mainWindow.y += delta.y;
        }
    }

}
