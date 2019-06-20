/************
**value表示当前鼠标位置
       暴露currentValue，用currValue从外界获取当前值
**动画效果使指针摆动更真实，没有动画效果指针会直接跳到当前值
**unitText显示单位“km/h”  indexText显示当前值
***********/


import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0

CircularGauge {

    id: velocityBoard
    width: 150
    height: 150
    property double currentValue: 30
    property string fontfamily: "Monaco"

    // 表盘上显示的最大值/最小值
    maximumValue: 60
    minimumValue: 0

    // 当前值
    value:  currentValue

    style: CircularGaugeStyle {
        // 表盘刻度最小值/最大值，12点方向向右是正值
        maximumValueAngle: 145
        minimumValueAngle: -145

        labelInset:-5   // 表盘文本到中心的距离
        labelStepSize: 5 // 表盘文本的步长

        // 大刻度设置
        tickmarkStepSize: 5 // 大刻度的步长
        tickmarkInset: 6    // 大刻度到中心的距离

        // 小刻度设置
        minorTickmarkInset: 6

        // 表盘的指针
        needle:Item{
            Image{
                anchors.horizontalCenter: parent.horizontalCenter
                y: -60
                width: outerRadius * 0.5
                height: outerRadius * 0.5
                source: "needle.png"
            }
        }

        // 表盘前景，即指针中间旋钮
        foreground: Item {
            Image{
                width: outerRadius * 1.0
                height: outerRadius * 1.0
                anchors.centerIn: parent
                source: "circle.png"
            }
            Text{
                text: currentValue.toFixed(1)
                color: "white"
                font.family: fontfamily
                font.pixelSize: 16
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 10
            }
        }

        // 大刻度标签
        tickmarkLabel: Text {
            id: tickLabel
            anchors.top: parent.top
            font.pixelSize: Math.max(6, outerRadius * 0.1)
            text: styleData.value
            color: "white" // Qt.lighter("#06B9D1")
            antialiasing: true
            font.family: fontfamily

            Connections{
                target: velocityBoard
                onValueChanged:{
                    //console.log(currentValue.toFixed(0));
                    if(currentValue.toFixed(1) == 40.0){
                        console.log("Now value: "+tickLabel.text);
                        console.log("hei")
                    }
                }
            }
        }

        // 大刻度线
        tickmark: Rectangle {
            implicitWidth: outerRadius * 0.05
            implicitHeight: outerRadius * 0.05
            radius: implicitWidth / 2
            antialiasing: true
            color: Qt.lighter("#06B9D1")
        }

        // 表盘背景
        background: Item{

            // 外圆环
            Image{
                anchors.fill: parent
                source: "outerCircle.png"
            }

            // 内围能量条
            Canvas{
                id: background
                anchors.fill: parent
                property double currentAngle: valueToAngle(currentValue)*Math.PI/180; // 当前的刻度值对应的角度
                property double initAngle: valueToAngle(0)*Math.PI/180;               // 初始刻度值对应的角度
                property double oX: velocityBoard.width/2                 // 圆心x
                property double oY: velocityBoard.height/2                // 圆心x
                property double oR: velocityBoard.width/2-25             // 能量条半径
                onPaint: {
                    var ctx = getContext("2d");
                    // 内围能量条
                    var drawInterCirc = function(){
                        ctx.beginPath();
                        if(currentValue > 30){
                            ctx.strokeStyle = "#EA2121";
                        }else{
                            ctx.strokeStyle = "#33FFFC";
                        }
                        //ctx.strokeStyle = "#33FFFC" //"#06B9D1";
                        ctx.lineWidth = 15;
                        // 为了对齐仪表盘控件的坐标，角度还要减去90度
                        ctx.arc(oX, oY, oR, initAngle - Math.PI/2, currentAngle  - Math.PI/2, false);
                        ctx.stroke();
                    }
                    ctx.clearRect(0, 0, velocityBoard.width, velocityBoard.height);
                    drawInterCirc();
                }
                Connections{
                    target: velocityBoard
                    onCurrentValueChanged:{
                        background.requestPaint();
                    }
                }
            }
        }
    }
}


//Text {
//    id: unitText
//    text: "km/h"
//    color: Qt.lighter("#06B9D1")
//    anchors.horizontalCenter: parent.horizontalCenter
//    anchors.top: parent.top
//    anchors.topMargin: 40
//    font.pixelSize: 12
//    font.family: fontfamily
//}

//Text {
//    id: indexText
//    text: dashboard.value.toFixed(1)
//    color: Qt.lighter("#06B9D1")
//    anchors.verticalCenter: parent.verticalCenter
//    anchors.horizontalCenter: parent.horizontalCenter
//    anchors.horizontalCenterOffset: 40
//    font.pixelSize: 12
//    font.bold: true
//    font.family: fontfamily
//}
