import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import QtGraphicalEffects 1.0

import "components" as Com

import Backend 1.0

ApplicationWindow {
    property int margin: 11

    visible: true
    title: qsTr("Dot Setting")
    width: mainLayout.implicitWidth + 2 * margin
    height: mainLayout.implicitHeight + 2 * margin

    maximumHeight: height
    maximumWidth: width

    minimumHeight: height
    minimumWidth: width

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: margin
        
        RowLayout {
            ColumnLayout {
                DotView {
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 300
                    Binding { target: Dot; property: "height"; value: height; delayed: false}
                    Binding { target: Dot; property: "width"; value: width; delayed: false }
                }
            }

            ColumnLayout {
                Layout.minimumWidth: 410

                RowLayout {
                    Button {
                        text:"Save Change"
                        onClicked: {
                            Dot.saveChange()
                        }
                    }
                }
                
                RowLayout {
                    Label {
                        text: qsTr("Rotate Plane:")
                    }
                    RadioButton {
                        checked: Dot.plane == Dot.XY
                        text: qsTr("XY")
                        onClicked: Dot.plane = Dot.XY
                    }
                    RadioButton {
                        checked: Dot.plane == Dot.XZ
                        text: qsTr("XZ")
                        onClicked: Dot.plane = Dot.XZ
                    }
                    RadioButton {
                        checked: Dot.plane == Dot.XW
                        text: qsTr("XW")
                        onClicked: Dot.plane = Dot.XW
                    }
                }
                Com.InputDouble {
                    label: "Rotate Velocity (angle1):"
                    value: Dot.velocity1
                    from: -1.0
                    to: 1.0
                    onValueChanged: Dot.velocity1 = value
                }
                Com.InputDouble {
                    label: "Rotate Velocity (angle2):"
                    value: Dot.velocity2
                    from: -1.0
                    to: 1.0
                    onValueChanged: Dot.velocity2 = value
                }
            }
        }

        TabBar {
            id: bar
            width: parent.width
            TabButton { text: qsTr("RGB Mode") }
            TabButton { text: qsTr("HSL Mode") }
            TabButton { text: qsTr("Special Mode") }
        }

        StackLayout {
            width: parent.width
            currentIndex: bar.currentIndex
            ColorPickerRGB {}
            ColorPickerHSL {}
            ColorPickerSepcial {}
        }
    }
}