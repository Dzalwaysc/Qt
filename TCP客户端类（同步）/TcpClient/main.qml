import QtQuick 2.9
import QtQuick.Window 2.2
import io.tcpClient 1.0
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
                    client.startFortune(client.hostName, client.port);
                    activeText.text = "停止";
                }else if(activeText.text === "停止"){
                    client.closeFortune();
                    activeText.text = "开始"
                }
            }
        }

    }

    // TCP客户端的接口
    // 接受的信息 -> 通过qDebug输出 -> clientthread.cpp -> run()
    Client{
        id: client
        hostName: "127.0.0.1"
        port: 8000
    }
}
