import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {

    // Show the icon and filename
    // TODO: Replace with the contents of the file (use CoverBackground)
    CoverPlaceholder {

        // State whether or not the file has been modified
        // TODO: Remove once autosave has been enabled
        text: (fileName ? fileName : "FinPad") + "\n" + (unsavedChanges ? qsTr("(modified)") : "")
    }

    // CoverAction items must be organized inside a CoverActionList
    CoverActionList {

        // Create a new empty file
        CoverAction {

            iconSource: "image://theme/icon-cover-new"

            onTriggered: {
                // Reference the current page by using the pageStack
                pageStack.currentPage.newFile()
                // Bring the app to the foreground
                mainWindow.activate()
            }
        }
    }
}
