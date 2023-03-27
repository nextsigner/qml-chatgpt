import QtQuick 2.0
import ZoolLogView 1.0
Rectangle{
    id: r
    width: parent.width
    height: parent.height//+app.fs
    color: apps.backgroundColor
    border.width: 2
    border.color: apps.fontColor
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
                        anchors.verticalCenter: parent.verticalCenter
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
                    if(!r.isCmd(text)){
                        log.lv('Yo: '+text)
                        chatGptRequestList.cantMaxRequestList=0
                        chatGptRequestList.currentRequestMaked=0
                        chatGptRequestList.loadReq(text)
                    }else{
                        log.lv('Ejecutando el comando: '+text)
                        r.run(text)
                    }
                }
            }
        }
    }
    Timer{
        id: tWaitingForLoadFile
        running: false
        repeat: false
        interval: 2000
        property string f: ''
        onTriggered: {
            log.lv('Iniciando la carga del archivo: '+f)
            cargarArchivo(f)
        }

    }
    //Component.onCompleted: log.lv('ChatGpt iniciado.')
    function isCmd(text){
        let ret=false
        let cmds=['!l ', '!c', '!cr', '!dev']
        for(var i=0; i < cmds.length; i++){
            if(app.dev)log.lv('cmd '+i+': ['+cmds[i]+']')
            if(text.indexOf(cmds[i])>=0){
                ret=true
                break
            }
        }
        return ret
    }
    function run(text){
        let cmdList=text.split(' ')
        let cmd=cmdList[0]
        if(app.dev)log.lv('Run cmd: ['+cmd+']')
        if(cmd==='!l'){
            if(unik.fileExist(cmdList[1])){
                log.lv('Preparando la carga del archivo...')
                chatGptRequestList.clear()
                chatGptResponseList.clear()
                tWaitingForLoadFile.f=cmdList[1]
                tWaitingForLoadFile.start()
            }else{
                log.lv('El archivo '+cmdList[1]+' no existe!')
            }
        }

        if(cmd==='!c'){
            chatGptView.l.clear()
        }
        if(cmd==='!cr'){
            chatGptResponseList.clear()
        }
        if(cmd==='!dev'){
            app.dev=!app.dev
            if(app.dev){
                chatGptView.l.lv('Se ha activado el modo desarrollador.')
            }else{
                chatGptView.l.lv('Se ha desactivado el modo desarrollador.')
            }

        }

        return
    }
    function cargarArchivo(file){
        if(app.dev)log.lv('cargarArchivo(): '+file)
        log.lv('Cargando el archivo '+file+'...')
        let reqs=[]
        let cantReqs=0
        log.lv('Cargando el archivo '+file+'...')
        let fileData=unik.getFile(file)
        //log.lv('Datos del archivo:\n'+fileData+'\n')
        let requestList=fileData.split('\n')
        for(var i=0; i < requestList.length; i++){
            let req=requestList[i].replace(/\n/g, ' ')
            if(req.length<=1)continue
            //if(app.dev)log.lv('Requerimiento app.apiKey: '+app.apiKey)
            if(app.dev)log.lv('Requerimiento '+parseInt(i + 1)+':\n'+req+'\n')
            reqs.push(req)
            cantReqs++
        }
        chatGptRequestList.currentRequestMaked=0
        chatGptRequestList.cantMaxRequestList=cantReqs
        if(app.dev)log.lv('cantMaxRequestList: '+chatGptRequestList.cantMaxRequestList)
        for(i=0; i < reqs.length; i++){
            let req=reqs[i]
            chatGptRequestList.loadReq(req)
        }
        return

    }
}
