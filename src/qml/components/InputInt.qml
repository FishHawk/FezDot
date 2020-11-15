import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.4

import "." as Com

RowLayout {
    id: control

    property string label: "label:"
    property int value: from
    property int from: 0
    property int to: 100

    Label { text: label }
    Slider {
        Layout.fillWidth:true;
        value: control.value
        from: control.from
        to: control.to
        onMoved: control.value = Math.round(value)
    }
    TextField {
        Layout.preferredWidth: 45
        text: control.value
        validator: IntValidator { bottom: control.from; top: control.to }
        onAccepted: control.value = parseInt(text)
    }
    Item { Layout.fillWidth: true }
}