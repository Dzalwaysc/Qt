import QtQuick 2.9
import QtQuick.Window 2.2
import io.udp 1.0

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
                    udp.bindSocket();
                    activeText.text = "停止";
                }else if(activeText.text === "停止"){
                    udp.closeSocket();
                    activeText.text = "开始"
                }
            }
        }

    }

    // 发送按钮
    Rectangle{
        id: sendBtn
        x: 200; y:200
        width: 100; height: 70
        color: "blue"

        Text{id: sendText; text: "发送"}

        MouseArea{
            anchors.fill: parent
            onClicked: udp.sendData();
        }
    }

    // 接受信息框
    Text {
        x: 400; y:200
        width: 100; height: 50
        id: recvText
        text: udp.recvMsg
    }

    // udp的接口
    Udp{
        id: udp
        localHostName: "127.0.0.1" // 本地地址
        targetHostName: "127.0.0.1" // 目标地址
        localPort: 5000   // 本地端口
        targetPort: 6000  // 本地端口
        response: "hello"
    }
}
