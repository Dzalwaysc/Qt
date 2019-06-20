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
        x: 150; y: 20
    }

    DashBoard2{
        id: dashBoard2
        x: 360; y:20
    }

    DashBoard3{
        id: dashBoard3
        x: 23; y:75
    }

    Frame{
        x:0; y:0
    }

    // 开始 加
    Rectangle{
        x:10; y: 300
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
                dashBoard2.currentValue += 1;
                dashBoard3.currentValue += 0.05;
            }
        }
    }

    // 开始 减
    Rectangle{
        x:10; y: 370
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
                dashBoard2.currentValue -= 1;
                dashBoard3.currentValue -= 0.05;
            }
        }
    }

    // 停止
    Rectangle{
        x:10; y: 440
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
