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
    minimumWidth: mainLayout.Layout.minimumWidth + 2 * margin
    minimumHeight: mainLayout.Layout.minimumHeight + 2 * margin

    maximumWidth: minimumWidth
    maximumHeight: minimumHeight
    color: "#EBEBEB"

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: margin
        
        RowLayout {
            Com.GroupBox {
                title: "Dot"
                ColumnLayout {
                    DotView {
                        Layout.preferredWidth: 220
                        Layout.preferredHeight: 220
                        Binding { target: Dot; property: "height"; value: height; delayed: false}
                        Binding { target: Dot; property: "width"; value: width; delayed: false }
                    }
                }
            }
            ColumnLayout {
                Layout.minimumWidth: 410

                Com.GroupBox {
                    Layout.fillWidth: true
                    
                    title: "Control"
                    RowLayout {
                        Com.ButtonOutlined {
                            text:"Change Color Mode"
                            onClicked: {
                                if (colorPicker.source == "qrc:/ColorPickerRGB.qml") {
                                    colorPicker.source = "ColorPickerHSL.qml"
                                }
                                else if (colorPicker.source == "qrc:/ColorPickerHSL.qml") {
                                    colorPicker.source = "ColorPickerSepcial.qml"
                                }
                                else {
                                    colorPicker.source = "ColorPickerRGB.qml"
                                }
                            }

                        }
                        Com.Button {
                            text:"Save Change"
                            onClicked: {
                                Dot.saveChange()
                            }
                        }
                    }
                }
                Com.GroupBox {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    title: "Rotate"
                    ColumnLayout {
                        RowLayout {
                            Text {
                                text: qsTr("Rotate Plane:")
                            }
                            Com.RadioButton {
                                checked: Dot.plane == Dot.XY
                                text: qsTr("XY")
                                onClicked: Dot.plane = Dot.XY
                            }
                            Com.RadioButton {
                                checked: Dot.plane == Dot.XZ
                                text: qsTr("XZ")
                                onClicked: Dot.plane = Dot.XZ
                            }
                            Com.RadioButton {
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
            }
        }

        Com.GroupBox {
            title: "Color"
            Layout.fillWidth: true
            ColumnLayout {
                Loader {
                    id: colorPicker
                    source: "qrc:/ColorPickerRGB.qml"
                    focus: true
                }
            }
        }    
    }
}