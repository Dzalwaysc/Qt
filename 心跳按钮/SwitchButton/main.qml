import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    visible: true
    width: 1024
    height: 668
    title: qsTr("Hello World")
    color: Qt.hsla(230, 0.64, 0.06, 1)

    CircleOuter{
        id: circleOuter
        opacity: 1
        x:40; y:150
    }

    CircleInter{
        id: circleInter
        x: 40; y:60

    }

    SwitchButton{
        id: comButton1
        x: 30; y:400
        circleInterSource: "image/circleInter1"
        Connections{
            target: comButton2;
            onDialogOn: {
                comButton1.circleInter.opacity = 0;
                comButton1.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton1.state === "active"){
                    comButton1.circleInter.opacity = 1;
                    comButton1.circleOuter.opacity = 1;
                }else{
                    comButton1.circleInter.opacity = 0.5;
                    comButton1.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton3;
            onDialogOn: {
                comButton1.circleInter.opacity = 0;
                comButton1.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton1.state === "active"){
                    comButton1.circleInter.opacity = 1;
                    comButton1.circleOuter.opacity = 1;
                }else{
                    comButton1.circleInter.opacity = 0.5;
                    comButton1.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton4;
            onDialogOn: {
                comButton1.circleInter.opacity = 0;
                comButton1.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton1.state === "active"){
                    comButton1.circleInter.opacity = 1;
                    comButton1.circleOuter.opacity = 1;
                }else{
                    comButton1.circleInter.opacity = 0.5;
                    comButton1.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton5;
            onDialogOn: {
                comButton1.circleInter.opacity = 0;
                comButton1.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton1.state === "active"){
                    comButton1.circleInter.opacity = 1;
                    comButton1.circleOuter.opacity = 1;
                }else{
                    comButton1.circleInter.opacity = 0.5;
                    comButton1.circleOuter.opacity = 0;
                }
            }
        }
    }
    SwitchButton{
        id: comButton2
        x: 70; y:400
        circleInterSource: "image/circleInter2"
        Connections{
            target: comButton1;
            onDialogOn: {
                comButton2.circleInter.opacity = 0;
                comButton2.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton2.state === "active"){
                    comButton2.circleInter.opacity = 1;
                    comButton2.circleOuter.opacity = 1;
                }else{
                    comButton2.circleInter.opacity = 0.5;
                    comButton2.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton3;
            onDialogOn: {
                comButton2.circleInter.opacity = 0;
                comButton2.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton2.state === "active"){
                    comButton2.circleInter.opacity = 1;
                    comButton2.circleOuter.opacity = 1;
                }else{
                    comButton2.circleInter.opacity = 0.5;
                    comButton2.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton4;
            onDialogOn: {
                comButton2.circleInter.opacity = 0;
                comButton2.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton2.state === "active"){
                    comButton2.circleInter.opacity = 1;
                    comButton2.circleOuter.opacity = 1;
                }else{
                    comButton2.circleInter.opacity = 0.5;
                    comButton2.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton5;
            onDialogOn: {
                comButton2.circleInter.opacity = 0;
                comButton2.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton2.state === "active"){
                    comButton2.circleInter.opacity = 1;
                    comButton2.circleOuter.opacity = 1;
                }else{
                    comButton2.circleInter.opacity = 0.5;
                    comButton2.circleOuter.opacity = 0;
                }
            }
        }
    }

    SwitchButton{
        id: comButton3
        x: 110; y:400
        circleInterSource: "image/circleInter3"
        Connections{
            target: comButton1;
            onDialogOn: {
                comButton3.circleInter.opacity = 0;
                comButton3.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton3.state === "active"){
                    comButton3.circleInter.opacity = 1;
                    comButton3.circleOuter.opacity = 1;
                }else{
                    comButton3.circleInter.opacity = 0.5;
                    comButton3.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton2;
            onDialogOn: {
                comButton3.circleInter.opacity = 0;
                comButton3.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton3.state === "active"){
                    comButton3.circleInter.opacity = 1;
                    comButton3.circleOuter.opacity = 1;
                }else{
                    comButton3.circleInter.opacity = 0.5;
                    comButton3.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton4;
            onDialogOn: {
                comButton3.circleInter.opacity = 0;
                comButton3.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton3.state === "active"){
                    comButton3.circleInter.opacity = 1;
                    comButton3.circleOuter.opacity = 1;
                }else{
                    comButton3.circleInter.opacity = 0.5;
                    comButton3.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton5;
            onDialogOn: {
                comButton3.circleInter.opacity = 0;
                comButton3.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton3.state === "active"){
                    comButton3.circleInter.opacity = 1;
                    comButton3.circleOuter.opacity = 1;
                }else{
                    comButton3.circleInter.opacity = 0.5;
                    comButton3.circleOuter.opacity = 0;
                }
            }
        }
    }
    SwitchButton{
        id: comButton4
        x: 150; y:400
        circleInterSource: "image/circleInter4"
        Connections{
            target: comButton1;
            onDialogOn: {
                comButton4.circleInter.opacity = 0;
                comButton4.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton4.state === "active"){
                    comButton4.circleInter.opacity = 1;
                    comButton4.circleOuter.opacity = 1;
                }else{
                    comButton4.circleInter.opacity = 0.5;
                    comButton4.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton2;
            onDialogOn: {
                comButton4.circleInter.opacity = 0;
                comButton4.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton4.state === "active"){
                    comButton4.circleInter.opacity = 1;
                    comButton4.circleOuter.opacity = 1;
                }else{
                    comButton4.circleInter.opacity = 0.5;
                    comButton4.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton3;
            onDialogOn: {
                comButton4.circleInter.opacity = 0;
                comButton4.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton4.state === "active"){
                    comButton4.circleInter.opacity = 1;
                    comButton4.circleOuter.opacity = 1;
                }else{
                    comButton4.circleInter.opacity = 0.5;
                    comButton4.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton5;
            onDialogOn: {
                comButton4.circleInter.opacity = 0;
                comButton4.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton4.state === "active"){
                    comButton4.circleInter.opacity = 1;
                    comButton4.circleOuter.opacity = 1;
                }else{
                    comButton4.circleInter.opacity = 0.5;
                    comButton4.circleOuter.opacity = 0;
                }
            }
        }
    }
    SwitchButton{
        id: comButton5
        x: 190; y:400
        circleInterSource: "image/circleInter5"
        Connections{
            target: comButton1;
            onDialogOn: {
                comButton5.circleInter.opacity = 0;
                comButton5.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton5.state === "active"){
                    comButton5.circleInter.opacity = 1;
                    comButton5.circleOuter.opacity = 1;
                }else{
                    comButton5.circleInter.opacity = 0.5;
                    comButton5.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton2;
            onDialogOn: {
                comButton5.circleInter.opacity = 0;
                comButton5.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton5.state === "active"){
                    comButton5.circleInter.opacity = 1;
                    comButton5.circleOuter.opacity = 1;
                }else{
                    comButton5.circleInter.opacity = 0.5;
                    comButton5.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton3;
            onDialogOn: {
                comButton5.circleInter.opacity = 0;
                comButton5.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton5.state === "active"){
                    comButton5.circleInter.opacity = 1;
                    comButton5.circleOuter.opacity = 1;
                }else{
                    comButton5.circleInter.opacity = 0.5;
                    comButton5.circleOuter.opacity = 0;
                }
            }
        }
        Connections{
            target: comButton4;
            onDialogOn: {
                comButton5.circleInter.opacity = 0;
                comButton5.circleOuter.opacity = 0;
            }
            onDialogOff: {
                if(comButton5.state === "active"){
                    comButton5.circleInter.opacity = 1;
                    comButton5.circleOuter.opacity = 1;
                }else{
                    comButton5.circleInter.opacity = 0.5;
                    comButton5.circleOuter.opacity = 0;
                }
            }
        }
    }
}
