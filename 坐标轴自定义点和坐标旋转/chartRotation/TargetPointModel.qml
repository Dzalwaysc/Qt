import QtQuick 2.0

Rectangle{
    id: rect
    property real earthFrame_valueX
    property real earthFrame_valueY
    property real bodyFrame_valueX
    property real bodyFrame_valueY
    property bool isEarthFrame: true
    width: 20; height: 20
    color: "blue"

    Text{
        id: valueText
        text: isEarthFrame == true ? earthFrame_valueX + ", " + earthFrame_valueY : bodyFrame_valueX + ", " + bodyFrame_valueY
        font.family: "monaco"
        font.pixelSize: 10
        color: "white"
        anchors.bottom: rect.top
        anchors.horizontalCenter: rect.horizontalCenter
    }
}
