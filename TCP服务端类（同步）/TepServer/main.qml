import QtQuick 2.9
import QtQuick.Window 2.2
import io.tcpServer 1.0
Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")


    // 开始/停止按钮
    Rectangle{
        id: activeBtn
        x: 200; y:100
        width: 100; height: 70
        color: "red"

        Text {id: activeText; text: "开始"}

        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(activeText.text === "开始"){
                    server.startListen();
                    activeText.text = "停止";
                }else if(activeText.text === "停止"){
                    server.closeListen();
                    activeText.text = "开始"
                }
            }
        }

    }

    // TCP服务器的接口
    // 接受的信息以及客户端信息 -> 通过qDebug输出 -> fortunethread.cpp -> run()
    Server{
        id: server
        hostName: "127.0.0.1"
        port: 8000
    }
}
