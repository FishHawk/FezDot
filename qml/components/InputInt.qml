import QtQuick 2.12
import QtQuick.Layouts 1.12

import "." as Com

RowLayout {
    id: root

    property string label: "label:"
    property int value: from
    property int from: 0
    property int to: 100

    Text {
        text: label
    }
    Com.Slider {

        value: root.value
        from: root.from
        to: root.to
        stepSize: Math.abs(to - from) / 100

        onMoved: root.value = Math.round(value)
    }
    TextInput {
        Layout.minimumWidth: 30
        text: root.value
        validator: IntValidator{bottom: root.from; top: root.to;}
        onAccepted: root.value = parseFloat(text)
    }
    Item {
        Layout.fillWidth: true
    }
}