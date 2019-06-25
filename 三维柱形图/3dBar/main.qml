import QtQuick 2.9
import QtDataVisualization 1.2
import QtQuick.Window 2.2

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    color: Qt.hsla(230, 0.64, 0.06, 1)

    My3dBar{
        id: my3dBar
    }
}
