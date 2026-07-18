import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    visible: true
    width: 1900
    height: 990

    title: "Nyafumi"

    property real scaleFactor: width / 1920

    Loader {
        id: viewLoader
        objectName: "viewLoader"

        anchors.fill: parent
        source: "dragndrop.qml"
    }
}