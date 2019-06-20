/********************************************************************
** 拖动操作在isDrag为true的时候开始
** 每隔100ms 进行一次拖动操作       间隔时间通过dragTimer设置
**
** 拖动处理函数, 过程:
** 1.首先鼠标按压下 -> 我们得到起始点  oX和oY
** 2.然后鼠标移动 -> 我们得到终止点   cX和cY
** 3.坐标轴移动距离即为  cX-oX 和 cY-oY
**            为了让这个过程看起来更加流畅，这里对缩小移动距离，即乘上了0.8
**            为了让这个过程不那么敏感，给定一个无效范围(-0.2, 0.2)
** 4.结束一次拖动，将cX和cY赋值给oX和oY，即下一次拖动的原点为当前拖动的终止点

********************************************************************/

import QtQuick 2.9
import QtCharts 2.0
import QtQuick.Controls 2.4

Item{
    id: chartDrag

    property bool isDrag: false  // 判断是否为拖动模式
    // 鼠标最开始的位置,即在拖动模式下,第一次点击时的位置
    property double oX
    property double oY
    // 鼠标当前的位置，即在拖动模式下，鼠标实时的位置
    property double cX
    property double cY

    // 拖动处理函数
    function dragScroll(){
        var move_x = cX - oX;
        var move_y = cY - oY;
        move_y *= 0.8;
        move_x *= 0.8;

        if(move_y > 0.2) chartView.scrollUp(Math.abs(move_y));
        else if(move_y < -0.2) chartView.scrollDown(Math.abs(move_y));
        if(move_x > 0.2) chartView.scrollLeft(Math.abs(move_x));
        else if(move_x < -0.2) chartView.scrollRight(Math.abs(move_x));
        oX = cX; oY = cY;
    }

    // 建立直角坐标系
    ChartView{
        id: chartView
        anchors.centerIn: parent
        width: 400
        height: 400
        antialiasing: true    // 是否抗锯齿

        // 坐标轴
        ValueAxis { id: axisX; min: 0; max: 100 }  // x轴
        ValueAxis { id: axisY; min: 0; max: 100 }  // y轴

        // 线段
        LineSeries{
            id: series; axisX: axisX; axisY: axisY
            XYPoint { x:10; y: 10}
            XYPoint { x:90; y: 90}
        }

        // 添加鼠标感应
        MouseArea{
            id: mouse
            anchors.fill: parent
            hoverEnabled: true  // 鼠标放在鼠标区域上是否能响应

            onEntered: {
                if(chartDrag.isDrag) cursorShape = Qt.OpenHandCursor
                else cursorShape = Qt.ArrowCursor
            }

            onPressed: {
                if(chartDrag.isDrag){
                    cursorShape = Qt.ClosedHandCursor;

                    // 定位鼠标点下的那一瞬间，鼠标的坐标
                    oX = mouseX;
                    oY = mouseY;
                    dragTimer.start();
                }
            }

            onPositionChanged: {
                if(chartDrag.isDrag){
                    cX = mouseX;
                    cY = mouseY;
                }
            }

            onReleased: {
                if(chartDrag.isDrag){
                    cursorShape = Qt.OpenHandCursor;
                    dragTimer.stop();
                }
            }
        }

        // 在定时器中(再开一个线程)进行拖动操作
        // 若直接在GUI线程中直接进行这一系列的操作，画面感觉将十分不流畅
        Timer{
            id: dragTimer
            // interval 时间间隔
            // repeat如果为true 则定时器设置的操作，否则只执行一次
            interval: 100; running: false; repeat: true
            onTriggered: dragScroll()
        }
    }
}
