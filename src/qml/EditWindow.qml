import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import QtGraphicalEffects 1.0

import "components" as Com

import Backend 1.0

ApplicationWindow {
    title: qsTr("Dot Setting")
    width: mainLayout.implicitWidth + 22
    height: mainLayout.implicitHeight + 22

    minimumHeight: height
    minimumWidth: width

    maximumHeight: height
    maximumWidth: width

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: 11

        RowLayout {
            spacing: 40
            ColumnLayout {
                Label { text: qsTr("Choose Theme:") }
                ComboBox {
                    Layout.fillWidth: true
                    model: Backend.themes
                }
                RowLayout{
                    Button { text:"Save"; onClicked: Backend.dot.saveChange() }
                    Button { text:"Save As" }
                    Button { text:"Cancel" }
                }
            }
            ColumnLayout {
                RowLayout {
                    Label {
                        text: qsTr("Rotate Plane:")
                    }
                    RadioButton {
                        checked: Backend.dot.plane == Backend.dot.XY
                        text: qsTr("XY")
                        onClicked: Backend.dot.plane = Backend.dot.XY
                    }
                    RadioButton {
                        checked: Backend.dot.plane == Backend.dot.XZ
                        text: qsTr("XZ")
                        onClicked: Backend.dot.plane = Backend.dot.XZ
                    }
                    RadioButton {
                        checked: Backend.dot.plane == Backend.dot.XW
                        text: qsTr("XW")
                        onClicked: Backend.dot.plane = Backend.dot.XW
                    }
                }
                Com.InputDouble {
                    label: qsTr("Rotate Velocity (angle1):")
                    value: Backend.dot.velocity1
                    from: -1.0
                    to: 1.0
                    onValueChanged: Backend.dot.velocity1 = value
                }
                Com.InputDouble {
                    label: qsTr("Rotate Velocity (angle2):")
                    value: Backend.dot.velocity2
                    from: -1.0
                    to: 1.0
                    onValueChanged: Backend.dot.velocity2 = value
                }
            }
        }

        TabBar {
            Layout.fillWidth: true
            id: bar
            Repeater {
                model: [qsTr("RGB Mode"), qsTr("HSL Mode"), qsTr("Special Mode")]
                TabButton { text: modelData; width: bar.width / model.length }
            }
        }

        StackLayout {
            Layout.fillWidth: true
            currentIndex: bar.currentIndex
            ColorPickerRGB {}
            ColorPickerHSL {}
            ColorPickerSepcial {}
        }
    }
}