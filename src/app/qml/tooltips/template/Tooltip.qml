import QtQuick 2.4
import Lomiri.Components 1.3

Item {
    id: rootItem
    anchors { left: parent.left; right: parent.right }
    height: visible ? units.gu(4) : 0
    enabled: visible
}
