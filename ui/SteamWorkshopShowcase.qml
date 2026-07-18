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

        Item {
            id: imageContainer

            // вписать картинку в 1500х700
            width: if (image.height / (image.width / 1500) <= 700 * root.scaleFactor) {
                return 1500 * root.scaleFactor
            } else { return image.width / (image.height / (700 * root.scaleFactor))}
            height: image.height / (image.width / width)

            // редактируемая картинка
            Image {
                id: picture
                source: image.image
                
                anchors.fill: imageContainer

                // плавная подгрузка и сглаживание
                smooth: true
                asynchronous: true
            }

            // вертикальные 4
            Repeater {
                model: 4
                Rectangle {
                    width: 5 * scaleFactor
                    height: parent.height
                    border.width: 3 * scaleFactor
                    
                    x: (index + 1) * parent.width / 5

                    color: "#000333"
                    border.color: "#000333"

                    Layout.alignment: Qt.AlignCenter
                }
            }

            // горизонтальные 2
            Repeater {
                model: uiStateCrop.rows - 1
                Rectangle {
                    width: parent.width
                    height: 5 * scaleFactor
                    border.width: 3 * scaleFactor
                    
                    y: (index + 1) * parent.height / uiStateCrop.rows

                    color: "#000333"
                    border.color: "#000333"

                    Layout.alignment: Qt.AlignCenter
                }
            }

            Layout.preferredWidth: width
            Layout.preferredHeight: height
            Layout.alignment: Qt.AlignCenter
        }
        


        // rows input
        RowLayout {

            Layout.fillWidth: true
            spacing: 0

            Text {
                id: rowsTitle
                text: "ROWS"
                color: "white"

                font.pixelSize: 48 * root.scaleFactor
                font.family: "Inter"
                font.weight: Font.Black

                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true } // заполнить пустым пространством

            // TextField для ввода количества rows
            TextField {
                id: rowsInput
                text: uiStateCrop.rows
                color: "white"

                onTextEdited: uiStateCrop.rows = text

                font.pixelSize: 48 * root.scaleFactor
                font.family: "Inter"
                font.weight: Font.Black

                background: null

                validator: IntValidator { bottom: 1; top: 3 } // ограничить числами от 1 до 3
            }
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
            
            Item { Layout.fillWidth: true } // заполнить пустым пространством

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