import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import "." as Com

RowLayout {
    id: control

    property color value

    onValueChanged: {
        inputR.value = value.r * 255
        inputG.value = value.g * 255
        inputB.value = value.b * 255
    }

    Rectangle {
        Layout.preferredWidth: 40
        Layout.preferredHeight: 40
        Grid {
            rows: 2
            columns: 2
            spacing: 0
            Rectangle { color: "lightgray"; width: 20; height: 20 }
            Rectangle { color: "grey"; width: 20; height: 20 }
            Rectangle { color: "grey"; width: 20; height: 20 }
            Rectangle { color: "lightgray"; width: 20; height: 20 }
        }
        Rectangle { color: control.value; width: 40; height: 40; border.width: 1 }
    }

    Com.InputInt {
        id: inputR
        label: "R:"; from: 0; to: 255
        onValueChanged: control.value.r = value / 255
    }
    Com.InputInt {
        id: inputG
        label: "G:"; from: 0; to: 255
        onValueChanged: control.value.g = value / 255
    }
    Com.InputInt {
        id: inputB
        label: "B:"; from: 0; to: 255
        onValueChanged: control.value.b = value / 255
    }
}