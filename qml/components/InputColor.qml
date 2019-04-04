import QtQuick 2.12
import QtQuick.Layouts 1.12

import "." as Com

RowLayout {
    id: control

    enum ColorMode { RGB, RGBA, HSL, HSLA }

    property string label: "label:"
    property color value: "black"
    property int mode: InputColor.HSL
    
    
    function setColor(color_in) {
        inputR.value = color_in.r * 255
        inputG.value = color_in.g * 255
        inputB.value = color_in.b * 255

        inputH.value = color_in.hslHue * 360
        inputS.value = color_in.hslSaturation * 100
        inputL.value = color_in.hslLightness * 100

        inputA.value = color_in.a*255
    }

    ColumnLayout {
        Text {
            Layout.topMargin: 5
            text: label
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
            Rectangle {color: control.value; width: 40; height: 40; border.width: 1 }
        }
        Item { Layout.fillHeight: true }
    }
    ColumnLayout {
        spacing: 0
        Com.InputInt {
            id: inputR
            label: "R:"; from: 0; to: 255;
            onValueChanged: control.value.r = value / 255
        }
        Com.InputInt {
            id: inputG
            label: "G:"; from: 0; to: 255;
            onValueChanged: control.value.g = value / 255
        }
        Com.InputInt {
            id: inputB
            label: "B:"; from: 0; to: 255;
            onValueChanged: control.value.b = value / 255
        }
        Com.InputInt {
            id: inputH
            label: "H:"; from: 0; to: 360;
            onValueChanged: control.value.hslHue = value / 360
        }
        Com.InputInt {
            id: inputS
            label: "S:"; from: 0; to: 100;
            onValueChanged: control.value.hslSaturation = value / 100
        }
        Com.InputInt {
            id: inputL
            label: "L:"; from: 0; to: 100;
            onValueChanged: control.value.hslLightness = value / 100
        }
        Com.InputInt {
            id: inputA
            label: "A:"; from: 0; to: 255;
            onValueChanged: control.value.a = value / 255
        }
    }

    states: [
        State {
            name: "RGB"; when: mode == InputColor.RGB;
            PropertyChanges { target: inputR; visible: true }
            PropertyChanges { target: inputG; visible: true }
            PropertyChanges { target: inputB; visible: true }
            PropertyChanges { target: inputH; visible: false }
            PropertyChanges { target: inputS; visible: false }
            PropertyChanges { target: inputL; visible: false }
            PropertyChanges { target: inputA; visible: false }
        },
        State {
            name: "RGBA"; when: mode == InputColor.RGBA;
            PropertyChanges { target: inputR; visible: true }
            PropertyChanges { target: inputG; visible: true }
            PropertyChanges { target: inputB; visible: true }
            PropertyChanges { target: inputH; visible: false }
            PropertyChanges { target: inputS; visible: false }
            PropertyChanges { target: inputL; visible: false }
            PropertyChanges { target: inputA; visible: true }
        },
        State {
            name: "HSL"; when: mode == InputColor.HSL;
            PropertyChanges { target: inputR; visible: false }
            PropertyChanges { target: inputG; visible: false }
            PropertyChanges { target: inputB; visible: false }
            PropertyChanges { target: inputH; visible: true }
            PropertyChanges { target: inputS; visible: true }
            PropertyChanges { target: inputL; visible: true }
            PropertyChanges { target: inputA; visible: false }
        },
        State {
            name: "HSLA"; when: mode == InputColor.HSLA;
            PropertyChanges { target: inputR; visible: false }
            PropertyChanges { target: inputG; visible: false }
            PropertyChanges { target: inputB; visible: false }
            PropertyChanges { target: inputH; visible: true }
            PropertyChanges { target: inputS; visible: true }
            PropertyChanges { target: inputL; visible: true }
            PropertyChanges { target: inputA; visible: true }
        }
    ]


}