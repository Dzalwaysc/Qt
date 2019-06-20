import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    visible: true
    width: 1024
    height: 688
    title: qsTr("Hello World")
    color: "black"

    StarBackground2{
        anchors.centerIn: parent
    }
    MetorShower{
        anchors.centerIn: parent
    }
}
