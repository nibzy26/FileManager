import QtQuick 2.4
import Lomiri.Components 1.3

Action {
    iconName: !showSearchBar ? "find" : "edit-clear"
    text: i18n.tr("Search")
}
