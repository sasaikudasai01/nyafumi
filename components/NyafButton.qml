import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    id: root
    Layout.preferredWidth: width
    Layout.preferredHeight: height

    // текст кнопки
    property alias text: label.text
    // наведен ли курсор на кнопку или нет
    property bool hovered: false
    // цвет кнопки при наведении и текста
    property color hoverColor: "black"
    // цвет кнопки
    property color baseColor: "white"
    // тот же цвет что и baseColor но на 67% прозрачности. это нужно чтобы регулировать интенсивность свечения
    // белый слишком яркий, поэтому у него не 67 а 40%
    property color glowColor: "#66FFFFFF"
    // цвет бордера кнопки. обычно тот же что и основной если основной не black
    // это нужно чтобы не привязывать бордер к основному цвету, иначе кнопка будет без бордера если цвет black
    property color borderColor: "white"
    // это нужно чтобы масштабировать кнопку на разных разрешениях правильно
    property real scaleFactor: 1.0

    // они нужны чтобы свечение включалось/выключалось или выключалось/включалось
    property real buttonGlow: 0.0
    property real textGlow: 0.0

    // это нужно динамического изменения размера кнопки по необходимости
    property real changable_width: 235.0 * scaleFactor
    property real changable_height: 65.0 * scaleFactor

    signal clicked()

    width: changable_width
    height: changable_height

    // ФОН КНОПКИ
    Rectangle {
        id: body
        anchors.fill: parent
        radius: 30 * scaleFactor
        color: root.hovered ? hoverColor : baseColor
        border.color: borderColor
        border.width: 2 * scaleFactor

        // анимация смены цветов
        Behavior on color {
            ColorAnimation {
                duration: 670
            }
        }
    }

    // свечение кнопки
    DropShadow {
        anchors.fill: body
        source: body

        radius: 120 * scaleFactor
        samples: 50
        spread: 0
        color: glowColor
        opacity: root.hovered ? 0.0 : buttonGlow

         // анимация смены прозрачности
         Behavior on opacity {
             NumberAnimation {
                 duration: 670
             }
         }
    }

    // ТЕКСТ
    Text {
        id: label
        anchors.centerIn: parent

        color: root.hovered ? baseColor : hoverColor

        font.pixelSize: 50 * scaleFactor
        font.family: "Inter"
        font.weight: Font.Black

        // анимация смены цветов
        Behavior on color {
            ColorAnimation {
                duration: 670
            }
        }
    }

    // свечение текста
    DropShadow {
        anchors.fill: label
        source: label

        radius: 40 * scaleFactor
        samples: 50
        spread: 0
        color: hoverColor
        opacity: root.hovered ? 0.0 : textGlow

         // анимация смены прозрачности
         Behavior on opacity {
             NumberAnimation {
                 duration: 670
             }
         }
    }

    // ИНТЕРАКЦИЯ
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: root.hovered = true
        onExited: root.hovered = false
        onClicked: root.clicked()
    }
}