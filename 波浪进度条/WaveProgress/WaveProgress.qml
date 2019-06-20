import QtQuick 2.7
import QtQuick.Controls 2.0

Item {

    // range信息
    property int rangeValue: 66
    property int nowRange: 66

    // 画布
    property int mW: 80
    property int mH: 80
    property int lineWidth: 1

    // Sin曲线
    property int sX: 0
    property int sY: mH / 2
    property int axisLength: mW;       // 轴长
    property double waveWidth: 0.015   // 波浪宽度，数越小越宽
    property double waveHeight: 1      // 波浪高度，数越大越高
    property double speed: 0.09        // 波浪速度，数越大速度越快
    property double xOffset: 0         // 波浪x偏移量

    Canvas{
        id: canvas
        height: mH
        width: mW
        anchors.centerIn: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.lineWidth = lineWidth

            // 画油箱
            var IsdrawTanked = false;
            var drawTank = function(){
                var r = 5; //圆弧半径
                ctx.strokeStyle = '#1080d0'; // 线条颜色
                // 外圈
                var ptA_x = lineWidth; var ptA_y = lineWidth;           // 起始点 左上角A
                var ptB_x = lineWidth; var ptB_y = mH - lineWidth;      // 左下角B
                var ptC_x = mW - lineWidth; var ptC_y = mH - lineWidth; // 右下角C
                var ptD_x = mW - lineWidth; var ptD_y = lineWidth;      // 右下角D
                ctx.beginPath();
                ctx.moveTo(ptA_x, ptA_y);
                ctx.arcTo(ptB_x, ptB_y, ptC_x, ptC_y, r);
                ctx.lineTo(ptC_x - r, ptC_y);
                ctx.arcTo(ptC_x, ptC_y, ptD_x , ptD_y, r);
                ctx.lineTo(ptD_x, ptD_y);
                ctx.stroke();

                // 内圈
                ctx.beginPath();
                var d = 2;
                var inter_r = 5
                ptA_x = ptA_x + d; ptA_y = ptA_y;
                ptB_x = ptB_x + d; ptB_y = ptB_y - d;
                ptC_x = ptC_x - d; ptC_y = ptC_y - d;
                ptD_x = ptD_x - d; ptD_y = ptD_y;
                ctx.moveTo(ptA_x, ptA_y);
                ctx.arcTo(ptB_x, ptB_y, ptC_x, ptC_y, inter_r);
                ctx.lineTo(ptC_x - inter_r, ptC_y);
                ctx.arcTo(ptC_x, ptC_y, ptD_x, ptD_y, inter_r);
                ctx.lineTo(ptD_x, ptD_y);
                ctx.stroke();
                ctx.clip();

            }
            var drawCirc = function(){
                var r = mH/2;
                var cR = r - 8*lineWidth
                ctx.beginPath();
                ctx.arc(r, r, cR+1, 90*Math.PI/180, 2*Math.PI);
                ctx.stroke();
                ctx.beginPath();
                ctx.arc(r, r, cR, 90*Math.PI/180, 2*Math.PI);
                ctx.clip();
            }

            // 显示sin曲线
            var drawSin = function(xOffset){
                ctx.save();
                var points = [];
                ctx.strokeStyle = "red";
                ctx.fillStyle = Qt.lighter('#1080d0');
                ctx.beginPath();
                for(var x = sX; x < sX + axisLength; x += 20 / axisLength){
                    var y = - Math.sin((sX + x) * waveWidth + xOffset);
                    var dY = mH * (1 - nowRange / 100);
                    points.push([x, dY + y * waveHeight]);
                    ctx.lineTo(x, dY + y * waveHeight);
                }

                // 封闭路径
                ctx.lineTo(axisLength, mH);
                ctx.lineTo(sX, mH);
                ctx.lineTo(points[0][0], points[0][1]);
                ctx.stroke();
                ctx.fill()
                ctx.restore();
            }

            // 显示百分数
            var drawText = function(){
                ctx.save();
                var size = 0.38*mW;
                ctx.font = size + 'px Monaco';
                ctx.textAlign = 'center';
                ctx.fillStyle = "rgba(14, 80, 14, 0.8)";
                ctx.fillText(~~nowRange + '%', mW/2, mW/2 + size / 2);

                ctx.restore();
            }

            // 加入渲染
            var render = function(){
                ctx.clearRect(0, 0, mW, mH);
                if(IsdrawTanked == false){
                    drawTank();
                    //drawCirc();
                }


                drawSin(xOffset);
                drawText();

                xOffset += speed;
                requestAnimationFrame(render);
            }
            render();
        }

    }

}
