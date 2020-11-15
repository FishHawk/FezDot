import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.4

import "." as Com

RowLayout {
    id: control

    property string label: "label:"
    property double value: from
    property double from: 0.0
    property double to: 1.0

    Label { text: label }
    Slider {
        Layout.fillWidth:true;
        value: control.value
        from: control.from
        to: control.to
        onMoved: control.value = value
    }
    TextField {
        Layout.preferredWidth: 60
        text: control.value.toPrecision(3)
        validator: DoubleValidator { bottom: control.from; top: control.to }
        onAccepted: control.value = parseFloat(text)
    }
    Item { Layout.fillWidth: true }
}