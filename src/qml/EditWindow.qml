import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import "components" as Com

import Backend 1.0

ApplicationWindow {
    title: qsTr("Dot Setting")
    width: mainLayout.implicitWidth
    height: mainLayout.implicitHeight

    minimumHeight: height
    minimumWidth: width

    maximumHeight: height
    maximumWidth: width

    DialogNewTheme {
        id: newThemeDialog
        visible: false
        onAccepted: {
            Backend.saveTheme(newThemeName)
            Backend.theme = newThemeName
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent

        RowLayout {
            Layout.margins: 20
            spacing: 40

            ColumnLayout {
                Label { text: qsTr("Choose Theme:") }
                ComboBox {
                    id: themeSelector
                    Layout.fillWidth: true
                    model: Backend.themes
                    onActivated: {
                        Backend.loadTheme(currentText)
                        Backend.theme = currentText
                        pickerHSL.setColors()
                    }
                    Component.onCompleted: {
                        themeSelector.currentIndex = themeSelector.indexOfValue(Backend.theme)
                    }
                }
                RowLayout{
                    Button { text: qsTr("Save"); onClicked: Backend.saveTheme(themeSelector.currentText) }
                    Button { text: qsTr("Save as"); onClicked: newThemeDialog.open() }
                    Button { text: qsTr("Delete"); onClicked: Backend.deleteTheme(themeSelector.currentText) }
                }
            }

            ColumnLayout {
                Com.InputDouble {
                    label: qsTr("Size:")
                    value: Backend.size
                    from: 20
                    to: 800
                    onValueChanged: Backend.size = value
                }

                RowLayout {
                    Label { text: qsTr("Rotate Plane:") }
                    RadioButton {
                        checked: Backend.dot.plane == Dot.XY
                        text: qsTr("XY")
                        onClicked: Backend.dot.plane = Dot.XY
                    }
                    RadioButton {
                        checked: Backend.dot.plane == Dot.XZ
                        text: qsTr("XZ")
                        onClicked: Backend.dot.plane = Dot.XZ
                    }
                    RadioButton {
                        checked: Backend.dot.plane == Dot.XW
                        text: qsTr("XW")
                        onClicked: Backend.dot.plane = Dot.XW
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

                Com.InputDouble {
                    label: qsTr("Opacity:")
                    value: Backend.dot.opacity
                    from: 0
                    to: 1
                    onValueChanged: Backend.dot.opacity = value
                }
            }
        }

        TabBar {
            id: bar
            Layout.fillWidth: true
            Repeater {
                model: [qsTr("HSL Mode"), qsTr("RGB Mode")]
                TabButton { text: modelData; width: bar.width / model.length }
            }
        }

        SwipeView {
            Layout.preferredWidth: 800
            Layout.fillHeight: true
            Layout.margins: 20
            clip: true
            currentIndex: bar.currentIndex
            interactive: false
            onCurrentIndexChanged: if (currentIndex == 0) pickerHSL.setColors()

            ColorPickerHSL { id: pickerHSL }
            ColorPickerRGB { id: pickerRGB }
        }
    }

    onVisibleChanged: if (visible) pickerHSL.setColors()
}