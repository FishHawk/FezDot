import QtQuick 2.12
import QtQuick.Layouts 1.12

import "components" as Com

import Backend 1.0

ColumnLayout {

    function setColors() {
        for (let i = 0; i < 8; i++) {
            colors.itemAt(i).value = Backend.dot.colors[i]
        }
    }

    function distributeH() {
        for (let i = 0; i < 8; i++) {
            let valueH = startH.value + stepH.value * i
            colors.itemAt(i).value.hslHue = (valueH % 360) / 360
        }
    }

    function distributeS() {
        for (let i = 0; i < 8; i++) {
            let valueS = startS.value + stepS.value * i
            colors.itemAt(i).value.hslSaturation = (valueS % 101) / 100
        }
    }

    function distributeL() {
        for (let i = 0; i < 8; i++) {
            let valueL = startL.value + stepL.value * i
            colors.itemAt(i).value.hslLightness = (valueL % 101) / 100
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
        Com.InputColorHSLA {
            value: Backend.dot.colors[index]
            onValueChanged: Backend.dot.setColors(index, value)
        }
    }

    RowLayout {
        Layout.leftMargin: 45

        Com.InputInt {
            id: startH
            label: "Start:"; from: 0; to: 360
            onValueChanged: distributeH()
        }
        Com.InputInt {
            id: startS
            label: "Start:"; from: 0; to: 100
            onValueChanged: distributeS()
        }
        Com.InputInt {
            id: startL
            label: "Start:"; from: 0; to: 100
            onValueChanged: distributeL()
        }
        Com.InputInt {
            id: startA
            label: "Start:"; from: 0; to: 255
            onValueChanged: distributeA()
        }
    }

    RowLayout {
        Layout.leftMargin: 45

        Com.InputInt {
            id: stepH
            label: "Step:"; from: 0; to: 360
            onValueChanged: distributeH()
        }
        Com.InputInt {
            id: stepS
            label: "Step:"; from: 0; to: 100
            onValueChanged: distributeS()
        }
        Com.InputInt {
            id: stepL
            label: "Step:"; from: 0; to: 100
            onValueChanged: distributeL()
        }
        Com.InputInt {
            id: stepA
            label: "Step:"; from: 0; to: 255
            onValueChanged: distributeA()
        }
    }
}