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
        text: "RESIZE"

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

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 20 * root.scaleFactor

        height: 667 * root.scaleFactor

        // редактируемая картинка
        Image {
            id: picture
            source: image.image

            // если ширина больше высоты
            width: image.width > image.height
                    // если ширина картинки меньше 1067 то ширина = ширина картинки
                    ? Math.min(image.width, 1080) * root.scaleFactor
                    : image.width / (image.height / parent.height)
            
            height: image.height / (image.width / width)

            fillMode: Image.PreserveAspectFit
            sourceSize: Qt.size(width, height) // декодировать картинку чтобы она была нужного размера

            // плавная подгрузка и сглаживание
            smooth: true
            asynchronous: true
            
            Layout.preferredWidth: width
            Layout.preferredHeight: height
        }

        // элементы редактирования
        ColumnLayout {
            spacing: 0

            Text {
                text: "RESIZE"
                color: "white"

                font.pixelSize: 120 * root.scaleFactor
                font.family: "Inter"
                font.weight: Font.Black
            }

            Item { Layout.fillHeight: true }

            // row эдементов редактирования
            ColumnLayout {
                spacing: 50 * root.scaleFactor

                // MAINTAIN ASPECT RATIO
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20 * root.scaleFactor

                    Text {
                        text: "MAINTAIN ASPECT RATIO"
                        color: "#808080" // 50% white

                        font.pixelSize: 40 * root.scaleFactor
                        font.family: "Inter"
                        font.weight: Font.Black

                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    UI.NyafButton {
                        text: " "

                        scaleFactor: root.scaleFactor
                        
                        changable_width: 35 * root.scaleFactor
                        changable_height: 35 * root.scaleFactor

                        hoverColor: uiStateResize.maintain_aspect_ratio
                        baseColor: uiStateResize.maintain_aspect_ratio
                        borderColor: "#808080"

                        onClicked: uiStateResize.maintain_aspect_ratio = "1"
                    }
                }

                // WIDTH
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        text: "WIDTH"
                        color: "white"

                        font.pixelSize: 48 * root.scaleFactor
                        font.family: "Inter"
                        font.weight: Font.Black

                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    Item { Layout.fillWidth: true } // заполнить пустым пространством

                    // TextField для ввода ширины
                    TextField {
                        id: widthInput

                        text: uiStateResize.width
                        color: "white"

                        onTextEdited: uiStateResize.width = text

                        font.pixelSize: 48 * root.scaleFactor
                        font.family: "Inter"
                        font.weight: Font.Black

                        background: null
                        validator: IntValidator { bottom: 0; top: 9999 } // ограничить числами от 0 до 9999
                    }

                    Text {
                        text: " px"
                        color: "white"

                        font.pixelSize: 48 * root.scaleFactor
                        font.family: "Inter"
                        font.weight: Font.Black
                    }
                }

                // HEIGHT
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        text: "HEIGHT"
                        color: "white"

                        font.pixelSize: 48 * root.scaleFactor
                        font.family: "Inter"
                        font.weight: Font.Black

                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    Item { Layout.fillWidth: true } // заполнить пустым пространством

                    // TextField для ввода высоты
                    TextField {
                        id: heightInput
                        
                        text: uiStateResize.height
                        color: "white"

                        onTextEdited: uiStateResize.height = text

                        font.pixelSize: 48 * root.scaleFactor
                        font.family: "Inter"
                        font.weight: Font.Black

                        background: null
                        validator: IntValidator { bottom: 0; top: 9999 } // ограничить числами от 0 до 9999
                    }

                    Text {
                        text: " px"
                        color: "white"

                        font.pixelSize: 48 * root.scaleFactor
                        font.family: "Inter"
                        font.weight: Font.Black
                    }
                }

                // crop by percent
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        text: "BY PERCENTAGE"
                        color: "white"

                        font.pixelSize: 48 * root.scaleFactor
                        font.family: "Inter"
                        font.weight: Font.Black

                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    Item { Layout.fillWidth: true } // заполнить пустым пространством

                    // TextField для ввода ширины
                    TextField {
                        id: percentageInput

                        text: uiStateResize.percent
                        color: "white"

                        onTextEdited: uiStateResize.percent = text

                        font.pixelSize: 48 * root.scaleFactor
                        font.family: "Inter"
                        font.weight: Font.Black

                        background: null
                        validator: IntValidator { bottom: 1; top: 10 } // ограничить числами от 1 до 99
                    }

                    Text {
                        text: " %"
                        color: "white"

                        font.pixelSize: 48 * root.scaleFactor
                        font.family: "Inter"
                        font.weight: Font.Black
                    }
                }
            }

            Item { Layout.fillHeight: true }

            // row кнопок
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                FileDialog {
                    id: saveDialog

                    title: "Save image"

                    fileMode: FileDialog.SaveFile

                    currentFile: image.image_name

                    onAccepted: {uiStateResize.resize(widthInput.text, heightInput.text, selectedFile)}
                }

                // кнопка APPLY
                UI.NyafButton {
                    text: "RESIZE"

                    scaleFactor: root.scaleFactor

                    hoverColor: "black"
                    baseColor: "#000DFF"
                    glowColor: "#AB000DFF"
                    borderColor: "#000DFF"

                    buttonGlow: 1

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

                Item { Layout.fillWidth: true } // заполнить пустым пространством

                // кнопка reset
                UI.NyafButton {
                    text: "RESET"

                    scaleFactor: root.scaleFactor

                    hoverColor: "white"
                    baseColor: "black"
                    borderColor: "white"

                    textGlow: 1

                    onClicked: uiStateResize.update_info()
                }
            }
        }
    }
}