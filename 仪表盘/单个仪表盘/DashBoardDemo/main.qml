import QtQuick.Window 2.2
import QtQuick 2.9

Window {
    visible: true
    width: 1024
    height: 668
    title: qsTr("Hello World")
    color: Qt.lighter("black")


    DashBoard{
        id: dashBoard
        x: 120; y: 210
    }

    // 开始 加
    Rectangle{
        x:10; y: 10
        width: 50; height: 50
        color: "red"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                timer_subtract.stop();
                timer_add.start();
            }
        }

        Timer{
            id: timer_add
            running: false; interval: 50; repeat: true
            onTriggered: {
                dashBoard.currentValue += 0.1;
            }
        }
    }

    // 开始 减
    Rectangle{
        x:10; y: 70
        width: 50; height: 50
        color: "red"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                timer_add.stop()
                timer_subtract.start()
            }
        }

        Timer{
            id: timer_subtract
            running: false; interval: 50; repeat: true
            onTriggered: {
                dashBoard.currentValue -= 0.1;
            }
        }
    }

    // 停止
    Rectangle{
        x:10; y: 130
        width: 50; height: 50
        color: "red"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                timer_add.stop()
                timer_subtract.stop()
            }
        }
    }

    OuterCircle{
        x: 800
        y: 300
    }

    ForeGround{
        x: 800
        y:100
    }
}
