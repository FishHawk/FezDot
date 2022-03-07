import QtQuick 2.12
import QtQuick.Layouts 1.12

import "components" as Com

import Backend 1.0

ColumnLayout {

    function distributeR() {
        for (let i = 0; i < 8; i++) {
            let valueR = startR.value + stepR.value * i
            colors.itemAt(i).value.r = (valueR % 256) / 255
        }
    }

    function distributeG() {
        for (let i = 0; i < 8; i++) {
            let valueG = startG.value + stepG.value * i
            colors.itemAt(i).value.g = (valueG % 256) / 255
        }
    }

    function distributeB() {
        for (let i = 0; i < 8; i++) {
            let valueB = startB.value + stepB.value * i
            colors.itemAt(i).value.b = (valueB % 256) / 255
        }
    }

    function distributeA() {
        for (let i = 0; i < 8; i++) {
            let valueA = startA.value + stepA.value * i
            colors.itemAt(i).value.a = (valueA % 256) / 255
        }
    }

    Repeater {
        id: colors
        model: 8
        Com.InputColorRGBA {
            value: Backend.dot.colors[index]
            onValueChanged: Backend.dot.setColors(index, value)
            Connections {
                target: Backend.dot
                function onColorsChanged() {
                    let newColor = Backend.dot.colors[index]
                    if (newColor != value) value = newColor
                }
            }
        }
    }

    RowLayout {
        Layout.leftMargin: 45

        Com.InputInt {
            id: startR
            label: qsTr("Start:"); from: 0; to: 255
            onValueChanged: distributeR()
        }
        Com.InputInt {
            id: startG
            label: qsTr("Start:"); from: 0; to: 255
            onValueChanged: distributeG()
        }
        Com.InputInt {
            id: startB
            label: qsTr("Start:"); from: 0; to: 255
            onValueChanged: distributeB()
        }
        Com.InputInt {
            id: startA
            label: qsTr("Start:"); from: 0; to: 255
            onValueChanged: distributeA()
        }
    }

    RowLayout {
        Layout.leftMargin: 45

        Com.InputInt {
            id: stepR
            label: qsTr("Step:"); from: 0; to: 255
            onValueChanged: distributeR()
        }
        Com.InputInt {
            id: stepG
            label: qsTr("Step:"); from: 0; to: 255
            onValueChanged: distributeG()
        }
        Com.InputInt {
            id: stepB
            label: qsTr("Step:"); from: 0; to: 255
            onValueChanged: distributeB()
        }
        Com.InputInt {
            id: stepA
            label: qsTr("Step:"); from: 0; to: 255
            onValueChanged: distributeA()
        }
    }
}