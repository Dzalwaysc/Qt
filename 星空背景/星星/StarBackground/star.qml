import QtQuick 2.0

Canvas{
    id: star
    width: 100
    height: 100
    onPaint: {
        var ctx = getContext("2d");
        var half = star.width/2;
        var grd = ctx.createRadialGradient(half, half, 0, half, half, half);
//        grd.addColorStop(0.025, '#CCC');
//        grd.addColorStop(0.1, 'hsl(230, 61%, 33%)');
//        grd.addColorStop(0.25, 'hsl(230, 64%, 6%)');
//        grd.addColorStop(1, 'transparent');
        grd.addColorStop(0.15, '#CCC');
        grd.addColorStop(0.5, 'hsl(230, 61%, 33%)');
        grd.addColorStop(0.6, 'hsl(230, 64%, 6%)');
        grd.addColorStop(1, 'transparent');
        ctx.fillStyle = grd;
        ctx.beginPath();
        ctx.arc(half, half, half, 0, Math.PI*2);
        ctx.fill();
    }
}
