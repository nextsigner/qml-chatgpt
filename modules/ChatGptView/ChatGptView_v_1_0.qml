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
            height: !chatGptRequestList.playing?r.height-xTi.height:r.height-xTi.height-xTxtWaiting.height
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
        Item{
            id: xTxtWaiting
            width: r.width
            height: app.fs
            visible: chatGptRequestList.playing
            onVisibleChanged: {
                if(visible){
                    tWaiting.v=apps.maximunSecondsForWait
                    tWaiting.restart()
                }
            }
            Row{
                spacing: app.fs*3
                anchors.centerIn: parent
                Text{
                    text: 'Esperando respuesta'
                    color: 'white'
                    font.pixelSize: app.fs
                    Text{
                        color: 'white'
                        font.pixelSize: app.fs
                        anchors.left: parent.right
                        anchors.verticalCenter: parent.verticalAlignment
                        Timer{
                            running: xTxtWaiting.visible
                            repeat: true
                            interval: 500
                            property int v: 0
                            onTriggered: {
                                if(v<3){
                                    v++
                                }else{
                                    v=0
                                }
                                if(v===1){
                                    parent.text='.'
                                }else if(v===2){
                                    parent.text='..'
                                }else if(v===3){
                                    parent.text='...'
                                }else{
                                    parent.text=''
                                }
                            }
                        }
                    }
                }
                Item{
                    width: app.fs*3
                    height: app.fs
                    anchors.verticalCenter: parent.verticalCenter
                    Text{
                        //text: 'Esperando respuesta'
                        color: 'white'
                        font.pixelSize: app.fs
                        anchors.verticalCenter: parent.verticalCenter
                        Timer{
                            id: tWaiting
                            running: false
                            repeat: true
                            interval: 1000
                            property int v: 0
                            onTriggered: {
                                v--
                                parent.text=''+v+' segundos para cancelar.'
                                if(v<=0){
                                    chatGptRequestList.clear()
                                    stop()
                                }
                            }
                        }
                    }
                }
            }
        }
        Rectangle{
            id: xTi
            width: r.width
            height: ti.text===''?app.fs*3:ti.contentHeight+app.fs
            color: apps.backgroundColor
            border.width: 2
            border.color: apps.fontColor
            clip: true
            TextInput{
                id: ti
                width: parent.width-app.fs
                height: parent.height-app.fs
                font.pixelSize: app.fs
                color: apps.fontColor
                wrapMode: Text.WordWrap
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
