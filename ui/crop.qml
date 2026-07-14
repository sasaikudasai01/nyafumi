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

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 30 * root.scaleFactor

        width: 1900 * root.scaleFactor
        height: 900 * root.scaleFactor

        Item {
            id: imageContainer
            height: parent.height
            // если ширина больше высоты
            width: image.width > image.height
                    // если ширина картинки меньше 1067 то ширина = ширина картинки
                    ? Math.min(image.width, 1067) * root.scaleFactor
                    : image.width / (image.height / height)

            // редактируемая картинка
            Image {
                id: picture
                source: image.image
                
                anchors.fill: imageContainer

                // плавная подгрузка и сглаживание
                smooth: true
                asynchronous: true
            }

            UI.CropArea {
                id: cropArea
                scaleFactor: root.scaleFactor
                
                // * (imageContainer.width / image.width) это scale factor для изображения
                changable_width: uiStateCrop.width * (imageContainer.width / image.width)
                changable_height: uiStateCrop.height * (imageContainer.width / image.width)

                onDragFinished: {
                    xCoordsInput.text = Math.round(x / (imageContainer.width / image.width))
                    yCoordsInput.text = Math.round(y / (imageContainer.width / image.width))
                }
            }

            Layout.preferredWidth: width
            Layout.preferredHeight: height
        }
        


        // элементы редактирования
        ColumnLayout {
            spacing: 0

            Text {
                text: "CROP"
                color: "white"

                font.pixelSize: 120 * root.scaleFactor
                font.family: "Inter"
                font.weight: Font.Black
            }

            Item { Layout.fillHeight: true }

            // row эдементов редактирования
            ColumnLayout {
                width: 900 * root.scaleFactor
                spacing: 50 * root.scaleFactor

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

                        text: uiStateCrop.width
                        color: "white"

                        onTextEdited: uiStateCrop.width = text

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
                        
                        text: uiStateCrop.height
                        color: "white"

                        onTextEdited: uiStateCrop.height = text

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

                // x coord
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        text: "X COORDS"
                        color: "white"

                        font.pixelSize: 48 * root.scaleFactor
                        font.family: "Inter"
                        font.weight: Font.Black

                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    Item { Layout.fillWidth: true } // заполнить пустым пространством

                    // TextField для ввода координат х
                    TextField {
                        id: xCoordsInput
                        
                        text: uiStateCrop.x_coord
                        color: "white"

                        onTextEdited: {
                            uiStateCrop.x_coord = text
                            cropArea.x = uiStateCrop.x_coord * (imageContainer.width / image.width)
                        }

                        font.pixelSize: 48 * root.scaleFactor
                        font.family: "Inter"
                        font.weight: Font.Black

                        background: null
                        validator: IntValidator { bottom: 0; top: 9999 } // ограничить числами от 0 до 9999
                    }
                }

                // y coord
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        text: "Y COORDS"
                        color: "white"

                        font.pixelSize: 48 * root.scaleFactor
                        font.family: "Inter"
                        font.weight: Font.Black

                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }

                    Item { Layout.fillWidth: true } // заполнить пустым пространством

                    // TextField для ввода координат y
                    TextField {
                        id: yCoordsInput
                        
                        text: uiStateCrop.y_coord
                        color: "white"

                        onTextEdited: {
                            uiStateCrop.y_coord = text
                            cropArea.y = uiStateCrop.y_coord * (imageContainer.width / image.width)
                        }

                        font.pixelSize: 48 * root.scaleFactor
                        font.family: "Inter"
                        font.weight: Font.Black

                        background: null
                        validator: IntValidator { bottom: 0; top: 9999 } // ограничить числами от 0 до 9999
                    }
                }
            }

            Item { Layout.fillHeight: true }

            // row кнопок
            RowLayout {
                Layout.fillWidth: true
                spacing: 0
                
                // кнопка CROP
                UI.NyafButton {
                    text: "CROP"

                    scaleFactor: root.scaleFactor

                    hoverColor: "black"
                    baseColor: "#000DFF"
                    glowColor: "#AB000DFF"
                    borderColor: "#000DFF"

                    buttonGlow: 1

                    onClicked: uiStateCrop.crop(widthInput.text, heightInput.text, cropArea.x / (imageContainer.width / image.width), cropArea.y / (imageContainer.width / image.width))
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