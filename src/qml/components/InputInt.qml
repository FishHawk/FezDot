import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.4

import "." as Com

RowLayout {
    id: root

    property string label: "label:"
    property int value: from
    property int from: 0
    property int to: 100

    Label {
        text: label
    }
    Slider {
        Layout.fillWidth:true;
        value: root.value
        from: root.from
        to: root.to

        onMoved: root.value = Math.round(value)
    }
    TextField {
        Layout.preferredWidth: 45
        text: root.value
        validator: IntValidator{bottom: root.from; top: root.to;}
        onAccepted: root.value = parseFloat(text)
    }
    Item {
        Layout.fillWidth: true
    }
}