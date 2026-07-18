import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "components" as UI

// console.log("width:", image.original_width)

Item {
    id: root

    // это нужно для правильной масштабируемости интерфейса. прописывать * root.scaleFactor
    property real scaleFactor: width / 1920

    // фон
    Rectangle {
        anchors.fill: parent
        color: "#000DFF"
    }

    // видимая область drag & drop
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        width: 1600 * root.scaleFactor; height: 667 * root.scaleFactor

        color: "black"
    }

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        // background text
        Text {
            text: "DRAG & DROP HERE"

            renderType: Text.NativeRendering

            // это нужно прописать чтобы центрирование работало
            width: parent.width
            height: parent.height

            color: "#000DFF"

            font.pixelSize: 150 * root.scaleFactor
            font.family: "Inter"
            font.weight: Font.Black

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }



    Popup {
        id: popup

        width: 1600 * root.scaleFactor; height: 667 * root.scaleFactor

        modal: true
        focus: true

        anchors.centerIn: parent

        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        property url imageUrl

        function show(url) {
            imageUrl = url
            open()
        }

        background: Rectangle {
            color: "black"
        }

        ColumnLayout {
            anchors.centerIn: parent

            spacing: 10

            // кнопка RESIZE
            UI.NyafButton {
                text: "RESIZE"
                scaleFactor: root.scaleFactor
                Layout.alignment: Qt.AlignCenter

                hoverColor: "white"
                baseColor: "black"
                borderColor: "white"

                textGlow: 1
                onClicked: setView.set_new_view("resize.qml", popup.imageUrl)
            }

            // кнопка CROP
            UI.NyafButton {
                text: "CROP"
                scaleFactor: root.scaleFactor
                Layout.alignment: Qt.AlignCenter

                hoverColor: "white"
                baseColor: "black"
                borderColor: "white"

                textGlow: 1
                onClicked: setView.set_new_view("crop.qml", popup.imageUrl)
            }

            // кнопка STEAM
            UI.NyafButton {
                text: "STEAM"
                scaleFactor: root.scaleFactor
                Layout.alignment: Qt.AlignCenter

                hoverColor: "white"
                baseColor: "black"
                borderColor: "white"

                textGlow: 1
                onClicked: setView.set_new_view("SteamWorkshopShowcase.qml", popup.imageUrl)
            }
        }
    }



    FileDialog {
        id: fileDialog

        title: "Select image"
        nameFilters: ["Images (*.png *.jpg *.jpeg *.webp)"]
        fileMode: FileDialog.OpenFile   // только один файл

        onAccepted: {
            popup.show(selectedFile)
        }
    }

    // кнопка на весь экран чтобы по клику можно было выбрать файл
    UI.NyafButton {
        text: "RESIZE"
        scaleFactor: root.scaleFactor

        hoverColor: "transparent"
        baseColor: "transparent"
        borderColor: "transparent"

        changable_width: parent.width
        changable_height: parent.height

        buttonGlow: 0
        textGlow: 0

        onClicked: fileDialog.open()
    }

    // поле куда нужно кидать фото
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        width: 1600 * root.scaleFactor; height: 667 * root.scaleFactor

        color: "transparent"

        DropArea {
            anchors.fill: parent

            onDropped: function(drop) {
                if (drop.urls.length > 0) {
                    popup.show(drop.urls[0])
                }
            }
        }
    }
}