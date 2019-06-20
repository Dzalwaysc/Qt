import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0

CircularGauge {

    id: velocityBoard
    width: 120
    height: 120
    property double currentValue: 1.3
    property string fontfamily: "Monaco"

    // 表盘上显示的最大值/最小值
    maximumValue: 5
    minimumValue: -5

    // 当前值
    value:  currentValue

    style: CircularGaugeStyle {
        // 表盘刻度最小值/最大值，12点方向向右是正值
        maximumValueAngle: 130
        minimumValueAngle: 310

        labelInset:-6   // 表盘文本到中心的距离
        labelStepSize: 1 // 表盘文本的步长

        // 大刻度设置
        tickmarkStepSize: 1 // 大刻度的步长
        tickmarkInset: 6    // 大刻度到中心的距离

        // 小刻度设置
        minorTickmarkInset: 6
        minorTickmarkCount: 4

        // 表盘的指针
        needle:Item{
            Image{
                anchors.horizontalCenter: parent.horizontalCenter
                y: -45
                width: outerRadius * 0.5
                height: outerRadius * 0.5
                source: "image/needle.png"
            }
        }

        // 表盘前景，即指针中间旋钮
        foreground: Item {
            Image{
                width: outerRadius * 1.0
                height: outerRadius * 1.0
                anchors.centerIn: parent
                source: "image/circle3.png"
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
            font.pixelSize: 10
            text: styleData.value
            color: styleData.value >= -150 ? "white" : Qt.lighter("black")
            antialiasing: true
            font.family: fontfamily
        }

        // 大刻度线
        tickmark: Rectangle {
            implicitWidth: outerRadius * 0.05
            implicitHeight: outerRadius * 0.05
            radius: implicitWidth / 2
            antialiasing: true
            color: "#EFAC51"
        }

        // 表盘背景
        background: Item{

            // 外圆环
            Image{
                anchors.fill: parent
                source: "image/outerCircle3.png"
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
                        ctx.strokeStyle = "#FFB95B";
                        ctx.lineWidth = 15;
                        // 为了对齐仪表盘控件的坐标，角度还要减去90度
                        if(currentValue >= 0){
                            ctx.arc(oX, oY, oR, initAngle - Math.PI/2, currentAngle  - Math.PI/2, true);
                        }else if(currentValue < 0){
                            ctx.arc(oX, oY, oR, initAngle - Math.PI/2, currentAngle  - Math.PI/2, false);
                        }

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
