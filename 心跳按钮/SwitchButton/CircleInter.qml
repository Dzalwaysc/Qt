import QtQuick 2.0

Item {
    Canvas{
        id: background
        width: 30
        height: 30

        onPaint: {
            var ctx = getContext("2d");
            // 让坐标原点在中心
            ctx.translate(background.width/2, background.height/2)

            // 最外围圆
            var drawOuterCirc = function(){
                ctx.fillStyle = "transparent";
                ctx.lineWidth = 2;
                ctx.strokeStyle = "white"
                // 按钮的外圆
                ctx.beginPath();
                ctx.arc(0, 0, background.width/2-2, 0*Math.PI/180, 360*Math.PI/180, false);
                ctx.fill();
                ctx.stroke();

                // 字体
                ctx.lineWidth = 1;
                ctx.fillStyle = "white";
                ctx.font = "13px monaco"
                ctx.textAlign = 'center';
                ctx.textBaseline = 'middle'
                ctx.strokeText("5", 0 ,0);
                ctx.fillText("5", 0 ,0);
            }
            drawOuterCirc();
        }
    }

    Rectangle{
        width: 20
        height: 20
        color: "red"
        x:-20; y:-20

        MouseArea{
            anchors.fill: parent
            onClicked: {
                // DashBoard的外圆
                background.save("/Users/oliver/C++Projects/SwitchButton/image/circleInter5.png");
                console.log("hi");
            }
        }
    }
}
