/*****************
**-180度~180度整圆表盘，value指针当前值
**表盘上Text显示当前值
*****************/

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0


Rectangle {
    id:courseboard
    width: 200
    height: 200
    color: "transparent"
    property double currentValue: 0
    property string fontfamily: "Monaco"

    CircularGauge {
        id: gauge

        //表盘上显示的最小值/最大值
        maximumValue: 180
        minimumValue: -180
        anchors.centerIn: parent
        anchors.fill: parent

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

        //指针移动数字动画
        Behavior on value {
                 NumberAnimation {duration: 1000}
             }

        style: CircularGaugeStyle {
            id: style

            //指针旋转最大角度/最小角度，，12点方向向右是正值
            maximumValueAngle:180
            minimumValueAngle:-180

            //表盘上文本之间的步长
            labelStepSize:30

            //表盘的指针
            needle: Rectangle {
                y: outerRadius * 0.15
                implicitWidth: outerRadius * 0.03
                implicitHeight: outerRadius * 0.9
                antialiasing: true
                color: "#e34c22"
            }

            //表盘前景，即指针中间旋钮
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

            //刻度标签（自定义）
            tickmarkLabel:  Text {
                font.pixelSize: Math.max(6, outerRadius * 0.1)
                text: styleData.value
                color: styleData.value >= -150 ? Qt.lighter("#06B9D1") : Qt.lighter("black")
                antialiasing: true
                font.family: fontfamily
            }

            //表盘上的文本到中心的距离
            labelInset:20

            //大刻度步长
            tickmarkStepSize:30

            //大刻度线颜色（自定义）
            tickmark: Rectangle {
                implicitWidth: outerRadius * 0.03
                antialiasing: true
                implicitHeight: outerRadius * 0.15
                color: Qt.lighter("#06B9D1")
            }

            //小刻度线颜色（自定义）
            minorTickmark: Rectangle {
                implicitWidth: outerRadius * 0.01
                antialiasing: true
                implicitHeight: outerRadius * 0.07
                color: Qt.lighter("#06B9D1")
            }
        }
        Text {
            id: indexText
            text:  "0.0"
            color: Qt.lighter("#06B9D1")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 40
            font.pixelSize: 12
            font.bold: true
            font.family: fontfamily
        }
    }

}
