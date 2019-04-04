import QtQuick 2.12
import QtQuick.Controls 2.12

RadioButton {
    id: control

    indicator: Rectangle {
        implicitWidth: 26
        implicitHeight: 26
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 13
        border.color: control.down ?  Qt.darker("#8BC34A") : "#8BC34A"

        Rectangle {
            width: 14
            height: 14
            x: 6
            y: 6
            radius: 7
            color: control.down ? Qt.darker("#8BC34A") : "#8BC34A"
            visible: control.checked
        }
    }
}