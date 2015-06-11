import QtQuick 2.0
import Sailfish.Silica 1.0
import finpad 1.0

Page {
    id: page
    allowedOrientations: defaultAllowedOrientations

    property var editor

    FileModel {
        id: fileModel
    }

    SilicaListView {
        id: view
        model: fileModel
        anchors.fill: parent

        header: PageHeader {
            title: qsTr("Open file")
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
                    editor.openFileWithPath(path)
                    pageStack.pop()
                }
            }
        }
        VerticalScrollDecorator { flickable: view }
    }
}
