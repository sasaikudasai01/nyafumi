import QtQuick 6.5
import QtQuick.Controls 6.5

ComboBox {
    id: root

    // ============================
    // Публичные свойства компонента
    // ============================

    // Цвет фона поля
    property color backgroundColor: "#000333"

    // Цвет рамки
    property color borderColor: "#404040"

    // Цвет текста
    property color textColor: "white"

    // Цвет текста при наведении в списке
    property color hoverTextColor: "white"

    // Цвет выделенного элемента списка
    property color highlightColor: "#FE3C79"

    // Радиус скругления
    property int radius: 10


    // ============================
    // Само поле ComboBox
    // ============================

    background: Rectangle {

        // занимает весь размер ComboBox
        anchors.fill: parent

        // фон
        color: root.backgroundColor

        // скругление
        radius: root.radius

        // рамка
        border.width: 0
        border.color: root.borderColor
    }


    // ============================
    // Текст выбранного элемента
    // ============================

    contentItem: Text {

        // текущий выбранный текст
        text: root.displayText

        // цвет текста
        color: root.textColor

        // размер текста
        font.pixelSize: 30

        // вертикальное выравнивание
        verticalAlignment: Text.AlignVCenter

        // отступ слева
        leftPadding: 12

        // место справа под стрелку
        rightPadding: 35
    }


    // ============================
    // Стрелка справа
    // ============================

    indicator: Text {

        // символ стрелки
        text: "▼"

        color: root.textColor

        font.pixelSize: 12

        anchors {

            // справа от элемента
            right: parent.right

            rightMargin: 12

            // по центру вертикально
            verticalCenter: parent.verticalCenter
        }
    }


    // ============================
    // Выпадающий список
    // ============================

    popup: Popup {

        // положение относительно ComboBox
        y: root.height + 5

        // ширина такая же как у поля
        width: root.width


        background: Rectangle {

            color: root.backgroundColor

            radius: root.radius

            border.width: 0
            border.color: root.borderColor
        }


        contentItem: ListView {

            implicitHeight: contentHeight

            // запрещает рисование за пределами списка
            clip: true

            // модель самого ComboBox
            model: root.popup.visible
                   ? root.delegateModel
                   : null


            delegate: ItemDelegate {

                // ширина элемента
                width: root.width

                // высота пункта
                height: 35


                background: Rectangle {

                    radius: 6

                    color: highlighted
                           ? root.highlightColor
                           : "transparent"
                }


                contentItem: Text {

                    text: modelData

                    color: root.textColor

                    verticalAlignment: Text.AlignVCenter

                    leftPadding: 12
                }
            }
        }
    }
}