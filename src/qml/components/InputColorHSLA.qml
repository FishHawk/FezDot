import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.4

import "." as Com

RowLayout {
    id: control

    property color value

    onValueChanged: {
        inputH.value = value.hslHue * 360
        inputS.value = value.hslSaturation * 100
        inputL.value = value.hslLightness * 100
        inputA.value = value.a * 255
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
        id: inputH
        label: "H:"; from: 0; to: 360
        onValueChanged: control.value.hslHue = value / 360
    }
    Com.InputInt {
        id: inputS
        label: "S:"; from: 0; to: 100
        onValueChanged: control.value.hslSaturation = value / 100
    }
    Com.InputInt {
        id: inputL
        label: "L:"; from: 0; to: 100
        onValueChanged: control.value.hslLightness = value / 100
    }
    Com.InputInt {
        id: inputA
        label: "A:"; from: 0; to: 255
        onValueChanged: control.value.a = value / 255
    }
}