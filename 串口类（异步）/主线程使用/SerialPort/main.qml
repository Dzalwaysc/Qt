import QtQuick 2.9
import QtQuick.Window 2.2
import io.serialport 1.0
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
                    comm.startSlave();
                    activeText.text = "停止";
                }else if(activeText.text === "停止"){
                    comm.closeSlave();
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
            onClicked: comm.sendResponse();
        }
    }

    // 串口类的接口
    // 读取到的信息 ->  通过qDebug()<<m_recvMsg输出  -> slavethread.cpp  -> handleReadyRead()
    Comm{
        id: comm
        portName: "COM1" // 其他设置为默认设置，若要更改，前往slavethread.cpp -> startSlave()
        response: "hello"
    }
}
