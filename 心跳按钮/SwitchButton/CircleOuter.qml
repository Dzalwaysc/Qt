import QtQuick 2.0

Item {
    Canvas{
        id: background
        width: 25
        height: 25

        onPaint: {
            var ctx = getContext("2d");
            // 让坐标原点在中心
            ctx.translate(background.width/2, background.height/2)
            ctx.rotate(-90*Math.PI/180)

            // 外围圆
            var drawOuterCirc = function(){
                ctx.strokeStyle = "#1DFAE3";
                ctx.lineWidth = 1.5;

                // 按钮的外圆
                ctx.beginPath();
                ctx.arc(0, 0, background.width/2-2, 0*Math.PI/180, 90*Math.PI/180, false);
                ctx.stroke();

                ctx.save();
                ctx.beginPath();
                ctx.arc(0, 0, background.width/2-2, 120*Math.PI/180, 210*Math.PI/180, false);
                ctx.stroke();
                ctx.restore();

                ctx.save();
                ctx.beginPath();
                ctx.arc(0, 0, background.width/2-2, 240*Math.PI/180, 330*Math.PI/180, false);
                ctx.stroke();
                ctx.restore();
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
                background.save("/Users/oliver/C++Projects/SwitchButton/image/circleOuter.png");
                console.log("hi");
            }
        }
    }
}

