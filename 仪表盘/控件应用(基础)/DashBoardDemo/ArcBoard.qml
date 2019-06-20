/*****************
**半弧表盘，使用大圆表盘的一段弧，指针长度与刻度线等宽
**value接受当前刻度位置
**使指针旋转最大角度小于最小角度，从而让指针反转
*****************/

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0


Rectangle{
    id: arctank
    width: 300
    height: 300
    border.color: "transparent"
    color: "transparent"
    property string fontfamily: "Monaco"

    CircularGauge{
        id:tankborder
        width: 200; height: 200
        anchors.verticalCenter: arctank.verticalCenter
        anchors.horizontalCenter: arctank.horizontalCenter
        anchors.horizontalCenterOffset: -150

        //表盘上显示的最小值/最大值
        minimumValue: 0
        maximumValue: 100

        value: 0

        //指针移动数字动画
        Behavior on value {
            NumberAnimation{duration: 1000}
        }

        style: CircularGaugeStyle{
            id: tankstyle

            //指针旋转最大角度/最小角度，，12点方向向右是正值
            maximumValueAngle: 70
            minimumValueAngle: 110

            //表盘的指针
            needle: Rectangle {
                y: -265
                implicitWidth: outerRadius * 0.1
                implicitHeight: outerRadius * 0.35
                antialiasing: true
                color: "#e34c22"
            }

            //表盘前景，即指针中间旋钮
            foreground: Item{
                Rectangle{
                    color:"transparent"
                }
            }

            //大刻度线颜色（自定义）
            tickmark: Rectangle {
                implicitWidth: outerRadius * 0.06
                antialiasing: true
                implicitHeight: outerRadius * 0.3
                color: Qt.lighter("#06B9D1")
            }

            //小刻度线颜色（自定义）
            minorTickmark: Rectangle {
                implicitWidth: outerRadius * 0.02
                antialiasing: true
                implicitHeight: outerRadius * 0.15
                color: Qt.lighter("#06B9D1")
            }

            //刻度标签颜色（自定义）
            tickmarkLabel:  Text {
                font.pixelSize: Math.max(6, outerRadius * 0.1)
                text: styleData.value
                color: Qt.lighter("#06B9D1")
                antialiasing: true
                font.family: fontfamily
            }

            labelInset: -160             //标签到中心点的距离
            tickmarkInset: -200          //大刻度到中心点的距离
            minorTickmarkInset: -200     //小刻度到中心点的距离
            tickmarkStepSize: 20         //大刻度步长
            minorTickmarkCount: 5        //小刻度数量
        }
    }
}
