import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    color: Qt.hsla(230, 0.64, 0.06, 1)

    TextScreen{
        id: screen
    }

    Rectangle{
        id: button
        width: 50
        height: 50
        x: 200; y: 100
        color: "white"

        property int index: 0
        property int num: 0
        MouseArea{
            id: mouse
            anchors.fill: parent
            onClicked: {
                button.num += 1;
                screen.receive("request" + button.num.toString());
            }
        }
    }

}
