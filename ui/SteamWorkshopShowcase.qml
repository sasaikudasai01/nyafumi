import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components" as UI

Item {
    id: root

    // это нужно для правильной масштабируемости интерфейса. прописывать * root.scaleFactor
    property real scaleFactor: width / 1920

    Rectangle {
        anchors.fill: parent
        color: "#000333"
    }

    // background BIG text
    Text {
        text: "CROP"

        renderType: Text.NativeRendering

        // это нужно прописать чтобы центрирование работало
        height: parent.height

        color: "black"

        font.pixelSize: 1200 * root.scaleFactor
        font.family: "Inter"
        font.weight: Font.Black

        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        anchors.verticalCenter: parent.verticalCenter
        leftPadding: -55 * root.scaleFactor // без этого расстояние между текстом и левым краем больше
    }

    ColumnLayout {
        anchors.centerIn: parent

        spacing: 10 * root.scaleFactor

        width: 480 * root.scaleFactor
        height: 939 * root.scaleFactor

        Item {
            id: imageContainer

            // steam workshop showcase max size
            height: parent.height - 75 * scaleFactor // отнимается высота кнопок
            width: parent.width

            // редактируемая картинка
            Image {
                id: picture
                source: image.image
                
                anchors.fill: imageContainer

                // плавная подгрузка и сглаживание
                smooth: true
                asynchronous: true
            }

            Rectangle {
                border.width: 3 * scaleFactor

                width: parent.width
                height: 5 * scaleFactor

                color: "transparent"
                border.color: "#000DFF"

                anchors.centerIn: parent
            }

            Layout.preferredWidth: width
            Layout.preferredHeight: height
        }
        

        // row кнопок
        RowLayout {
            Layout.fillWidth: true

            spacing: 10 * scaleFactor
            
            // кнопка CROP
            UI.NyafButton {
                text: "CROP"

                scaleFactor: root.scaleFactor

                hoverColor: "black"
                baseColor: "#000DFF"
                glowColor: "#AB000DFF"
                borderColor: "#000DFF"

                buttonGlow: 1

                onClicked: uiStateCrop.crop_steam()
            }

            //Item { Layout.fillWidth: true } // заполнить пустым пространством

            // кнопка cancel
            UI.NyafButton {
                text: "CANCEL"

                scaleFactor: root.scaleFactor

                buttonGlow: 1

                onClicked: setView.set_new_view("dragndrop.qml", "")
            }
        }
    }
}