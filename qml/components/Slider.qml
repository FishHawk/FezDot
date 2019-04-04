import QtQuick 2.12
import QtQuick.Controls 2.12

Slider {
    id: control

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 20
        width: control.availableWidth
        height: implicitHeight
        color: "white"
        radius: 4
        border.color: "black"

        Rectangle {
            x: 1
            y: 1
            width: control.visualPosition * (parent.width - control.handle.width) + control.handle.width - 2
            height: parent.height - 2
            color: "#8BC34A"
            radius: 4
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 10
        implicitHeight: 18
        radius: 4
        color: control.pressed ? "#f0f0f0" : "#f6f6f6"
        border.color: "#bdbebf"
    }
}