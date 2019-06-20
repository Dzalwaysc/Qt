// 静态星云图
import QtQuick 2.0

Item {
    property int mW: 400
    property int mH: 400

    property int starsColor: 230    // 星星颜色(hsla的hue色调)
    property int starsamount: 250  // 星星的数量
    property int starsradius: 10    // 星星半径比
    property int movrange: 2        // 星星移动范围（值越大范围越小）
    property int speed: 5000000       // 星星移动速度（值越大速度越慢）
    property double trailing: 0.5   // 星星拖尾效果(0~1值越小拖尾越明显
    property int count: 0
    Canvas{
        id: startBackground
        anchors.centerIn: parent
        width: mW
        height: mH
        onPaint: {
            var ctx = getContext("2d");
            var stars = [];

            // 如果max和min都为整数的话
            // 随机过程: err = max-min+1 , k = random(0,1]
            //          result = k * err + min;
            var random = function(min, max){
                if(arguments.length < 2){
                    max = min;
                    min = 0;
                }
                if(min > max){
                    var hold = max;
                    max = min;
                    min = hold;
                }
                // Math.floor()想下取整  Math.random()随机反正为[0,1)
                return Math.floor(Math.random() * (max - min + 1)) + min;
            }

            var maxOrbit = function(x, y){
                var max = Math.max(x, y);
                // diameter直径  Math.round四舍五入给整数
                var diameter = Math.round(Math.sqrt(max*max + max*max));
                return diameter / movrange;
                // 星星移动范围，值越大移动范围越小
            }

            var Star = function() {
                // 至画布中心的距离
                this.orbitRadius = random(maxOrbit(mW, mH), 50);
                // 星星的半径
                this.radius = random(starsradius, 10);

                this.orbitX = mW / 2;
                this.orbitY = mH / 2;
                this.timePassed = random(0, starsamount);
                // 星星的移动速度
                this.speed = random(10) / speed;
                // 星星的透明度
                this.alpha = random(2, 10) / 10;

                count++;
                stars[count] = this;
            }

            Star.prototype.draw = function(){

                // 星星此刻的位置，以画布中心为圆心，半径随机的一个圆上的一个点
                var x = Math.sin(this.timePassed) * this.orbitRadius + this.orbitX;
                var y = Math.cos(this.timePassed) * this.orbitRadius + this.orbitY;

                // 星星闪烁
                var twinkle = random(10);
                if(twinkle === 1 && this.alpha>0){
                    this.alpha -= 0.01;
                }else if(twinkle === 2 && this.alpha<1){
                    this.alpha += 0.01;
                }
                ctx.globalAlpha = this.alpha;
                // 在画布上画星星，参数(image, x, y, w, h)
                ctx.drawImage(star, x-this.radius/2, y-this.radius/2, this.radius, this.radius);
                this.timePassed += this.speed;
            }

            for(var i=0; i<starsamount; i++){
                new Star();
            }

            function animation() {
                ctx.globalCompositeOperation = 'source-over'
                ctx.globalAlpha = trailing;
                ctx.fillStyle = 'hsla(' + starsColor + ', 64%, 6%, 2)';
                ctx.fillRect(0, 0, mW, mH);

                ctx.globalCompositeOperation = 'lighter';
                for(var i=1, l= stars.length; i<l; i++){
                    stars[i].draw();
                }
                requestAnimationFrame(animation);
             }

            animation();
        }
    }

    Canvas{
        id: star
        width: 100
        height: 100
        opacity: 0
        onPaint: {
            var ctx = getContext("2d");
            var half = star.width/2;
            var grd = ctx.createRadialGradient(half, half, 0, half, half, half);
//            偏蓝色调
//            grd.addColorStop(0.025, '#CCC');
//            grd.addColorStop(0.1, 'hsl(' + starsColor + ', 61%, 33%)');
//            grd.addColorStop(0.25, 'hsl(' + starsColor + ', 64%, 6%)');
//            grd.addColorStop(1, 'transparent');
            // 偏白色调
            grd.addColorStop(0.15, '#CCC');
            grd.addColorStop(0.5, 'hsl(230, 61%, 33%)');
            grd.addColorStop(0.6, 'hsl(230, 64%, 6%)');
            grd.addColorStop(1, 'transparent');
            ctx.fillStyle = grd;
            ctx.beginPath();
            ctx.arc(half, half, half, 0, Math.PI*2);
            ctx.fill();
            ctx.globalAlpha = 0;
        }
    }
}
