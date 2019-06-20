// 减少计算量的简版星星
import QtQuick 2.0

Item {
    property int mW: 400
    property int mH: 400

    property int starsAmout: 250
    property var stars: new Array

    Canvas{
        id: starBackground
        anchors.centerIn: parent
        width: mW
        height: mH
        onPaint: {
            var ctx = getContext("2d");

            // 星星
            var Star = function(){
                this.x = mW * Math.random(); // 横坐标
                this.y = mH * Math.random(); // 纵坐标
                this.text = ".";             // 文本
                this.color = "white";        // 颜色

                // 产生随机颜色
                this.getColor = function(){
                    var _r = Math.random();
                    if(_r < 0.5)
                        this.color = "#333";
                    else
                        this.color = "white";
                }

                // 绘制
                this.draw = function(){
                    this.getColor();
                    ctx.fillStyle = this.color;
                    ctx.fillText(this.text, this.x, this.y);
                }
            }


            // 星星闪烁
            var playStars = function(){
                for (var n=0; n<starsAmout; n++){
                    stars[n].getColor();
                    stars[n].draw()
                }
            }

            // 绘制星星
            for(var i=0; i<starsAmout; i++){
                var star = new Star();
                star.draw();
                stars.push(star);
            }
            // 绘制背景
            var drawBackground = function(){
                ctx.globalCompositeOperation = 'source-over'
                ctx.fillStyle = 'hsla(230, 64%, 6%, 2)';
                ctx.fillRect(0, 0, mW, mH);
            }
            drawBackground();
            // 渲染
            var render = function(){
                playStars();
                requestAnimationFrame(render);
            }

            //render();
        }
    }
}
