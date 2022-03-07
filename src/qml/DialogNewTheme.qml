import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Backend 1.0

Dialog {
    property string newThemeName: newThemeNameInput.text

    anchors.centerIn: parent

    title: qsTr("Input new theme name")
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel

    RowLayout {
        spacing: 40
        Label { text: qsTr("Name:") }
        TextField { id: newThemeNameInput; text: qsTr("New Theme") }
    }
}