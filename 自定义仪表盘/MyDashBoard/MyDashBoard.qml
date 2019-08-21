import QtQuick 2.0

Item{
    id: myDashBoard
    property int mW: 200        // 画布宽度
    property int mH: 200        // 画布高度
    property int lineWidth: 2   //画图的线宽
    property double center: mW/2     // 圆心

    property int tickMarkSize: 20
    property int minortickMarkSize: 10

    property string fontfamily: "monaco"

    property int radius: 8      // 中心圆半径
    property int pLength: 100    // 指针长度
    property int pAngle: 40     // 指针夹角度数

    property real currentValue: 0   // 指针当前值对外接口

    Canvas{
        id: myCanvas
        width: mW
        height: mH
        anchors.centerIn: parent
        onPaint: {
            var ctx = getContext("2d");
            // 求圆上任意一点的坐标，已知圆的半径，圆心坐标，以及对应的角度
            var getCircCorrdinate = function(radius, x, y, angle){
                var point = [];
                var ptX = x + radius * Math.cos( angle*Math.PI/180);
                var ptY = y + radius * Math.sin( angle*Math.PI/180);
                point.push(ptX);
                point.push(ptY);
                return point;
            }

            // 绘制圆圈
            var ifCirc = false;
            var drawCirc = function(){
                ctx.lineWidth = 2;
                ctx.strokeStyle = "white";
                ctx.beginPath();
                ctx.arc(center, center, center-lineWidth, 5/6*Math.PI, 13/6*Math.PI);
                ctx.stroke();
                ctx.restore();
            }

            // 绘制游标
            var drawLabel = function(){
                for(var i=0; i<21; i++){
                    ctx.save();
                    ctx.translate(center, center); // 转换坐标原点至圆心
                    ctx.rotate((i+20)*12*Math.PI/180);

                    ctx.beginPath();
                    if(i%2 != 0){
                        ctx.lineWidth = 3;
                        ctx.moveTo(0, -mW/2 + lineWidth+3);
                        ctx.lineTo(0, -mW/2 + minortickMarkSize);
                    }else{
                        ctx.lineWidth = 1;
                        ctx.fillStyle = "white";
                        ctx.moveTo(-3, -mW/2 + lineWidth-4);
                        ctx.lineTo(-1, -mW/2 + tickMarkSize);
                        ctx.lineTo(1, -mW/2 + tickMarkSize);
                        ctx.lineTo(3, -mW/2 + lineWidth-4);
                        ctx.lineTo(-3, -mW/2 + lineWidth-4);
                        ctx.fill();
                    }
                    ctx.stroke();
                    ctx.restore();
                }
            }

            // 绘制指针，初始指针指向0
            var drawPointer = function(currentValue){
                ctx.save();
                ctx.translate(center, center); // 转换坐标原点至圆心
                ctx.rotate((150 + currentValue *12)*Math.PI/180);   // 调整角度使指针指向0
                ctx.beginPath();
                ctx.fillStyle = "#FB2E06";
                var point1 = getCircCorrdinate(radius, 0, 0, pAngle);
                var point2 = [pLength, 0];
                ctx.moveTo(point1[0], point1[1]);
                ctx.arc(0, 0, radius, pAngle*Math.PI/180, -pAngle*Math.PI/180);
                ctx.lineTo(point2[0], point2[1]);
                ctx.lineTo(point1[0], point1[1]);
                ctx.fill();
                ctx.closePath();
                ctx.restore();
            }

            // 绘制中心圆
            var drawWholePointer = function(){
                ctx.save();
                ctx.beginPath();
                ctx.translate(center, center); // 转换坐标原点至圆心
                var rGra = ctx.createRadialGradient(0, 0, radius*0, 0, 0, radius * 1.5);
                rGra.addColorStop(0, "#464B41");
                rGra.addColorStop(1, "#2B2E22");
                ctx.fillStyle = rGra;
                ctx.arc(0, 0, radius * 1.5, 0, Math.PI*2, false);
                ctx.fill();
                ctx.restore();
            }

            var render = function(){
                ctx.clearRect(0, 0, mW, mH);
                if(ifCirc === false){
                    drawCirc();
                    drawLabel();
                    drawPointer(0);
                    drawWholePointer();
                }
                requestAnimationFrame(render);
            }
            render();
        }

        // 绘制标签
        Text {
            id: lable0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -95
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 65
            color: "white"
            font.family: fontfamily
            font.pixelSize: mW*0.1
            text: qsTr("0")
        }
        Text {
            id: lable1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -65
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -20
            color: "white"
            font.family: fontfamily
            font.pixelSize: mW*0.1
            text: qsTr("1")
        }
        Text {
            id: lable2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -30
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -60
            color: "white"
            font.family: fontfamily
            font.pixelSize: mW*0.1
            text: qsTr("2")
        }
        Text {
            id: lable3
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -60
            color: "white"
            font.family: fontfamily
            font.pixelSize: mW*0.1
            text: qsTr("3")
        }
        Text {
            id: lable4
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 65
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -20
            color: "white"
            font.family: fontfamily
            font.pixelSize: mW*0.1
            text: qsTr("4")
        }
        Text {
            id: lable5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 95
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 65
            color: "white"
            font.family: fontfamily
            font.pixelSize: mW*0.1
            text: qsTr("5")
        }
        Text {
            id: unitLable
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -35
            color: "white"
            font.family: fontfamily
            font.pixelSize: mW*0.05
            text: qsTr("R . P . M" + "\n" + " x . 1000")
        }
    }

    onCurrentValueChanged: {
        myCanvas.requestPaint()
    }
}
