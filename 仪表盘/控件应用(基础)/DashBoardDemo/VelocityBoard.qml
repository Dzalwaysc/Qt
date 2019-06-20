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

Rectangle {
    id:biao
    width: 200
    height: 200
    color: "transparent"
    property double currentValue: 0
    property string fontfamily: "Monaco"

    CircularGauge {
        id: dashboard
        anchors.centerIn: parent
        anchors.fill: parent

        value:  currentValue
        style: CircularGaugeStyle {

            // 表盘刻度最小值/最大值，12点方向向右是正值
            maximumValueAngle: 120
            minimumValueAngle: -120

            // 表盘的指针
            needle: Rectangle {
                y: outerRadius * 0.15
                implicitWidth: outerRadius * 0.03
                implicitHeight: outerRadius * 0.9
                antialiasing: true
                color: "#e34c22"
            }

            // 表盘前景，即指针中间旋钮
            foreground: Item {
                Rectangle {
                    id: circular
                    width: outerRadius * 0.2
                    height: width
                    radius: width / 2
                    color: "#494d53"
                    anchors.centerIn: parent
                }
            }

            // 刻度标签加红（自定义） --->  表盘上80度至100度的范围内的标签
            tickmarkLabel:  Text {
                font.pixelSize: Math.max(6, outerRadius * 0.1)
                text: styleData.value
                color: styleData.value >= 80 ? "#e34c22" : Qt.lighter("#06B9D1")
                antialiasing: true
                font.family: fontfamily
            }

            // 表盘上的文本到中心的距离
            labelInset:20

            // 大刻度线加红（自定义）   --->  表盘上80度至100度的范围内的标签
            tickmark: Rectangle {
                visible: styleData.value < 80 || styleData.value % 10 == 0
                implicitWidth: outerRadius * 0.03
                antialiasing: true
                implicitHeight: outerRadius * 0.15
                color: styleData.value >= 80 ? "#e34c22" : Qt.lighter("#06B9D1")        //e5e5e5
            }

            // 去掉红格中的小刻度线（自定义）  --->  表盘上80度至100度的范围内的标签
            minorTickmark: Rectangle {
                visible: styleData.value < 80
                implicitWidth: outerRadius * 0.01
                antialiasing: true
                implicitHeight: outerRadius * 0.07
                color: Qt.lighter("#06B9D1")
            }

            // 表盘上80度-100度的红线
            background: Canvas {
                onPaint: {

                    // 将角度变为弧度
                    function degreesToRadians(degrees) {
                        return degrees * (Math.PI / 180);
                    }

                    var ctx = getContext("2d");
                    ctx.reset();

                    ctx.beginPath();
                    ctx.strokeStyle = "#e34c22";
                    ctx.lineWidth = outerRadius * 0.03;

                    //{x,y,r,起始角,终止角}请注意，在转换为弧度之前，我们减去90度，因为我们的原点是北，画布是东。
                    ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2,
                      degreesToRadians(valueToAngle(80) - 90), degreesToRadians(valueToAngle(100) - 90));
                    ctx.stroke();
            }
        }
    }

        // 指针移动数字动画
        Behavior on value {
            NumberAnimation {duration: 500}
        }
    }

    CircularGauge{
        id: small
        width: 200; height: 200

        //空格控制当前值，按下空格时指针指向最大值，松开空格键指针回落为0
        value: accelerating ? maximumValue : 0
        property bool accelerating: false
        Keys.onSpacePressed: accelerating = true
        Keys.onReleased: {
            if (event.key === Qt.Key_Space) {
                 accelerating = false;
                 event.accepted = true;
             }
        }
        Component.onCompleted: forceActiveFocus()

        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 30
        anchors.horizontalCenter: parent.horizontalCenter

        //表盘上显示的最小值/最大值
        maximumValue: 10
        minimumValue: 0

        style: CircularGaugeStyle {

            //指针旋转最大角度/最小角度，，12点方向向右是正值
            maximumValueAngle: 215
            minimumValueAngle: 145

            //表盘的指针
            needle: Rectangle {
                y: outerRadius * 0.1
                implicitWidth: outerRadius * 0.03
                implicitHeight: outerRadius * 0.7
                antialiasing: true
                color:"#7CFC00"
            }

            //刻度标签颜色（自定义）
            tickmarkLabel:  Text {
                font.pixelSize: Math.max(6, outerRadius * 0.1)
                text: styleData.value
                color: "#7CFC00"
                antialiasing: true
                font.family: fontfamily
            }

            //大刻度线颜色（自定义）
            tickmark: Rectangle {
                implicitWidth: outerRadius * 0.02
                antialiasing: true
                implicitHeight: outerRadius * 0.10
                color: "#7CFC00"
            }

            //小刻度线颜色（自定义）
            minorTickmark: Rectangle {
                implicitWidth: outerRadius * 0.005
                antialiasing: true
                implicitHeight: outerRadius * 0.03
                color: "#7CFC00"
            }

            labelInset: 45             //标签到中心点的距离
            tickmarkInset: 30          //大刻度到中心点的距离
            minorTickmarkInset: 30     //小刻度到中心点的距离
            tickmarkStepSize: 2        //大刻度步长
            minorTickmarkCount: 3      //小刻度数量
        }

        //指针移动数字动画
        Behavior on value {
            NumberAnimation {duration: 500}
        }
    }


    Text {
        id: unitText
        text: "km/h"
        color: Qt.lighter("#06B9D1")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 40
        font.pixelSize: 12
        font.family: fontfamily
    }

    Text {
        id: indexText
        text: dashboard.value.toFixed(1)
        color: Qt.lighter("#06B9D1")
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 40
        font.pixelSize: 12
        font.bold: true
        font.family: fontfamily
    }

}
