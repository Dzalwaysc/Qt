/********************************************************************
* 使用Qml的KeyBoard的时候，师弟问了我一个问题，Key.onReleased怎么使用？
* 师弟想要达到的效果是，在按下去的时候一直回调一个函数，在松开的时候回调另一个函数
* 于是他采用onPressed，和onReleased，问题是，onReleased一直被响应
* 情况就是:
*      pressed
*      released
*      pressed
*      released ...  因此给出下列代码
********************************************************************/
import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    Item{
        id: keyBoard
        anchors.fill: parent
        focus: true
        Keys.onPressed:{
            if (event.key === Qt.Key_Up) {
                console.log("hi");
                event.accepted = true;
            }
        }
        Keys.onReleased: {
            if (!event.isAutoRepeat) console.log("onReleased")
        }
    }
}
