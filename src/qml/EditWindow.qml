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

    DialogNewTheme { id: newThemeDialog; visible: false; }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent

        RowLayout {
            Layout.margins: 20
            spacing: 40

            ColumnLayout {
                Label { text: qsTr("Choose Theme:") }
                ComboBox { Layout.fillWidth: true; model: Backend.themes }
                RowLayout{
                    Button { text: "Save"; onClicked: Backend.dot.saveChange() }
                    Button { text: "New"; onClicked: newThemeDialog.open() }
                    Button { text: "Delete" }
                }
            }

            ColumnLayout {
                RowLayout {
                    Label { text: qsTr("Rotate Plane:") }
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
            id: bar
            Layout.fillWidth: true
            Repeater {
                model: [qsTr("RGB Mode"), qsTr("HSL Mode"), qsTr("Easy Mode")]
                TabButton { text: modelData; width: bar.width / model.length }
            }
        }

        SwipeView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            clip: true
            currentIndex: bar.currentIndex
            interactive: false

            ColorPickerRGB {}
            ColorPickerHSL {}
            ColorPickerEasy {}
        }
    }
}