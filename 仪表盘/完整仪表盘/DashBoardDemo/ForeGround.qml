/*****************************************************
  本文件用来画仪表盘中心的那个圆
  点击红色矩形能够导出图片，格式为.png

  为什么要使用图片形式的圆环:
    采用canvas绘制，发现在打开程序的时候，canvas绘制的对象会延迟出现
    而直接导入图片则能马上就出现

    Canvas中的宽和高随意
*****************************************************/
import QtQuick 2.0

Item {
    Canvas{
        id: foreground
        width: 80
        height: 80
        property int lineWidth: 3 // 线宽

        onPaint: {
            var ctx = getContext("2d");
            // 以下两部让画布坐标和仪表盘控件的坐标保持一致
            ctx.translate(foreground.width/2, foreground.height/2)
            ctx.rotate(-90*Math.PI/180)
            // 圆
            var drawOuterCirc = function(){
                // DashBoard的配色
                //ctx.strokeStyle = "#5DADE2";
                // DashBoard2的配色
                //ctx.strokeStyle = "#54BF6A";
                // DashBoard3的配色
                ctx.strokeStyle = "#EFAC51";
                ctx.fillStyle = "#515151";
                ctx.lineWidth = lineWidth;
                ctx.beginPath();
                ctx.arc(0, 0, foreground.width/2-lineWidth, 0, 2*Math.PI);
                ctx.fill()
                ctx.stroke();
            }

            // 线
            var drawLine = function(){
                ctx.save();
                ctx.lineWidth = 2;
                ctx.strokeStyle = "#6D6D6B";
                ctx.beginPath();
                ctx.moveTo(0, -(foreground.width/2 -lineWidth - 10));
                ctx.lineTo(0 ,foreground.width/2 - lineWidth - 10);
                ctx.stroke();
                ctx.restore();
            }

            // 字
            var drawText = function(){
                ctx.save();
                ctx.rotate(90*Math.PI/180);
                ctx.font = "16px monaco";
                ctx.textAlign = "center";
                ctx.fillStyle = "white";
                ctx.fillText("deg/s", 0, -5);
            }

            drawOuterCirc();
            drawLine();
            drawText();
        }
    }

    Rectangle{
        width: 20
        height: 20
        color: "red"
        x:-10; y:-10

        MouseArea{
            anchors.fill: parent
            onClicked: {
                //foreground.save("/Users/oliver/Desktop/DashBoardDemo/image/circle.png");
                //foreground.save("/Users/oliver/Desktop/DashBoardDemo/image/circle2.png");
                foreground.save("/Users/oliver/Desktop/DashBoardDemo/image/circle3.png");
                console.log("hi");
            }
        }
    }
}

