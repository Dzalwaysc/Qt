/****************************************************************************
**这是chart主体
**因为qt chart使用qt图形视图框架进行绘图
**在main.cpp中所有的QGuiApplication必须替换为QApplication。
**我们需要在.pro文件中添加：QT += widgets以使用Qapplication

    1.zoom放大
**使用鼠标单击并释放来选择要放大的区域
**使用鼠标双击缩放重置
**使用鼠标滚轮缩放

** 放大操作在is_zoom为true的时候开始
** 绘制矩形在is_choice为true时开始
** 放大处理函数, 过程:
        1）.鼠标按下得到起始点originx、originy
        2）.鼠标拖动绘制矩形
        3）.鼠标放开，区域矩形消失，图像更新位置
                  放大后矩形左上角x值为绘制矩形过程中初始点和终止点中最大的x点值
                  放大后矩形左上角y值为绘制矩形过程中初始点和终止点中最大的y点值
                  绘制的矩形宽为绘制矩形过程中初始点和终止点x差值的绝对值
                  绘制的矩形高为绘制矩形过程中初始点和终止点y差值的绝对值

    2.drag 拖动操作
** 拖动操作在isDrag为true的时候开始
** 每隔100ms 进行一次拖动操作       间隔时间通过dragTimer设置
         拖动处理函数, 过程:
             1）.首先鼠标按压下 -> 我们得到起始点  oX和oY
             2）.然后鼠标移动 -> 我们得到终止点   cX和cY
             3）.坐标轴移动距离即为  cX-oX 和 cY-oY
                        为了让这个过程看起来更加流畅，这里对缩小移动距离，即乘上了0.8
                        为了让这个过程不那么敏感，给定一个无效范围(-0.2, 0.2)
             4）.结束一次拖动，将cX和cY赋值给oX和oY，即下一次拖动的原点为当前拖动的终止点

    3.图标
        zoom 十字架
        drag 手
        groundstation 手指尖
        其他 箭头
        Menu定义右击两种菜单
****************************************************************************/

import QtQuick 2.9
import QtCharts 2.0
import QtQuick.Controls 2.4

