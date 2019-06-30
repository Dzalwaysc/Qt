/**************************
**
** 点击该按钮，按钮先变小再变大
** 用户属性:
**        btnWidth:  按钮宽度
**        btnHeight: 按钮高度
**        btnText:   按钮文本
** 用户信号:
**        clicked()  单击按钮发出该信号
***************************/

/*******************************
**所有窗口出现文字的地方都定义字体大小
**否则会出现系统自定义字体不同而混乱，影响界面美观
********************************/

import QtQuick 2.0

Rectangle{
    id: btnOne
    border.color: "white"
    color: Qt.rgba(255, 0, 0, .4)
    width: btnWidth; height: btnHeight
    scale: 1

    // 用户属性
    property real btnWidth: 30
    property real btnHeight: 20
    property string btnText: "发送"

    //内置属性
    property string fontfamily: "Monaco"
    property real fontpielSize: 13             //字体大小

    //用户信号
    signal clicked()

    SequentialAnimation{
        id: animation
        running: false
        NumberAnimation{
            target: btnOne; property: "scale"
            from:1; to:0.8; duration: 100;
        }
        NumberAnimation{
            target: btnOne; property: "scale"
            from:0.8; to:1; duration: 100
        }
    }

    Text{text: btnText; color: "white"; font.family: fontfamily; anchors.centerIn: parent; font.pixelSize: fontpielSize}

    MouseArea{
        anchors.fill: parent
        enabled: parent.opacity == 1 ? true : false
        onClicked: {
            animation.start()
            btnOne.clicked();
        }
    }
}
