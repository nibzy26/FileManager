import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3

Dialog {
    id: dialog
    modal: true
    title: i18n.tr("Archive file")
    text: i18n.tr("Do you want to extract the archive here?")
    property string filePath
    property string fileName
    property string archiveType
    property var folderListPage
    property var folderModel

    Button {
        id: extractButton
        text: i18n.tr("Extract archive")
        color: theme.palette.normal.positive
        onClicked: {
            PopupUtils.close(dialog)
            folderModel.extractArchive(filePath, fileName, archiveType)
        }
    }

    Button {
        id: openExternallyButton
        text: i18n.tr("Open with another app")
        onClicked: {
            PopupUtils.close(dialog)
            openLocalFile(filePath)
        }
    }

    Button {
        id: cancelButton
        text: i18n.tr("Cancel")
        onClicked: {
            PopupUtils.close(dialog)
        }
    }
}
