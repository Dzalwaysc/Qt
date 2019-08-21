import QtQuick 2.0
import QtQuick.Window 2.0
import QtWebEngine 1.0

Window {
    width: 1024
    height: 750
    visible: true
    WebEngineView {
        id:webview
        anchors.fill: parent
        url: "file:///Users/oliver/Desktop/GoogleMap%202/Google.html"
    }
}


