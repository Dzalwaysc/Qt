/******************************************************************
** 至下到上的垂直滚动字幕，每层的字幕透明度可调
** 用户属性： x,y.
** textScreen的width和height由单个rect的高度和宽度还由level的个数决定
** -------------------------------------------------------
******************************************************************/

import QtQuick 2.0

Rectangle{
    id: textScreen
    x: 10; y:100
    width: rect_width; height: rect_height*(4+1)
    color: "transparent"
    border.color: "red"

    // 用户接口
    function receive(Input)
    {
        // 接受输入分两步，第一步是找到level0的矩形，第二步是将输入赋值给这个矩形
        if(rect0.state == "level0")
            rect0.rectText = Input
        else if(rect1.state == "level0")
            rect1.rectText = Input
        else if(rect2.state == "level0")
            rect2.rectText = Input
        else if(rect3.state == "level0")
            rect3.rectText = Input
        else if(rect4.state == "level0")
            rect4.rectText = Input
        else
            rect5.rectText = Input

        // 屏幕滚动分两步
        // 第一步：每一次滚动，rect0的level必然上升1，因此index+=1
        // 第二步，以上一步求出的index为基础，求出其他rect当前的level，然后上升1
        textScreen.index = (textScreen.index + 1) % 6;
        rect0.state = "level" + textScreen.index.toString();
        rect1.state = "level" + ((textScreen.index+1)%6).toString();
        rect2.state = "level" + ((textScreen.index+2)%6).toString();
        rect3.state = "level" + ((textScreen.index+3)%6).toString();
        rect4.state = "level" + ((textScreen.index+4)%6).toString();
        rect5.state = "level" + ((textScreen.index+5)%6).toString();
        console.log(rect0.state)
        console.log(textScreen.index);
        console.log(rect0.opacity);
    }

    // 用户属性， 输入传入至level0所在的那个rect
    property int level0_y: 100; property double level0_opacity: 0
    property int level1_y: 80; property double level1_opacity: 1
    property int level2_y: 60; property double level2_opacity: 0.8
    property int level3_y: 40 ; property double level3_opacity: 0.6
    property int level4_y: 20 ; property double level4_opacity: 0.4
    property int level5_y: 0 ; property double level5_opacity: 0.2

    property int rect_width: 100; property int rect_height: 20

    // 内置属性
    property int index: 0 // index始终指向rect0所在的level

    Rectangle{
        id: rect0
        y: 100
        width: rect_width; height: rect_height
        color: "transparent"
        state: "level0"
        states: [
            State {
                name: "level0";
                PropertyChanges {target: rect0; y: level0_y; opacity: level0_opacity}
            },
            State {
                name: "level1";
                PropertyChanges {target: rect0; y: level1_y; opacity: level1_opacity}
            },
            State {
                name: "level2";
                PropertyChanges {target: rect0; y: level2_y; opacity: level2_opacity}
            },
            State {
                name: "level3";
                PropertyChanges {target: rect0; y: level3_y; opacity: level3_opacity}
            },
            State {
                name: "level4";
                PropertyChanges {target: rect0; y: level4_y; opacity: level4_opacity}
            },
            State {
                name: "level5";
                PropertyChanges {target: rect0; y: level5_y; opacity: level5_opacity}
            }
        ]

        property alias rectText: context0.text
        Behavior on y {NumberAnimation{duration: 300}}
        Behavior on opacity {NumberAnimation{duration: 100}}

        Text{
            id: context0
            anchors.centerIn: parent
            color: "white"
            text: rect0.rectText
        }
    }

    Rectangle{
        id: rect1
        y: 80
        width: rect_width; height: rect_height
        color: "transparent"
        state: "level1"
        states: [
            State {
                name: "level0";
                PropertyChanges {target: rect1; y: level0_y; opacity: level0_opacity}
            },
            State {
                name: "level1";
                PropertyChanges {target: rect1; y: level1_y; opacity: level1_opacity}
            },
            State {
                name: "level2";
                PropertyChanges {target: rect1; y: level2_y; opacity: level2_opacity}
            },
            State {
                name: "level3";
                PropertyChanges {target: rect1; y: level3_y; opacity: level3_opacity}
            },
            State {
                name: "level4";
                PropertyChanges {target: rect1; y: level4_y; opacity: level4_opacity}
            },
            State {
                name: "level5";
                PropertyChanges {target: rect1; y: level5_y; opacity: level5_opacity}
            }
        ]

        property alias rectText: context1.text
        Behavior on y {NumberAnimation{duration: 300}}
        Behavior on opacity {NumberAnimation{duration: 100}}

        Text{
            id: context1
            anchors.centerIn: parent
            color: "white"
            text: rect1.rectText
        }
    }

    Rectangle{
        id: rect2
        y: 60
        width: rect_width; height: rect_height
        color: "transparent"
        state: "level2"
        states: [
            State {
                name: "level0";
                PropertyChanges {target: rect2; y: level0_y; opacity: level0_opacity}
            },
            State {
                name: "level1";
                PropertyChanges {target: rect2; y: level1_y; opacity: level1_opacity}
            },
            State {
                name: "level2";
                PropertyChanges {target: rect2; y: level2_y; opacity: level2_opacity}
            },
            State {
                name: "level3";
                PropertyChanges {target: rect2; y: level3_y; opacity: level3_opacity}
            },
            State {
                name: "level4";
                PropertyChanges {target: rect2; y: level4_y; opacity: level4_opacity}
            },
            State {
                name: "level5";
                PropertyChanges {target: rect2; y: level5_y; opacity: level5_opacity}
            }
        ]
        property alias rectText: context2.text
        Behavior on y {NumberAnimation{duration: 300}}
        Behavior on opacity {NumberAnimation{duration: 100}}

        Text{
            id: context2
            anchors.centerIn: parent
            color: "white"
            text: rect2.rectText
        }
    }

    Rectangle{
        id: rect3
        y: 40
        width: rect_width; height: rect_height
        color: "transparent"
        state: "level3"
        states: [
            State {
                name: "level0";
                PropertyChanges {target: rect3; y: level0_y; opacity: level0_opacity}
            },
            State {
                name: "level1";
                PropertyChanges {target: rect3; y: level1_y; opacity: level1_opacity}
            },
            State {
                name: "level2";
                PropertyChanges {target: rect3; y: level2_y; opacity: level2_opacity}
            },
            State {
                name: "level3";
                PropertyChanges {target: rect3; y: level3_y; opacity: level3_opacity}
            },
            State {
                name: "level4";
                PropertyChanges {target: rect3; y: level4_y; opacity: level4_opacity}
            },
            State {
                name: "level5";
                PropertyChanges {target: rect3; y: level5_y; opacity: level5_opacity}
            }
        ]

        property alias rectText: context3.text
        Behavior on y {NumberAnimation{duration: 300}}
        Behavior on opacity {NumberAnimation{duration: 100}}

        Text{
            id: context3
            anchors.centerIn: parent
            color: "white"
            text: rect3.rectText
        }
    }

    Rectangle{
        id: rect4
        y: 20
        width: rect_width; height: rect_height
        color: "transparent"
        state: "level4"
        states: [
            State {
                name: "level0";
                PropertyChanges {target: rect4; y: level0_y; opacity: level0_opacity}
            },
            State {
                name: "level1";
                PropertyChanges {target: rect4; y: level1_y; opacity: level1_opacity}
            },
            State {
                name: "level2";
                PropertyChanges {target: rect4; y: level2_y; opacity: level2_opacity}
            },
            State {
                name: "level3";
                PropertyChanges {target: rect4; y: level3_y; opacity: level3_opacity}
            },
            State {
                name: "level4";
                PropertyChanges {target: rect4; y: level4_y; opacity: level4_opacity}
            },
            State {
                name: "level5";
                PropertyChanges {target: rect4; y: level5_y; opacity: level5_opacity}
            }
        ]

        property alias rectText: context4.text
        Behavior on y {NumberAnimation{duration: 300}}
        Behavior on opacity {NumberAnimation{duration: 100}}

        Text{
            id: context4
            anchors.centerIn: parent
            color: "white"
            text: rect4.rectText
        }
    }

    Rectangle{
        id: rect5
        y: 0
        width: rect_width; height: rect_height
        color: "transparent"
        state: "level5"
        states: [
            State {
                name: "level0";
                PropertyChanges {target: rect5; y: level0_y; opacity: level0_opacity}
            },
            State {
                name: "level1";
                PropertyChanges {target: rect5; y: level1_y; opacity: level1_opacity}
            },
            State {
                name: "level2";
                PropertyChanges {target: rect5; y: level2_y; opacity: level2_opacity}
            },
            State {
                name: "level3";
                PropertyChanges {target: rect5; y: level3_y; opacity: level3_opacity}
            },
            State {
                name: "level4";
                PropertyChanges {target: rect5; y: level4_y; opacity: level4_opacity}
            },
            State {
                name: "level5";
                PropertyChanges {target: rect5; y: level5_y; opacity: level5_opacity}
            }
        ]

        property alias rectText: context5.text
        Behavior on y {NumberAnimation{duration: 300}}
        Behavior on opacity {NumberAnimation{duration: 100}}

        Text{
            id: context5
            anchors.centerIn: parent
            color: "white"
            text: rect5.rectText
        }
    }
}
