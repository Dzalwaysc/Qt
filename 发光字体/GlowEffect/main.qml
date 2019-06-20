/******************
**Glow:辉光渲染效果
**使用数字动画NumberAnimation来时渲染效果动起来，有闪烁的效果
******************/

import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    color: "black"

    GlowWords{
        id: glowwords
        x: 0; y: 0
    }
}
