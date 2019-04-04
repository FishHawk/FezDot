import QtQuick 2.12
import QtQuick.Layouts 1.12

import "." as Com

RowLayout {
    id: control

    property string label: "label:"
    property double value: from
    property double from: 0.0
    property double to: 1.0

    Text {
        text: label
        // MouseArea {
        //     anchors.fill: parent
        //     onClicked: {
        //         console.log(control.value)
        //         control.value = 0.5
        //     }
        // }
    }
    Com.Slider {
        value: control.value
        from: control.from
        to: control.to
        stepSize: Math.abs(to - from) / 100

        onMoved: control.value = value
    }
    TextInput {
        Layout.preferredWidth: 30
        text: control.value.toPrecision(3)
        validator: DoubleValidator{bottom: control.from; top: control.to;}
        onAccepted: control.value = parseFloat(text)
    }
}