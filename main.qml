import QtQuick 2.12
import QtQuick.Controls 2.0
import Qt.labs.settings 1.1
import unik.Unik 1.0
import unik.UnikQProcess 1.0

import ChatGptRequestList 1.0
import ChatGptView 1.0

ApplicationWindow{
    id: app
    visible: true
    visibility: 'Maximized'
    color: 'black'
    title: 'Qml-ChatGpt by @nextsigner'
    property int fs: apps.fs
    Unik{id: unik}
    property string apiKey: ''
    Settings{
        id: apps
        fileName: unik.getPath(5)+'/qml-chatgpt.cfg'
        property bool showChatGptRequestList: false
        property int fs: 32
        property color fontColor: 'white'
        property color backgroundColor: 'black'
        property bool showLog: true
        property bool speakEnabled: true
        property int maximunSecondsForWait: 30
    }
    Item{
        id: xApp
        anchors.fill: parent
        Row{
            id: col
            Item{
                id: xChatGptRequestList
                width: app.width/2
                height: app.height
                visible: apps.showChatGptRequestList
                ChatGptRequestList{id: chatGptRequestList}
            }
            Item{
                id: xChatGptView
                width: apps.showChatGptRequestList?app.width/2:app.width
                height: app.height
                ChatGptView{id: chatGptView}
            }
        }
    }

    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Component.onCompleted: {
        app.requestActivate()
        let apiKey=unik.getFile('apikey.txt').replace(/\n/g, '')
        app.apiKey=apiKey
        let msgInicial='Hola Gpt. ¿Estas en linea?'
        chatGptView.l.lv('Iniciando Qml-ChatGpt...')
        chatGptView.l.lv('Preguntando si el ChatGpt está en línea...')
        chatGptView.l.lv(msgInicial)
        chatGptRequestList.speak(msgInicial, false)
        //chatGptView.l.lv('ApiKey:\n['+apiKey+']')
    }
}
