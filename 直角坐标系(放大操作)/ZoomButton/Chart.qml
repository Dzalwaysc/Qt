/********************************************************************
** 放大操作在is_zoom为true的时候开始
** 绘制矩形在is_choice为true时开始
** 放大处理函数, 过程:
        1.鼠标按下得到起始点originx、originy
        2.鼠标拖动绘制矩形
        3.鼠标放开，区域矩形消失，图像更新位置
                  放大后矩形左上角x值为绘制矩形过程中初始点和终止点中最大的x点值
                  放大后矩形左上角y值为绘制矩形过程中初始点和终止点中最大的y点值
                  绘制的矩形宽为绘制矩形过程中初始点和终止点x差值的绝对值
                  绘制的矩形高为绘制矩形过程中初始点和终止点y差值的绝对值
********************************************************************/

import QtQuick 2.9
import QtCharts 2.0
import QtQuick.Controls 2.4


Item{
    id: myChart
    width: 300; height: 300
    // 判断是否为zoom模式
    property bool is_zoom: false

    // 坐标轴内的值
    property real originx: 0
    property real originy: 0
    property real currentx: 0
    property real currenty: 0

    // 建立直角坐标系
    ChartView{
        id: chartView
        anchors.fill: parent
        anchors.centerIn: parent
        antialiasing: true   // 是否抗锯齿

        // 坐标轴
        ValueAxis { id: axisX; min: 0; max: 100 }  // x轴
        ValueAxis { id: axisY; min: 0; max: 100 }  // y轴

        // 线段
        LineSeries{
            id: series; axisX: axisX; axisY: axisY
            XYPoint { x:10; y: 10}
            XYPoint { x:90; y: 90}
        }
    }

    // 鼠标响应区域
    MouseArea{
        id: itemMouseArea
        anchors.fill: parent
        anchors.centerIn: parent
        hoverEnabled: true  // 鼠标放在鼠标区域上是否能响应

        signal zoomDone
        signal zoomBegin
        signal zoomCurrent

        onEntered: {
            if(myChart.is_zoom){
                cursorShape = Qt.CrossCursor
            }else{
                cursorShape = Qt.ArrowCursor
            }
        }

        onPressed: {
            // 开始zoomIn， 这一步选取zoomIn的起始点
            if(myChart.is_zoom){
                originx = mouseX;
                originy = mouseY;
                zoomBegin(); // send signal to zoomArea
            }
        }

        onPositionChanged: {
            // zoomIn过程，这一步绘制zoomIn的区域矩形
            if(myChart.is_zoom){
                zoomCurrent();
            }
        }

        onReleased: {
            // 结束zoomIn，区域矩形消失，图像更新位置
            if(myChart.is_zoom){
                var finalarea = Qt.rect(mouseX > originx ? originx : mouseX,
                                    mouseY > originy ? originy : mouseX,
                                    Math.abs(mouseX - originx),
                                    Math.abs(mouseX - originy));;
                chartView.zoomIn(finalarea);
                zoomDone();
            }

        }

        onWheel: {
            if(wheel.angleDelta.y > 0)
                chartView.zoom(1.01);
            else if(wheel.angleDelta.y < 0)
                chartView.zoom(0.99);
        }

    }

    Rectangle{
        id: zoomArea;
        color: "white"

        radius: 5             //此属性保留用于绘制圆角矩形的角半径。
        border.color: "black"

        property real left_topx: originx > itemMouseArea.mouseX ? itemMouseArea.mouseX : originx
        property real left_topy: originy > itemMouseArea.mouseY ? itemMouseArea.mouseY : originy
        property real area_width: Math.abs(itemMouseArea.mouseX - originx)
        property real area_height: Math.abs(itemMouseArea.mouseY - originy)
        property bool is_choice: false

        Connections{
            target: itemMouseArea

            // 收到放大开始信号，使is_choice为真，绘制开始
            onZoomBegin:{
                zoomArea.is_choice = true;
            }

            onZoomCurrent:{
                if(zoomArea.is_choice){
                    zoomArea.x = zoomArea.left_topx;
                    zoomArea.y = zoomArea.left_topy;
                    zoomArea.width = zoomArea.area_width;
                    zoomArea.height = zoomArea.area_height;
                }
                else{
                    zoomArea.x = zoomArea.left_topx;
                    zoomArea.y = zoomArea.left_topy;
                    zoomArea.width = 0;
                    zoomArea.height = 0;
                }
            }

            // 收到放大结束信号，is_choice为false，绘制结束
            onZoomDone: {
                zoomArea.x = zoomArea.left_topx;
                zoomArea.y = zoomArea.left_topy;
                zoomArea.width = 0;
                zoomArea.height = 0;
                zoomArea.is_choice = false;
            }
        }
    }
}
