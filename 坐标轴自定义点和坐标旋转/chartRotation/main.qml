import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
Window {
    visible: true
    width: 1265
    height: 900
    title: qsTr("Hello World")
    color: Qt.hsla(230, 0.64, 0.06, 1)

    MyChart{
        id: myChart
    }
    property int num: 0
    Button{
        width: 20; height: 20
        x: 10; y: 10
        onClicked: {
            if(num == 0){
                // 制造点
                myChart.pointArray.createPoint(100, 150)
            }
            else if(num == 1){
                // 将点的坐标系从大地坐标系转到随体坐标系
                myChart.pointArray.frameTrans();
            }
            else if(num == 2){
                // 旋转90度
                myChart.rect.rotation = 90;
                myChart.pointArray.rotationPoint(90);
            }
            else if(num == 3){
                // 删除点
                myChart.pointArray.removePoint(0);
            }


            num += 1;
        }
    }
    property real a: 0

    Timer{
        id: t
        running: false; repeat: true; interval: 100
        onTriggered: {
            a += 1;
            myChart.rotationChart(a);
        }
    }
}
