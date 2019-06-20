import QtQuick 2.9
import QtQuick.Window 2.2
import io.workerThread 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    Rectangle{
        id: rect
        width: 200
        height: 30
        x: 20; y:20
        color: Qt.rgba(125, 0, 0, .3)

        Text{
            id: text
            anchors.centerIn: parent
            color: "white"
            text: "开始"
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(text.text == "开始"){
                    worker.run()
                    text.text = "停止"
                }else if(text.text == "停止"){
                    worker.stop()
                    text.text = "关闭"
                }else{
                    worker.close()
                    text.text = "开始"
                }
            }
        }
    }

    Worker{
        id: worker
    }
}
