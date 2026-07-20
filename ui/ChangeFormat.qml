import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
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
        text: "FORMAT"

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

            Layout.preferredWidth: width
            Layout.preferredHeight: height
            Layout.alignment: Qt.AlignCenter
        }
        


        // format input
        RowLayout {

            Layout.fillWidth: true
            spacing: 0

            Text {
                id: formatTitle
                text: "FORMAT"
                color: "white"

                font.pixelSize: 48 * root.scaleFactor
                font.family: "Inter"
                font.weight: Font.Black

                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true } // заполнить пустым пространством

            UI.NyafComboBox {
                id: formatComboBox

                Layout.preferredWidth: 200
                Layout.preferredHeight: 40

                model: [
                    "png",
                    "jpeg",
                    "jpg",
                ]
            }
        }



        FileDialog {
            id: saveDialog

            title: "Save image"

            fileMode: FileDialog.SaveFile

            // чтобы было видно на какое именно расширение меняется (в любом случае заменяется в коде)
            currentFile: image.image_name + "." + formatComboBox.currentText

            nameFilters: [ formatComboBox.currentText ]

            onAccepted: {formatState.set_new_format(formatComboBox.currentText, selectedFile)}
        }



        // row кнопок
        RowLayout {
            Layout.fillWidth: true

            spacing: 10 * scaleFactor
            
            // кнопка CHANGE
            UI.NyafButton {
                    text: "CHANGE"

                    scaleFactor: root.scaleFactor

                    hoverColor: "black"
                    baseColor: "#000DFF"
                    glowColor: "#AB000DFF"
                    borderColor: "#000DFF"

                    buttonGlow: 1

                    //onClicked: formatState.set_new_format(formatComboBox.currentText)
                    onClicked: saveDialog.open()
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