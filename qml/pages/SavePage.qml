import QtQuick 2.0
import Sailfish.Silica 1.0
import finpad 1.0

Dialog {
    id: page
    allowedOrientations: defaultAllowedOrientations

    property var editor

    FileModel {
        id: fileModel
    }

    canAccept: filename.text.length > 0

    onAccepted: {
        editor.saveFileWithPath(fileModel.filePath(filename.text))
    }

    SilicaListView {
        id: view
        model: fileModel
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: filename.top

        header: PageHeader {
            title: qsTr("Save file")
        }

        delegate: BackgroundItem {
            id: delegate
            width: parent.width

            Column {
                width: parent.width

                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.paddingLarge
                    text: name + (isDir ? "/" : "")
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                Label {
                    visible: !isDir
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.paddingLarge
                    text: size + ", " + time
                    color: Theme.secondaryColor
                }
            }

            onClicked: {
                if (isDir) {
                    fileModel.cd(name)
                } else {
                    filename.text = name
                }
            }
        }
        VerticalScrollDecorator { flickable: view }
    }

    TextField {
        id: filename
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        placeholderText: qsTr("File name")
        inputMethodHints: Qt.ImhNoAutoUppercase

        EnterKey.enabled: text.length > 0
        EnterKey.iconSource: "image://theme/icon-m-enter-accept"
        EnterKey.onClicked: accept()
    }
}
