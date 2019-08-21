import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.2
import QtGraphicalEffects 1.0


Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    color: "black"

    Rectangle{
        id:line
        width: 200
        height: 20
        radius: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        opacity: 1
        color:"transparent"
        border.color: "black"

        property real currentValue: 0

        Glow {
            anchors.fill: line
            radius: 7            //半径决定辉光的柔和度，半径越大辉光的边缘越模糊  样本值=1+半径*2
            samples: 13           //每个像素采集的样本值，值越大，质量越好，渲染越慢
            color: "#ddd"
            source: Rectangle{
                width: 200; height: 20
                radius: 5
                color: "transparent"
                border.color: "white"
            }
            spread: 0.5         //在光源边缘附近增强辉光颜色的大部分
            opacity: line.opacity
        }

        Canvas{
            id: mycanvas
            width: parent.width
            height: parent.height
            onPaint: {
              var ctx = getContext("2d")
              ctx.lineWidth = 16
              ctx.strokeStyle = "#06A7D5"
              ctx.clearRect(0,0,mycanvas.width,mycanvas.height)
              ctx.beginPath()
              ctx.moveTo(100,10)
              ctx.lineTo((line.currentValue + 100),10)
              ctx.stroke()
            }
        }

        onCurrentValueChanged: {
            mycanvas.requestPaint()
        }

        Rectangle{
            id:slide
            height: 20
            width: 20
            x: parent.width/2-slide.width/2
            z: 100
            radius: height/2
            color: "transparent"
            anchors.verticalCenter: parent.verticalCenter

            Image {
                id: slideImage
                height: 50
                width: 50
                anchors.centerIn: parent
                source: "image/button.png"
            }

            MouseArea{
            anchors.fill: parent
            drag.target: slide
            drag.minimumX : 0 - slide.width/2
            drag.maximumX : line.width - slide.width/2

            onPressed: {
                console.log(slide.x)
            }
            onPositionChanged: {
                line.currentValue = slide.x - 90
            }
            onReleased: {
                console.log(line.currentValue)
            }
            }
        }

        //left
        Rectangle{
            id:narrow
            width: 20
            height: 20
            radius: height/2
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: line.left
            anchors.rightMargin: 25
            color:"lightgray"
            Image {
                id: reduceImage
                source: "image/reduce.png"
                anchors.fill: parent
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(slide.x > (0 - slide.width/2)){
                        if((slide.x - line.width/10) < (0 - slide.width/2)){
                            slide.x = (0 - slide.width/2)
                            line.currentValue = slide.x - 90
                        }else{
                            slide.x = slide.x - line.width/10
                            line.currentValue = slide.x - 90
                        }
                    }
                }
            }
        }

        //right
        Rectangle{
            id:expand
            width: 20
            height: 20
            radius: height/2
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: line.right
            anchors.leftMargin: 25
            color:"lightgray"

            Image {
                id: addImage
                source: "image/add.png"
                anchors.fill: parent
            }

            MouseArea{
                anchors.fill: parent

                onClicked: {
                    if(slide.x < (line.width - slide.width/2)){
                        if((slide.x + line.width/10) > (line.width - slide.width/2)){
                            slide.x = (line.width - slide.width/2)
                            line.currentValue = slide.x - 90
                        }else{
                            slide.x = slide.x + line.width/10
                            line.currentValue = slide.x - 90
                        }
                    }
                }
            }
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                slide.x = mouseX - slide.width/2
                line.currentValue = slide.x - 90
            }
        }
    }

    Rectangle{
        x: 20; y: 20
        width: 50; height: 50
        color: "white"
        Text {
            id: myText
            anchors.centerIn: parent
            text: line.currentValue
        }
    }
}
