import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

GroupBox {
    id: control
    title: qsTr("GroupBox")
    topPadding: label.height + padding

    label: Rectangle {
        width: parent.width
        height: 40
        color: "white"
        RowLayout {
            anchors.fill: parent
            Layout.alignment: Qt.AlignVCenter
            spacing: 20
            Rectangle {
                Layout.leftMargin: control.leftPadding
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                radius: 4
                color: "#8BC34A"
            }
            Text {
                text: control.title
                font.bold: true
                font.pointSize: 15
                color: "black"
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            Item {
                Layout.fillWidth: true
            }
        }

        Rectangle {
            x: 0
            y: parent.height - 1
            width: parent.width
            height: 1
            color: "#8BC34A"
        }
    }

    background: Rectangle {
        y: control.topPadding - control.bottomPadding
        width: parent.width
        height: parent.height - control.topPadding + control.bottomPadding
    }
    // ColumnLayout {
    //     Rectangle {
    //         Layout.preferredWidth: 200
    //         Layout.preferredHeight: 200
    //         color: "white"
    //     }
    // }
}