import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: control
    text: qsTr("Button")

    contentItem: Text {
        text: control.text
        font.bold: true
        font.pointSize: 13
        
        opacity: enabled ? 1.0 : 0.3
        color: control.down ?  Qt.darker("#8BC34A") : "#8BC34A"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        border.color: "lightgrey"
        border.width: 1
        radius: 6
    }
}