Item{
    id: item
    width: 500
    height: 500
    x: 5; y: 100
    z:-1
    clip: true

    property string fontfamily: "Monaco"
    property real fontpixelSize: 10            //字体大小

    // 坐标轴属性
    property real axisX_min: 0
    property real axisX_max: 500
    property real axisY_min: 0
    property real axisY_max: 500

    // 控制MouseArea的功能
    property bool is_rotation: false

    // 将path暴露给外部使用
    property alias chartView: chartView
    property alias pathSeries: pathSeries
    property alias itemMouseArea: itemMouseArea
    property alias pointArray: pointArray
    property alias rect: rect

    // 当鼠标移到chart区域时，才显示operationBar，因此这里给出鼠标移到chart区域的信号
    signal mouseEnterChart()
    signal mouseExitChart()


    ChartView{
        id: chartView
        anchors.fill: parent
        anchors.centerIn: parent
        antialiasing: true       //是否抗锯齿
        legend.visible: false
        backgroundColor: "transparent" //Qt.rgba(0, 22, 255, 0.1)

        // margin between chart rectangle and the plot area
        margins.top: 0
        margins.left: 0
        margins.bottom: 0
        margins.right: 0

        ValueAxis{
            id: axisX
            min: axisX_min
            max: axisX_max
            lineVisible: false
            labelsVisible: true
            gridVisible: true
            labelsColor: "red"
            labelsFont.family: fontfamily
            labelsFont.pixelSize: fontpixelSize
        }

        ValueAxis{
            id: axisY
            min: axisY_min
            max: axisY_max
            lineVisible: false
            labelsVisible: true
            gridVisible: true
            labelsColor: "red"
            labelsFont.family: fontfamily
            labelsFont.pixelSize: fontpixelSize
        }


        // 实际航线
        LineSeries{
            id: pathSeries
            axisX: axisX
            axisY: axisY
            useOpenGL: true // 使chart再增加点的时候更加流畅
        }

        Rectangle{
            id: rect
            property real valueX: 100
            property real valueY: 100
            rotation: 0
            width: 20; height: 20
            color: "red"
            Component.onCompleted: {
                var ps = chartView.mapToPosition(Qt.point(100, 100), pathSeries);
                x = ps.x;
                y = ps.y;
            }
        }
    }

    Text {
        id: valueText
        property real ef_x // 大地坐标系的x
        property real ef_y // 大地坐标系的y

        // 这里如果我们是顺时针旋转的化，这里应该进行逆时针计算
        property real bf_x: (ef_x-rect.valueX)*Math.cos(a) - (ef_y-rect.valueY)*Math.sin(a)  // 随体坐标系的x
        property real bf_y: (ef_y-rect.valueY)*Math.cos(a) + (ef_x-rect.valueX)*Math.sin(a) // 随体坐标系的y
        property real a: rect.rotation*Math.PI/180

        property bool isBodyFrame: false
        opacity: 0                // opacity在 onEntered中被改成1
        color: "green"           //不透明度
        x: itemMouseArea.mouseX + 5; y: itemMouseArea.mouseY - 10
        text:  isBodyFrame == true ? toEarthFrame() : toBodyFrame()
        font.family: fontfamily
        font.pixelSize: fontpixelSize

        function toEarthFrame(){
            return ef_x.toFixed(1) + ", " + ef_y.toFixed(1);
        }

        function toBodyFrame(){
            return bf_x.toFixed(1) + ", " + bf_y.toFixed(1);
        }
    }

    MouseArea{
        id: itemMouseArea
        anchors.fill: parent
        anchors.centerIn: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        signal groundStationCurrent

        onEntered: {
            item.mouseEnterChart()
            valueText.opacity = 1
        }

        onExited: {
            item.mouseExitChart()
            valueText.opacity = 0
        }

        onPositionChanged: {
            // 坐标文字
            valueText.ef_x = chartView.mapToValue(Qt.point(mouseX, mouseY)).x.toFixed(1);
            valueText.ef_y = chartView.mapToValue(Qt.point(mouseX, mouseY)).y.toFixed(1);
        }

        onClicked: {
            console.log(chartView.mapToPosition(Qt.point(0, 0))); // 用来定位零点位置
        }

        onDoubleClicked: item.resetChart()

    }

    // 用来更新rect的位姿
    function updateObject(valueX, valueY, angle) {
        var point_posiont = chartView.mapToPosition(Qt.point(valueX, valueY), pathSeries);
        rect.x = point_posiont.x;
        rect.y = point_posiont.y;
        rect.rotation = angle;
    }

    Item{
        id: pointArray
        property var array: new Array
        property var component: Qt.createComponent("TargetPointModel.qml")

        // 用来制造点 // 输入固定坐标系的x和y
        function createPoint(valueX, valueY){
            if(component.status === Component.Ready){
                var ps = chartView.mapToPosition(Qt.point(valueX, valueY), pathSeries);
                var obj = component.createObject(chartView,
                                {x: ps.x, earthFrame_valueX: valueX,
                                 y: ps.y, earthFrame_valueY: valueY});
                array.push(obj);
            }
        }

        // 移除点  // 输入点的位置
        function removePoint(index){
            array[index].destroy();
            var removeItem = array.splice(index, 1);
        }

        // 将每一个期望目标点从大地坐标系转到随体坐标系
        function frameTrans(){
            var pointNum = array.length;
            for(var i=0; i<pointNum; i++){
                array[i].bodyFrame_valueX = array[i].earthFrame_valueX - rect.valueX;
                array[i].bodyFrame_valueY = array[i].earthFrame_valueY - rect.valueY;
                array[i].isEarthFrame = false;
            }
        }

        // 旋转点
        function rotationPoint(bodyFrame_rotation){
            var a = bodyFrame_rotation*Math.PI/180;
            var pointNum = array.length;
            for(var i=0; i<pointNum; i++){
                var eX = array[i].earthFrame_valueX;
                var eY = array[i].earthFrame_valueY;
                var neX = (eX-rect.valueX)*Math.cos(a)
                                           + (eY-rect.valueY)*Math.sin(a) + rect.valueX;
                var neY = (eY-rect.valueY)*Math.cos(a)
                                           - (eX-rect.valueX)*Math.sin(a) + rect.valueY;
                array[i].earthFrame_valueX = neX;
                array[i].earthFrame_valueY = neY;
                var ps = chartView.mapToPosition(Qt.point(neX, neY), pathSeries);
                array[i].x = ps.x; array[i].y = ps.y;
            }
        }

    }

}
