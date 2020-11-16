import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import QtGraphicalEffects 1.0

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

    onClosing: settings.saveAllSettings()

    DialogNewTheme {
        id: newThemeDialog
        visible: false
        onAccepted: {
            Backend.saveTheme(newThemeName)
            settings.selectedTheme = newThemeName
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
                        settings.selectedTheme = currentText
                        pickerHSLA.setColors()
                    }
                    Connections {
                        target: settings
                        function onSelectedThemeChanged() {
                            themeSelector.currentIndex = themeSelector.indexOfValue(settings.selectedTheme)
                        }
                    }
                }
                RowLayout{
                    Button { text: "Save"; onClicked: Backend.saveTheme(themeSelector.currentText) }
                    Button { text: "Save as"; onClicked: newThemeDialog.open() }
                    Button { text: "Delete"; onClicked: Backend.deleteTheme(themeSelector.currentText) }
                }
            }

            ColumnLayout {
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
            }
        }

        TabBar {
            id: bar
            Layout.fillWidth: true
            Repeater {
                model: [qsTr("HSLA Mode"), qsTr("RGBA Mode")]
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
            onCurrentIndexChanged: if (currentIndex == 0) pickerHSLA.setColors()

            ColorPickerHSLA { id: pickerHSLA }
            ColorPickerRGBA { id: pickerRGBA }
        }
    }

    onVisibleChanged: if (visible) pickerHSLA.setColors()
}