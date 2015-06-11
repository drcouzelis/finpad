import QtQuick 2.0
import Sailfish.Silica 1.0
import finpad 1.0

Page {
    id: page
    allowedOrientations: defaultAllowedOrientations

    TextFile {
        id: file
    }

    SilicaFlickable {
        id: view
        anchors.fill: parent
        contentHeight: area.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Save as")
                onClicked: saveAsPressed()
            }
            /*
            MenuItem {
                text: qsTr("Undo")
                onClicked: undoChanges()
            }
            */
            MenuItem {
                text: qsTr("Open")
                onClicked: openPressed()
            }
            MenuItem {
                text: qsTr("New")
                onClicked: newPressed()
            }
        }

        TextArea {
            id: area

            width: parent.width

            anchors {
                // The top margin won't take effect until the top has been set
                top: parent.top
                topMargin: Theme.paddingLarge
            }

            // If empty, use the default Sailfish font for the placeholder text
            font.family: text == "" ? Theme.fontFamily : "Monospace"
            font.pixelSize: text == "" ? Theme.fontSizeMedium : Theme.fontSizeSmall

            wrapMode: TextEdit.WrapAnywhere
            placeholderText: "Enter text"

            onTextChanged: savePressed()
        }

        Component.onCompleted: {
            if (file.fileName == "") {
                area.focus = true
            } else {
                area.focus = false
            }
        }

        // Attach a decorator to the SilicaFlickable to allow vertical scrolling
        VerticalScrollDecorator { flickable: view }
    }

    DockedPanel {
        id: errorPanel
        width: parent.width
        height: Theme.itemSizeSmall + Theme.paddingSmall
        dock: Dock.Bottom

        Rectangle {
            anchors.fill: parent
            color: Theme.secondaryHighlightColor
            opacity: 0.3
        }

        Label {
            id: errorLabel
            anchors.centerIn: parent
            color: Theme.secondaryColor
        }

        Timer {
            id: errorTimer
            interval: 2000
            onTriggered: errorPanel.hide()
        }

        function showError(msg) {
            errorLabel.text = msg
            errorTimer.start()
            show()
        }
    }

    // For creating a new document
    function newPressed() {
        file.path = ""
        area.text = ""
        area.focus = true
        fileName = ""
        unsavedChanges = false
    }

    function openPressed() {
        pageStack.push("OpenPage.qml", {"editor": page})
    }

    // If a document has a filename then just save it,
    // otherwise save as
    function savePressed() {
        if (file.path == "") {
            file.path = StandardPaths.documents + "/finpad-autosave-" +
                    Qt.formatDateTime(new Date(), "yyyyMMddhhmm") + ".txt"
        }
        writeFile()
    }

    // Attempt to actually save the file, otherwise show an error message
    function writeFile() {
        if (file.save(area.text)) {
            unsavedChanges = false
        } else {
            errorPanel.showError(qsTr("Save failed"))
        }
    }

    function saveAsPressed() {
        pageStack.push("SavePage.qml", {"editor": page})
    }

    // Actually open and load the file
    function openFileWithPath(path) {
        file.path = path
        area.text = file.load()
        fileName = file.fileName
        unsavedChanges = false
    }

    // Save file to the given file
    function saveFileWithPath(path) {
        file.path = path
        fileName = file.fileName
        writeFile()
    }
}
