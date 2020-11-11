import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Dialog {
    property string baseThemeName: "default"
    property string newThemeName: newThemeNameInput.text

    anchors.centerIn: parent

    title: qsTr("Input new theme name")
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel

    onAccepted: console.log("Ok clicked")
    RowLayout {
        spacing: 40
        Label { text: qsTr("Name:") }
        TextField { id: newThemeNameInput; text: "new theme" }
    }
}