import QtQuick 2.0
import ZoolLogView 1.0
Rectangle{
    id: r
    width: parent.width
    height: parent.height//+app.fs
    color: apps.backgroundColor
    border.width: 10
    border.color: 'red'//apps.fontColor
    radius: app.fs*0.25
    property alias l: log
    Column{
        id: col
        anchors.centerIn: parent
        ZoolLogView{
            id: log
            width: app.width/2
            height: r.height-xTi.height
            fs: app.fs
            visible: true
            Timer{
                running: parent.width<=0
                repeat: true
                interval: 100
                onTriggered: parent.width=r.width
            }
            Timer{
                running: parent.height<=0
                repeat: true
                interval: 100
                onTriggered: parent.height=r.height-xTi.height
            }
        }
        Rectangle{
            id: xTi
            width: r.width
            height: app.fs*3
            color: apps.backgroundColor
            border.width: 2
            border.color: apps.fontColor
            TextInput{
                id: ti
                width: parent.width-app.fs
                height: parent.height-app.fs
                color: apps.fontColor
                anchors.centerIn: parent
                Keys.onReturnPressed: {
                    log.lv('Yo: '+text)
                    chatGptRequestList.speak(text, false)
                }
            }
        }
    }
    Component.onCompleted: log.lv('ChatGpt iniciado.')
}
