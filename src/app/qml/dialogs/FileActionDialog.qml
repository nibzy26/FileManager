/*
 * Copyright (C) 2013 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Arto Jalkanen <ajalkane@gmail.com>
 */
import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import org.nemomobile.folderlistmodel 1.0

Dialog {
    id: root

    property string fileName
    property string filePath
    property FolderListModel folderListModel

    title: i18n.tr("Choose action")
    text: i18n.tr("For file: %1").arg(fileName)

    Button {
        objectName: "openButton"
        color: theme.palette.normal.focus
        text: i18n.tr("Open")
        onClicked: {
            console.log("Opening file", filePath)
            openLocalFile(model.filePath)
            onClicked: PopupUtils.close(root)
        }
    }

    Button {
        objectName: "cancelButton"
        text: i18n.tr("Cancel")
        onClicked: PopupUtils.close(root)
    }
}
