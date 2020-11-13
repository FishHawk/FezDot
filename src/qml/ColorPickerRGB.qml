import QtQuick 2.12
import QtQuick.Layouts 1.12

import "components" as Com

import Backend 1.0

GridLayout {
    columnSpacing: 10
    rowSpacing: 15
    columns: 2

    Repeater {
        model: 8
        Com.InputColor {
            label: "color" + index + ":"
            mode: Com.InputColor.RGBA
            onValueChanged: Backend.dot.setColors(index, value)

            Connections {
                target: Backend.dot
                onColorsChanged: {
                    let newColor = Backend.dot.colors[index]
                    if (newColor != value) setColor(newColor)
                }
            }
        }
    }
}