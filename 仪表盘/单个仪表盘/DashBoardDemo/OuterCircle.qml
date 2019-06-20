/*****************************************************
  本文件用来画仪表盘外围的那一圈圆环
  点击红色矩形能够导出图片，格式为.png

  为什么要使用图片形式的圆环:
    采用canvas绘制，发现在打开程序的时候，canvas绘制的对象会延迟出现
    而直接导入图片则能马上就出现

    Canvas中的属性width对于仪表盘的宽和高
*****************************************************/
import QtQuick 2.0

Item {
    Canvas{
        id: background
        width: 150
        height: 150
        onPaint: {
            var ctx = getContext("2d");
            // 以下两部让画布坐标和仪表盘控件的坐标保持一致
            ctx.translate(background.width/2, background.height/2)
            ctx.rotate(-90*Math.PI/180)
            // 最外围圆
            var drawOuterCirc = function(){
                ctx.strokeStyle = "#06B9D1";
                ctx.lineWidth = 3;
                ctx.beginPath();
                ctx.arc(0, 0, background.width/2-3, 145*Math.PI/180, -145*Math.PI/180, true);
                ctx.stroke();
            }
            drawOuterCirc();
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
                background.save("/Users/oliver/Desktop/DashBoardDemo/outerCircle.png");
                console.log("hi");
            }
        }
    }
}
