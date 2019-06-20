import QtQuick 2.0

Item{
    id: root
    property int mW: 200        // 画布宽度
    property int mH: 200        // 画布高度
    property double m_Angle: 0    // 当前旋转角度
    property int lineWidth: 2   //画图的线宽
    property double center: mW/2     // 圆心

    property int tickMarkSize: 20
    property int minortickMarkSize: 8

    property string fontfamily: "monaco"

    property int radius: 8     // 中心圆半径
    property int pLength: 50    // 指针长度
    property int pAngle: 60     // 指针夹角度数

    Canvas{
        id: myCompass
        width: mW
        height: mH
        anchors.centerIn: parent
        rotation: m_Angle
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
                ctx.strokeStyle = "black";
                ctx.beginPath();
                ctx.arc(center, center, center-lineWidth, 0, 2*Math.PI);
                ctx.stroke();
                ctx.restore();
            }

            // 绘制游标
            var drawLabel = function(){
                for(var i=0; i<36; i++){
                    ctx.save();
                    ctx.lineWidth = 3
                    ctx.translate(center, center); // 转换坐标原点至圆心
                    ctx.rotate(i*10*Math.PI/180);

                    ctx.beginPath();
                    if(i%9 != 0){
                        ctx.moveTo(0, -mW/2 + lineWidth);
                        ctx.lineTo(0, -mW/2 + minortickMarkSize);
                    }else{
                        ctx.moveTo(0, -mW/2 + lineWidth);
                        ctx.lineTo(0, -mW/2 + tickMarkSize);
                    }
                    ctx.stroke();
                    ctx.restore();
                }
            }

            // 绘制指针
            // 绘制指针，已知指针的指向的度数，0度指向E向
            var drawPointer = function(rotaAngle){
                ctx.save();
                ctx.translate(center, center); // 转换坐标原点至圆心
                ctx.rotate(rotaAngle*Math.PI/180);   // 否则的话，指针是只想E向的
                ctx.beginPath();
                var gradient = ctx.createRadialGradient(0, 0, radius, 0, 0, pLength*1.2);
                gradient.addColorStop(0, 'rgba(16,110,180,0.6)');
                gradient.addColorStop(0.5, 'rgba(21,165,174,0.8)');
                gradient.addColorStop(1,'rgba(30,130,139,1)');
                ctx.fillStyle = gradient;
                var point1 = getCircCorrdinate(radius, 0, 0, pAngle);
                var point2 = [pLength, 0];
                // ctx.arc(point1[0], point1[1], 5, 0, Math.PI*2); 一开始不知道point1在哪里，用这个来更清晰的看代码
                ctx.moveTo(point1[0], point1[1]);
                ctx.arc(0, 0, radius, pAngle*Math.PI/180, -pAngle*Math.PI/180);
                ctx.lineTo(point2[0], point2[1]);
                ctx.lineTo(point1[0], point1[1]);
                ctx.fill();
                ctx.closePath();
                ctx.restore();
            }

            var drawWholePointer = function(){

                // 绘制中心圆
                ctx.save();
                ctx.beginPath();
                ctx.translate(center, center); // 转换坐标原点至圆心
                var rGra = ctx.createRadialGradient(0, 0, radius*0.5, 0, 0, radius);
                rGra.addColorStop(0, "#BFEFFF");
                rGra.addColorStop(1, "#6D8CA3");
                ctx.fillStyle = rGra;
                ctx.arc(0, 0, radius, 0, Math.PI*2, false);
                ctx.fill();
                ctx.restore();

                // 绘制指针
                drawPointer(-90);
                drawPointer(90);
            }


            var render = function(){
                ctx.clearRect(0, 0, mW, mH);
                if(ifCirc == false){
                    drawCirc();
                    drawLabel();
                    drawWholePointer();
                }
                m_Angle += 0.1;
                requestAnimationFrame(render);
            }
            render();

//            drawCirc();
//            drawLabel();
        }

        // 绘制方向文职
        Text {
            id: n_dirction
            rotation: -m_Angle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: lineWidth + tickMarkSize
            color: "red"
            font.family: fontfamily
            font.pixelSize: mW*0.1
            text: qsTr("N")
        }
        Text {
            id: s_dirction
            rotation: -m_Angle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: lineWidth + tickMarkSize
            color: "blue"
            font.family: fontfamily
            font.pixelSize: mW*0.1
            text: qsTr("S")
        }
        Text {
            id: w_dirction
            rotation: -m_Angle
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: lineWidth + tickMarkSize + 5
            color: "blue"
            font.family: fontfamily
            font.pixelSize: mW*0.1
            text: qsTr("W")
        }
        Text {
            id: e_dirction
            rotation: -m_Angle
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: lineHeight + tickMarkSize + 5
            color: "blue"
            font.family: fontfamily
            font.pixelSize: mW*0.1
            text: qsTr("E")
        }
    }
}
