import QtQuick 2.0
Item {
    id: showerItem
    property int mW: 1024       // 画布的宽度
    property int mH: 688       // 画布的高度

    property int rainCount: 2 // 流星的数量
    property double rainAlpha: 0.35
    property int rainLength: 10  // 流星的最小长度
    property int rainLengthPlus: 10 // 流星的随机长度范围，即流星长度为random*plus+length
    property int rainAngle: 30    // 流星下落的角度
    property double rainspeed: 10    // 流星下落的速度


    Canvas{
        id: metorShower
        anchors.centerIn: parent
        width: mW; height: mH
        property int nowCount: 0
        property var rains: []


        onPaint: {
            var ctx = getContext("2d");

            // 流星雨
            var MeteorRain = function() {
                this.x = -1;        // 横坐标
                this.y = -1;        // 纵坐标
                this.length = -1;   // 长度
                this.angle = 30;    // 倾斜角度
                this.width = -1;    // 宽度
                this.height = -1;   // 高度
                this.speed = 1;     // 速度
                this.offset_x = -1; // 横轴移动偏移量
                this.offset_y = -1; // 纵轴移动偏移量
                this.alpha = 1;     // 透明度
                this.color1 = "";   // 流星的中段颜色
                this.color2 = "";   // 流星的结束颜色

                // 获取随机坐标的函数
                this.getPos = function(){
                    this.x = Math.random() * mW;
                    this.y = Math.random() * mH;
                }

                // 获取随机颜色的函数
                this.getColor = function(){
                    // Math.ceil 向上取整
                    var a = Math.ceil(255 - 240*Math.random());
                    // 中段颜色
                    this.color1 = "rgba(" + a + "," + a + "," + a  + ",1)";
                    // 结束颜色
                    this.color2 = "#090723";
                }

                // 获取随机长度/速度的函数
                this.getLength = function(){
                    var x = Math.random() * rainLengthPlus + rainLength;
                    this.length = Math.ceil(x); // 流星长度
                    x = Math.random() + rainspeed;
                    this.speed = Math.ceil(x); // 流星速度
                }

                // 获取倾斜角度/宽度/高度
                this.getSize = function(){
                    this.angle = rainAngle;
                    var cos = Math.cos(this.angle * Math.PI / 180);
                    var sin = Math.sin(this.angle * Math.PI / 180);
                    this.width = this.length * cos; // 流星所占宽度
                    this.height = this.length * sin // 流星所占高度
                    this.offset_x = this.speed * cos;
                    this.offset_y = this.speed * sin;
                }

                // 重新计算流星坐标
                this.newPos = function(){
                    this.x = this.x - this.offset_x;
                    this.y = this.y + this.offset_y;
                }

                // 初始化
                this.init = function(){
                    this.alpha = rainAlpha; // 透明度
                    this.getPos()
                    this.getColor();
                    this.getLength();
                    this.getSize();
                }

                // 绘制流星
                this.draw = function(){
                    ctx.save();
                    ctx.beginPath();
                    ctx.lineWidth = 1;
                    ctx.globalAlpha = this.alpha;

                    // 创建横行渐变颜色，起点坐标至终点坐标
                    var line_grd = ctx.createLinearGradient(this.x, this.y, this.x+this.width, this.y-this.height);
                    line_grd.addColorStop(0, "white");
                    line_grd.addColorStop(0.3, this.color1);
                    line_grd.addColorStop(0.6, this.color2);
                    ctx.strokeStyle = line_grd;

                    // 起点
                    ctx.moveTo(this.x, this.y)
                    // 终点
                    ctx.lineTo(this.x + this.width, this.y - this.height);

                    ctx.closePath();
                    ctx.stroke();
                    ctx.restore();
                }

                // 流星移动
                this.move = function(){
                    // 清空流星像素
                    var x = this.x + this.width - this.offset_x;
                    var y = this.y - this.height;
                    ctx.clearRect(x-3, y-3, this.offset_x+5, this.offset_y+5);
                    // 重新计算位置，往左下移动
                    this.newPos();
                    // 透明度改变
                    this.alpha -= 0.002;
                    // 重绘
                    this.draw();
                }
            }

            // 创建流星雨
            for (var i=0; i<rainCount; i++){
                var rain = new MeteorRain();
                rain.init();
                rain.draw();
                rains.push(rain);
            }

            var render = function(){
                for(var i=0; i<rainCount; i++){
                    rains[i].move(); // 移动
                    if(rains[i].y > mH){
                        ctx.clearRect(rains[i].x, rains[i].y-rains[i].height,
                                      rains[i].width, rains[i].height);
                        rains[i] = new MeteorRain();
                        rains[i].init();
                    }
                }
                requestAnimationFrame(render);
            }
            render();
        }
    }
}
