import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow
{
    id: mainWindow
    property string fileName
    property bool unsavedChanges

    initialPage: Component {
        EditPage {
            id: editPage
            Component.onCompleted: {
                // if a file was given from command line, auto-open it
                var args = Qt.application.arguments
                if (args.length > 1) {
                    editPage.openFileWithPath(args[1])
                }
            }
        }
    }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
}
