import QtQuick 2.9
import QtQuick.Window 2.2
import QtCharts 2.0
import QtQuick.Controls 2.4

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    Chart{
        id: myChart
        x:100; y: 100
        Connections{
            target: zoomButton
            onZoomIconClicked: {
                if(zoomButton.state === "") myChart.is_zoom = false;
                else myChart.is_zoom = true;
            }
        }
    }

    Rectangle{
        id: zoomButton
        x: 10; y: 10
        width: 50
        height: 50
        color: "red"

        // 内置信号
        signal zoomIconClicked

        // 设置状态观察是否为zoom状态
        states:State {
                name: "active"
                PropertyChanges {target: zoomButton; color: "green"}
            }

        // 鼠标点击区域
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(zoomButton.state === ""){
                    zoomButton.state = "active"
                }
                else if(zoomButton.state === "active"){
                    zoomButton.state = ""
                }
                zoomButton.zoomIconClicked();
            }
        }
    }

}
