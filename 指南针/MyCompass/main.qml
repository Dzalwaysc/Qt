import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    MyCompass{
        anchors.centerIn: parent
    }


    // 点击矩形，保存图片，图片路径必须是已经存在的.
    Rectangle{
        width: 20
        height: 20
        x: 30; y: 30
        color: "red"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(myCompass.save("/Users/oliver/Desktop/123.png"))
                    console.log("save success")
                console.log("hi")
            }
        }
    }
}
