import QtQuick 2.12
import QtQuick.Layouts 1.12

import "components" as Com

import Backend 1.0

ColumnLayout {
    property variant colors: [Dot.colors(0), Dot.colors(1), Dot.colors(2), Dot.colors(3), 
                                Dot.colors(4), Dot.colors(5), Dot.colors(6), Dot.colors(7)]

    
    function notifyColorsChange() {
        var tmp =  colors;
        colors = tmp;
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.alignment : Qt.AlignHCenter
        spacing: 15
        
        Repeater {
            model: 8
            Rectangle {
                width: 40
                height: 40
                Grid {
                    rows: 2
                    columns: 2
                    spacing: 0
                    Rectangle { color: "lightgray"; width: 20; height: 20 }
                    Rectangle { color: "grey"; width: 20; height: 20 }
                    Rectangle { color: "grey"; width: 20; height: 20 }
                    Rectangle { color: "lightgray"; width: 20; height: 20 }
                }
                Rectangle {color: colors[index]; width: 40; height: 40; border.width: 1 }
            }
        }
    }

    GridLayout {
        columnSpacing: 10
        rowSpacing: 15
        columns: 2

        Com.InputDouble {
            id: hueStart
            label: "HueStart"
            onValueChanged: {
                for (var i = 0; i < 8; i++) {                   
                     var hue = hueStart.value + hueStep.value * i
                    colors[i].hslHue = (hue - Math.floor(hue))
                    Dot.setColors(i, colors[i])
                }
                notifyColorsChange()
            }
        }

        Com.InputDouble {
            id: hueStep
            label: "HueStep"
            value: 0.125

            onValueChanged: {
                for (var i = 0; i < 8; i++) {
                    var hue = hueStart.value + hueStep.value * i
                    colors[i].hslHue = (hue - Math.floor(hue))
                    Dot.setColors(i, colors[i])
                }
                notifyColorsChange()
            }
        }

        Com.InputDouble {
            id: lightness
            label: "Lightness"
            from: 0; to: 0.4

            onValueChanged: {
                for (var i = 0; i < 8; i++) {
                    colors[i].hslLightness = lightness.value
                    Dot.setColors(i, colors[i])
                }
                notifyColorsChange()
            }

            Component.onCompleted: {
                value = Dot.colors(0).hslLightness
            }
        }

        Com.InputDouble {
            id: saturation
            label: "Saturation"

            onValueChanged: {
                for (var i = 0; i < 8; i++) {
                    colors[i].hslSaturation = saturation.value
                    Dot.setColors(i, colors[i])
                }
                notifyColorsChange()
            }

            Component.onCompleted: {
                value = Dot.colors(0).hslSaturation
            }
        }

        Com.InputDouble {
            id: alpha
            label: "Alpha"

            onValueChanged: {
                for (var i = 0; i < 8; i++) {
                    colors[i].a = alpha.value
                    Dot.setColors(i, colors[i])
                }
                notifyColorsChange()
            }

            Component.onCompleted: {
                value = Dot.colors(0).a
            }
        }
    }
}

