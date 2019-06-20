/*****************
**发光呼吸动画字体
**采用辉光效果与数字动画效果相配合产生具有呼吸灯效果的动画字体
**Glow控件产生辉光，数字动画NumberAnimation通过控制透明度的变化产生动画效果
*****************/

import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: glowwords
    width: 640; height: 480
    color: "black"
    Text {
        id: text
        anchors.fill: parent
        text: "茕茕孑立沆瀣一气醍醐灌顶"
        font.bold: true
        font.pixelSize: 50
        color:"white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Glow {
        anchors.fill: text
        radius: 9             //半径决定辉光的柔和度，半径越大辉光的边缘越模糊  样本值=1+半径*2
        samples: 13           //每个像素采集的样本值，值越大，质量越好，渲染越慢
        color: "#ddd"
        source: text
        spread: 0.5           //在光源边缘附近增强辉光颜色的大部分
        opacity: 0.8
        NumberAnimation on opacity {
            id:an1
            to:0.8
            duration: 1000
            running: true     //动画当前是否正在运行
            onStopped: {
                an2.start()
            }
        }
        NumberAnimation on opacity {
            id:an2
            to:0.2
            duration: 1000
            onStopped: {
                an1.start()
            }
        }
    }
}
