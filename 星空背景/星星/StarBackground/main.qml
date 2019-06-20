import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    visible: true
    width: 1024
    height: 668
    //color: 'hsla(' + 230 + ', 64%, 6%, 2)'
    title: qsTr("Hello World")

//    Star{
//       x: 200
//       y:200
//    }

//    StarBackground2{
//        anchors.centerIn: parent
//        mW: 1024
//        mH: 668
//    }

    StarBackground3{
        anchors.centerIn: parent
        mW: 1024
        mH: 668
    }
}
