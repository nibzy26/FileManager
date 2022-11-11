import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3

Dialog {
    id: dialog
    modal: true
    property string fileName: ""
    property var archives

    Row {
        id: row
        width: parent.width
        spacing: units.gu(2)

        ActivityIndicator {
            id: loadingSpinner
            running: true
            anchors.verticalCenter: parent.verticalCenter
        }

        Label {
            text: i18n.tr("Extracting archive '%1'").arg(fileName)
            color: theme.palette.normal.backgroundSecondaryText
            anchors.verticalCenter: parent.verticalCenter
            width: row.width - loadingSpinner.width - row.spacing
            maximumLineCount: 2
            wrapMode: Text.WrapAnywhere
            elide: Text.ElideRight
        }
    }

    Button {
        id: okButton
        text: i18n.tr("OK")
        visible: false
        onClicked: {
            PopupUtils.close(dialog)
        }
    }

    Button {
        id: cancelButton
        text: i18n.tr("Cancel")
        visible: true
        onClicked: {
            archives.cancelArchiveExtraction()
        }
    }

    Connections {
        target: archives
        onFinished: {
            if (success) {
                PopupUtils.close(dialog)
            } else {
                row.visible = false
                cancelButton.visible = false
                title = i18n.tr("Extracting failed")
                text = i18n.tr("Extracting the archive '%1' failed.").arg(fileName)
                okButton.visible = true
            }
        }
    }
}
