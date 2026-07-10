import QtQuick 6.5

Item {
    id: cropRoot

    signal dragFinished()

    property real scaleFactor: 1.0
    property real changable_width: 1 * scaleFactor
    property real changable_height: 1 * scaleFactor

    width: changable_width
    height: changable_height

    Rectangle {
        id: root

        anchors.fill: parent

        color: "transparent"

        border.width: 3 * scaleFactor
        border.color: "#000DFF"
    }

    MouseArea {
        anchors.fill: parent
        drag.target: cropRoot

        onReleased: {
            cropRoot.dragFinished()
        }
    }
}