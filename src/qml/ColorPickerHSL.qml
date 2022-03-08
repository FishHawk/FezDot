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
            colors.itemAt(i).value.hslLightness = (startL.value % 101) / 100
        }
    }

    Repeater {
        id: colors
        model: 8
        Com.InputColorHSL {
            value: Backend.dot.colors[index]
            onValueChanged: Backend.dot.setColors(index, value)
        }
    }

    RowLayout {
        Layout.leftMargin: 45

        ColumnLayout {
            Com.InputInt {
                id: startH
                label: qsTr("Start:"); from: 0; to: 360
                onValueChanged: distributeH()
                Component.onCompleted: value = Backend.dot.colors[0].hslHue * 360
            }
            Com.InputInt {
                id: stepH
                label: qsTr("Step:"); from: 0; to: 360
                onValueChanged: distributeH()
                Layout.preferredWidth: 1
            }
        }

        ColumnLayout {
            Com.InputInt {
                id: startS
                label: qsTr("Start:"); from: 0; to: 100
                onValueChanged: distributeS()
                Component.onCompleted: value = Backend.dot.colors[0].hslSaturation * 100
            }
            Com.InputInt {
                id: stepS
                label: qsTr("Step:"); from: 0; to: 100
                onValueChanged: distributeS()
            }
        }

        Com.InputInt {
            id: startL
            label: qsTr("Start:"); from: 0; to: 40
            onValueChanged: distributeL()
            Component.onCompleted: value = Backend.dot.colors[0].hslLightness * 100
        }
    }
}