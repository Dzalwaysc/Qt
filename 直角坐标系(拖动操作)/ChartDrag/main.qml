import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    ChartDrag{
        id: chartDrag
        anchors.centerIn: parent
    }

    Rectangle{
        id: activeBtn
        width: 100
        height: 100
        x: 0; y: 0
        border.color: "black"
        Text{id: btnText; text: "打开拖动"; anchors.centerIn: parent}

        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(!chartDrag.isDrag){
                    chartDrag.isDrag = true;
                    btnText.text = "关闭拖动"
                }
                else{
                    chartDrag.isDrag = false;
                    btnText.text = "打开拖动"
                }
            }
        }
    }
}
