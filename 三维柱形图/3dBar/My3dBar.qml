/***********************************************************
Bars3D控件自带的鼠标响应: 右键移动鼠标，可旋转

这里我写4个Bar3DSeries 而不是写一个Bar3DSeries包含4个ListElement
    原因是我想4个Bar的颜色不同

这里不用Bar3DSeries自带的Label(可在Theme3D设置)，而是自己写了个Text作为label
    原因是Bar3DSeries自带的Label在图形比较小的时候不是很清晰

自定义的Label算法大概花了我3天的时间，是有点靠瞎蒙的
  这个算法可以这样理解: 考虑极限情况，即xRotation: 0 -> 90 -> 180
                                  yRotation: 0 -> 90
  看看会出现什么偏置，然后用三角函数来变化，比如在yRotation为90的时候，xRotation从0 -> 180 -> -180
  如果是正常的y*rotationY，这个时候y值不改变，然而实际情况是y会随着xRotation改变
  所以我们先考虑x*sin(rotationY)，即在rotationY=0的时候，rotationX不影响y，当rotationY=90的时候，x完全影响y
  然后有x*sin(rotationY)*sin(rotationX)，即此时y值是a*sin(rotationX)
                                           其中a=x*sin(rotationY)
************************************************************/

import QtQuick 2.0
import QtDataVisualization 1.2
Item {
    width: 300
    height: 300
    x: 50
    y: 100
    z:1

    property double cameraRotationX: 0 // 初始的相机旋转角度
    property double cameraRotationY: 0 // 初始的相机旋转角度
    property alias dataModel_1: dataModel_1
    property alias dataModel_2: dataModel_2
    property alias dataModel_3: dataModel_3
    property alias dataModel_4: dataModel_4

    property string color_velocity: "#74F4B8"
    property string color_course: "#63635E"
    property string color_cte: "#EA74F5"
    property string color_distance: "#F5F574"
    property string color_high: "blue"

    property real fontpixelSize: 13

    // 主体
    ThemeColor{
        id: color1
        color: color_velocity
    }
    ThemeColor{
        id: color2
        color: color_course
    }
    ThemeColor{
        id: color3
        color: color_cte
    }
    ThemeColor{
        id: color4
        color: color_distance
    }

    Theme3D{
        id: dynamicColorTheme
        type: Theme3D.ThemeEbony
        baseColors: [color1,color2,color3,color4]
        backgroundColor: Qt.hsla(230, 0.64, 0.06, 1)
        windowColor: Qt.hsla(230, 0.64, 0.06, 1) // 应用窗口的背景颜色
        labelBorderEnabled: false
        labelBackgroundColor: "transparent"
        labelTextColor: "transparent"
        gridEnabled: false
        font.pointSize: 50
    }

    // 值大小
    ValueAxis3D{
        id: valueAxis
        min: 0
        max: 100
    }

    // 主体
    Bars3D {
        id: bar3D
        width: parent.width
        height: parent.height
        theme: dynamicColorTheme
        scene.activeCamera.xRotation: cameraRotationX
        scene.activeCamera.yRotation: cameraRotationY
        scene.activeCamera.zoomLevel: 150
        valueAxis: valueAxis
        barThickness: 5
        barSpacing: Qt.size(0.5,0.5)
        Bar3DSeries {
            id: barSer
            itemLabelFormat: "@colLabel, @rowLabel: @valueLabel"
            ItemModelBarDataProxy {
                itemModel: dataModel_1
                rowRole: "rowLabel"
                columnRole: "columnLabel"
                valueRole: "expense"
            }
        }

        Bar3DSeries {
            itemLabelFormat: "@colLabel, @rowLabel: @valueLabel"
            ItemModelBarDataProxy {
                itemModel: dataModel_2
                rowRole: "rowLabel"
                columnRole: "columnLabel"
                valueRole: "expense"
            }
        }
        Bar3DSeries {
            itemLabelFormat: "@colLabel, @rowLabel: @valueLabel"
            ItemModelBarDataProxy {
                itemModel: dataModel_3
                rowRole: "rowLabel"
                columnRole: "columnLabel"
                valueRole: "expense"
            }
        }
        Bar3DSeries {
            itemLabelFormat: "@colLabel, @rowLabel: @valueLabel"
            ItemModelBarDataProxy {
                itemModel: dataModel_4
                rowRole: "rowLabel"
                columnRole: "columnLabel"
                valueRole: "expense"
            }
        }
    }

    // 数字ListModel
    ListModel {
        id: dataModel_1
        ListElement{ columnLabel: "速度偏差"; rowLabel: "值";    expenses: 30}
    }

    ListModel {
        id: dataModel_2
        ListElement{ columnLabel: "艏向偏差"; rowLabel: "值";    expenses: 10}
    }

    ListModel {
        id: dataModel_3
        ListElement{ columnLabel: "横侧偏差"; rowLabel: "值";    expenses: 40}
    }

    ListModel {
        id: dataModel_4
        ListElement{ columnLabel: "目标距离"; rowLabel: "值";    expenses: 50}
    }

    // 旋转区域
    Rectangle{
        id: mouseArea
        x:42; y:44;
        width: 215; height: 106
        border.color: "transparent"
        color: "transparent"

        property double lastX
        property double lastY
        property double currentX
        property double currentY

        MouseArea{
            property bool isCameraRotation: false
            anchors.fill: parent
            onDoubleClicked: {
                bar3D.scene.activeCamera.xRotation = 0
                bar3D.scene.activeCamera.yRotation = 0
                color1.color = color_velocity
                color2.color = color_course
                color3.color = color_cte
                color4.color = color_distance
            }
        }
    }

    // 图例1
    Rectangle{
        id: box_1
        x: 270; y: 40
        width: 150; height: 20
        color: "transparent"; border.color: "white"

        SequentialAnimation{
            id: animation1
            running: false
            NumberAnimation{
                target: box_1; property: "scale"
                from:1; to:0.8; duration: 100;
            }
            NumberAnimation{
                target: box_1; property: "scale"
                from:0.8; to:1; duration: 100
            }
        }

        // 图例
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 22
            anchors.bottom: parent.bottom
            color: "white"
            text: "速度偏差: " + "米/秒"
            font.family: "Monaco"
            font.pixelSize: fontpixelSize
        }

        Rectangle{
            width: 15; height: 15
            color: color_velocity
            anchors.left: parent.left
            anchors.leftMargin: 2.5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2.5
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                animation1.start()
                color2.color = color_course
                color3.color = color_cte
                color4.color = color_distance
                if(color1.color != color_high)
                    color1.color = color_high;
            }
        }
    }

    // 图例2
    Rectangle{
        id: box_2
        x: 270; y: 70
        width: 150; height: 20
        color: "transparent"; border.color: "white"

        SequentialAnimation{
            id: animation2
            running: false
            NumberAnimation{
                target: box_2; property: "scale"
                from:1; to:0.8; duration: 100;
            }
            NumberAnimation{
                target: box_2; property: "scale"
                from:0.8; to:1; duration: 100
            }
        }


        Text {
            anchors.left: parent.left
            anchors.leftMargin: 22
            anchors.bottom: parent.bottom
            color: "white"
            text: "艏向偏差: " + "度"
            font.family: "Monaco"
            font.pixelSize: fontpixelSize
        }

        Rectangle{
            width: 15; height: 15
            color: color_course
            anchors.left: parent.left
            anchors.leftMargin: 2.5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2.5
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                animation2.start()
                color3.color = color_cte
                color4.color = color_distance
                color1.color = color_velocity;
                if(color2.color != color_high)
                    color2.color = color_high
            }
        }
    }

    // 图例3
    Rectangle{
        id: box_3
        x: 270; y: 100
        width: 150; height: 20
        color: "transparent"; border.color: "white"

        SequentialAnimation{
            id: animation3
            running: false
            NumberAnimation{
                target: box_3; property: "scale"
                from:1; to:0.8; duration: 100;
            }
            NumberAnimation{
                target: box_3; property: "scale"
                from:0.8; to:1; duration: 100
            }
        }


        Text {
            anchors.left: parent.left
            anchors.leftMargin: 22
            anchors.bottom: parent.bottom
            color: "white"
            text: "横侧偏差: " + "米"
            font.family: "Monaco"
            font.pixelSize: fontpixelSize
        }

        Rectangle{
            width: 15; height: 15
            color: color_cte
            anchors.left: parent.left
            anchors.leftMargin: 2.5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2.5
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                animation3.start()
                color1.color = color_velocity;
                color2.color = color_course;
                color4.color = color_distance;
                if(color3.color != color_high)
                    color3.color = color_high;
            }
        }
    }

    // 图例4
    Rectangle{
        id: box_4
        x: 270; y: 130
        width: 150; height: 20
        color: "transparent"; border.color: "white"

        SequentialAnimation{
            id: animation4
            running: false
            NumberAnimation{
                target: box_4; property: "scale"
                from:1; to:0.8; duration: 100;
            }
            NumberAnimation{
                target: box_4; property: "scale"
                from:0.8; to:1; duration: 100
            }
        }


        Text {
            anchors.left: parent.left
            anchors.leftMargin: 22
            anchors.bottom: parent.bottom
            color: "white"
            text: "目标距离: " + "米"
            font.family: "Monaco"
            font.pixelSize: fontpixelSize
        }

        Rectangle{
            width: 15; height: 15
            color: color_distance
            anchors.left: parent.left
            anchors.leftMargin: 2.5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2.5
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                animation4.start()
                color1.color = color_velocity;
                color2.color = color_course;
                color3.color = color_cte;
                if(color4.color != color_high)
                    color4.color = color_high;
            }
        }
    }



    // 旋转
    // 1. 求得x旋转半径为 x_offset
    // 2. 求得x旋转后的x坐标，x_offset * cos(rotationX)
    // 3. 求得y旋转半径，y_offset
    // 4. 求得y旋转后的y坐标，y_offset * cos(rotationY)

    // 旋转的时候产生的偏置
    // 1. x值: 0.3*bar*sin(rotationY)*cos(rotationX) -> 旁边的阴影产生的偏置
    //     系数0.3  =>  在barValue为100的时候，rotationX=0, rotationY 从0到90度，发现x应该偏置30

    // 2. y值: rotationX造成柱体变高偏置 0.4 * bar * sin(rotationX) * cos(rotationY)
    //     当rotationY为0的时候，rotationX从0到90，变高0.4*bar的值
    //     当rotationY为90的时候，不存在变高偏置

    // 3. y值: 0.3 * barValue * sin(rotationX) -> 右边的阴影产生的偏置
    //        在rotationY为90的时候，rotationX为0，阴影不对其造成影响，rotationX为90的时候，偏置需加上30

    // 4. y值: x_offset*sin(rotationY)*sin(rotationX) -> x值对y值造成的偏置
    //     当rotationY为0的时候，进行rotationX时，忽略其他偏置，y值不做改变，即y_offset*cos(rotationY)正确
    //     当rotationY为90的时候，进行rotationX时，即为2维圆移动，此时y值应该为x_offset*sin(rotationX)


    // 进一步解释
    // 1. x值：柱状图右侧阴影在y旋转过程中，产生的偏置 0.3 * bar * sin(rotationY) * cos(rotationX)
    //               系数0.3  => 在barValue为100的时候，rotationX=0, rotationY 从0到90度，发现x应该偏置30。
    //               0.3 * bar *cos(rotationX) => 柱状图右侧阴影在xoz面的投影
    //               0.3 * bar * sin(rotationY) * sin(rotationY) => 柱状图右侧阴影在xoz面的投影在x轴上的投影

    // 字高度: bar在100的时候, y=10 && bar在0的时候, y=130, 即bar每变化1, y反向变化1.2

    property double rotationX: bar3D.scene.activeCamera.xRotation * Math.PI / 180
    property double rotationY: bar3D.scene.activeCamera.yRotation * Math.PI / 180
    Text{
        id: data_1

        property double x_offset: -88
        property double y_offset: - dataModel_1.get(0).expenses * 1.2
        property double barValue: dataModel_1.get(0).expenses

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: x_offset * Math.cos(rotationX)
                                        - 0.3*barValue*Math.sin(rotationY)*Math.cos(rotationX);
        anchors.verticalCenterOffset: y_offset*Math.cos(rotationY)
                                      - 0.4*barValue*Math.sin(rotationX)*Math.cos(rotationY)
                                      + 0.3*barValue*Math.sin(rotationX)
                                      + Math.abs(x_offset) * Math.sin(rotationX) * Math.sin(rotationY)

        text: dataModel_1.get(0).expenses.toFixed(1) + "m/s"
        font.family: "Monaco"
        color: "red"
    }

    Text{
        id: data_2

        property double x_offset: -30
        property double y_offset: - dataModel_2.get(0).expenses * 1.2
        property double barValue: dataModel_2.get(0).expenses

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: x_offset * Math.cos(rotationX)
                                        - 0.1*barValue*Math.sin(rotationY)*Math.cos(rotationX);
        anchors.verticalCenterOffset: y_offset*Math.cos(rotationY)
                                      - 0.2*barValue*Math.sin(rotationX)*Math.cos(rotationY)
                                      + 0.1*barValue*Math.sin(rotationX)
                                      + Math.abs(x_offset) * Math.sin(rotationX) * Math.sin(rotationY)

        text: dataModel_2.get(0).expenses.toFixed(1) + "°"
        font.family: "Monaco"
        color: "red"
    }

    Text{
        id: data_3

        property double x_offset: 30
        property double y_offset: - dataModel_3.get(0).expenses * 1.2
        property double barValue: dataModel_3.get(0).expenses

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: x_offset * Math.cos(rotationX)
                                        + 0.1*barValue*Math.sin(rotationY)*Math.cos(rotationX);
        anchors.verticalCenterOffset: y_offset*Math.cos(rotationY)
                                      + 0.2*barValue*Math.sin(rotationX)*Math.cos(rotationY)
                                      - 0.1*barValue*Math.sin(rotationX)
                                      - Math.abs(x_offset) * Math.sin(rotationX) * Math.sin(rotationY)

        text: dataModel_3.get(0).expenses.toFixed(1) + "m"
        font.family: "Monaco"
        color: "red"
    }

    Text{
        id: data_4

        property double x_offset: 90
        property double y_offset: - dataModel_4.get(0).expenses * 1.2
        property double barValue: dataModel_4.get(0).expenses

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: x_offset * Math.cos(rotationX)
                                        + 0.3*barValue*Math.sin(rotationY)*Math.cos(rotationX);
        anchors.verticalCenterOffset: y_offset*Math.cos(rotationY)
                                      + 0.4*barValue*Math.sin(rotationX)*Math.cos(rotationY)
                                      - 0.3*barValue*Math.sin(rotationX)
                                      - Math.abs(x_offset) * Math.sin(rotationX) * Math.sin(rotationY)

        text: dataModel_4.get(0).expenses.toFixed(1) + "m"
        font.family: "Monaco"
        color: "red"
    }
}
