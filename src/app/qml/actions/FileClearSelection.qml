import QtQuick 2.4
import Ubuntu.Components 1.3

Action {
    property int clipboardUrlsCounter

    iconName: "edit-clear"
    property bool showText: false
    text: i18n.tr("Clear clipboard")
    visible: clipboardUrlsCounter > 0
}
