import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0

Window {
    visible: true
    width: 1024
    height: 668
    title: qsTr("Hello World")
    color: Qt.lighter("black")


    VelocityBoard{
        id: dashBoard
        x: 120; y: 210
    }

    CourseBoard{
        id: courseboard
        x: 340; y: 210
    }

    ArcBoard{
        id: arcboard
        x: 300; y: 160

    }
}
