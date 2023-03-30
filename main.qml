import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import Qt.labs.settings 1.1
import unik.Unik 1.0
import unik.UnikQProcess 1.0

import ChatGptResponseList 1.0
import ChatGptRequestList 1.0
import ChatGptRequestListEditor 1.0
import ChatGptView 1.1

ApplicationWindow{
    id: app
    width: Screen.width
    visible: true
    visibility: 'Maximized'
    color: apps.backgroundColor
    title: 'Qml-ChatGpt by @nextsigner'
    property bool dev: false
    property int fs: apps.fs
    property string apiKey: ''
    property bool runInUqp: true
    property bool editReqs: false
    property bool waitingGpt: false


    Unik{id: unik}
    UnikQProcess{
        id: uqp
        onLogOut: {
            app.waitingGpt=false
            chatGptView.l.lv('uqp.onLogOut dice: '+data)

        }
        onLogDataChanged: {
            let ld=''+logData
            if(ld.indexOf('XXXGGGGXXX@@@XXX')>=0){
                ld=ld.split('XXXGGGGXXX@@@XXX')[0]
            }
            if(ld.substring(0,1)==='\n'){
                ld=ld.substring(1, ld.length)
            }
            if(ld.substring(0,1)==='\n'){
                ld=ld.substring(1, ld.length)
            }
            if(apps.markdownEnabled){
                while(ld.substring(0,1)==='\n'){
                    ld=ld.substring(1, ld.length)
                }
                //ld=ld.replace(/\n/g, '<br />\n')
                ld=ld.replace(/\.\n/g, '. <br />\n')
                let lines=ld.split('\n')
                let nld=''
                for(var i=0;i<lines.length;i++){
                    if(lines[i].substring(0,1)==='#'){
                        nld+='<br />\n'+lines[i]+'<br />\n'
                    }else{
                        nld+=lines[i]+'\n'
                    }
                }
                ld=nld
                /*
                    Escribeme un artículo para un blog con que hable o explique los siguientes temas. 1). Escribe 3 párrafos en formato markdown sobre ¿Qué es el cambio climático?, 2). Escribe 1 párrafo con subtítulo sobre qué acciones tomar al respecto y 3). Escribe 1 párrafo con subtítulo ¿En qué año se descubrió este fenómeno?
                */
                //ld='### Gpt: <br />'+ld
            }else{
                ld='Gpt: '+ld
            }

            if(ld==='Gpt: ' || ld==='### Gpt: <br />')return
            if(apps.markdownEnabled)chatGptView.l.clear()
            chatGptView.l.lv(''+ld+'')
            app.waitingGpt=false
            chatGptView.ti.selectAll()
        }
        function conn(){
            uqp.run("python3 /home/ns/nsp/qml-chatgpt/gpt.py "+app.apiKey,false)
        }
        Component.onCompleted: {
            conn()
        }
    }

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

        property int vw: 0

        property bool helpInitEnabled: true
        property bool markdownEnabled: true
    }
    Item{
        id: xApp
        anchors.fill: parent
        Row{
            id: col
            Item{
                id: xChatGptRequestList
                width: (app.width/2)-app.fs*apps.vw
                height: app.height
                //visible: !app.dev?apps.showChatGptRequestList:true
                ChatGptRequestList{id: chatGptRequestList}
                ChatGptResponseList{id: chatGptResponseList; visible: !app.editReqs}
                ChatGptRequestListEditor{id: chatGptRequestListEditor; visible: app.editReqs}
            }
            Item{
                id: xChatGptView
                //width: app.dev?app.width/2:(apps.showChatGptRequestList?app.width/2:app.width)
                //xChatGptRequestList
                width: app.width-xChatGptRequestList.width
                height: app.height
                ChatGptView{id: chatGptView}
            }
        }
    }

    Shortcut{
        sequence: 'Esc'
        onActivated: {
            if(chatGptView.l.t.focus){
                chatGptView.ti.focus=true
                return
            }
            if(chatGptView.ti.focus){
                chatGptView.ti.focus=false
                return
            }
            Qt.quit()
        }
    }
    Shortcut{
        sequence: 'Up'
        onActivated:chatGptView.l.t.focus=true
    }
    Shortcut{
        sequence: 'Down'
        onActivated:chatGptView.ti.focus=true
    }
    Shortcut{
        sequence: 'Ctrl+Left'
        onActivated: {
            if(apps.vw<20){
                apps.vw++
            }
        }
    }
    Shortcut{
        sequence: 'Ctrl+Right'
        onActivated: {
            if(apps.vw>0){
                apps.vw--
            }
        }
    }
    Shortcut{
        sequence: 'Ctrl+e'
        onActivated: {
            app.editReqs=!app.editReqs
        }
    }
    Shortcut{
        sequence: 'Ctrl+m'
        onActivated: {
            apps.markdownEnabled=!apps.markdownEnabled
            if(apps.markdownEnabled){
                chatGptView.l.lv('# Se ha habilitado el formato MarkDown.<br />')
            }else{
                chatGptView.l.lv('Se ha deshabilitado el formato MarkDown.')
            }

        }
    }
    Component.onCompleted: {
        //Check is dev with the arg -dev
        if(Qt.application.arguments.indexOf('-dev')>=0){
            app.dev=true
        }
        app.requestActivate()
        let apiKey=unik.getFile('apikey.txt').replace(/\n/g, '')
        app.apiKey=apiKey
        let msgInicial='Hola Gpt. ¿Estas en linea?'
        if(!app.dev){
            chatGptView.l.lv('Iniciando Qml-ChatGpt...')
            chatGptView.l.lv('Preguntando si el ChatGpt está en línea...')
            chatGptView.l.lv(msgInicial)
            chatGptRequestList.loadReq(msgInicial)
        }
        //chatGptView.l.lv('ApiKey:\n['+apiKey+']')
    }
}
