import QtQuick 2.0
import QtQuick.Controls 2.0
import QtMultimedia 5.12
import Qt.labs.settings 1.0
import unik.UnikQProcess 1.0


Rectangle{
    id: r
    width: parent.width
    height: parent.height+app.fs
    color: apps.backgroundColor
    border.width: 1
    border.color: apps.fontColor
    radius: app.fs*0.25
    anchors.bottom: parent.bottom
    Behavior on x{NumberAnimation{duration: 250; easing.type: Easing.InOutQuad}}
    Column{
        spacing: app.fs*0.5
        anchors.horizontalCenter: parent.horizontalCenter
        Item{width: 10; height: app.fs*0.5}
        Text{
            id: tit
            text: '<b>Lista de Respuestas</b>'
            font.pixelSize: app.fs
            color: apps.fontColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
        ListView{
            id: lv
            width: r.width-app.fs
            height: r.height-tit.contentHeight-xTools.height-app.fs*2
            model:lm
            delegate: compRes
            spacing: app.fs*0.25
            anchors.horizontalCenter: parent.horizontalCenter
            ListModel{
                id: lm
                onCountChanged: {
                    if(chatGptRequestList.cantMaxRequestList > 0 && count===chatGptRequestList.cantMaxRequestList){
                        //r.sortList()
                    }
                }
                function addItem(t, nr){
                    return {
                        texto: t,
                        numRes: nr
                    }
                }

            }
        }
        Rectangle{
            id: xTools
            width: r.width
            height: colTools.height+app.fs*0.5
            border.width: 1
            border.color: apps.fontColor
            color: apps.backgroundColor
            Column{
                id: colTools
                spacing: app.fs*0.25
                anchors.centerIn: parent
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Button{
                        id: botSort
                        text: 'Limpiar'
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            r.clear()
                        }
                    }
                }
                Row{
                    spacing: app.fs*0.25
                    anchors.horizontalCenter: parent.horizontalCenter
                    Item{
                        width: xTools.width-botSave.width-app.fs//-txtLabelFile.contentWidth
                        height: parent.height-app.fs
                        anchors.verticalCenter: parent.verticalCenter
                        Rectangle{
                            anchors.fill: parent
                            border.width: 1
                            border.color: apps.fontColor
                            color: apps.backgroundColor
                            clip: true
                            TextInput{
                                id: tiFile
                                color: apps.fontColor
                                width: parent.width-app.fs
                                height: parent.height
                                anchors.centerIn: parent
                            }
                        }
                        Text{
                            id: txtLabelFile
                            text: '<b>Archivo: </b>'
                            font.pixelSize: app.fs*0.5
                            color: apps.fontColor
                            anchors.bottom: parent.top
                        }
                    }
                    Button{
                        id: botSave
                        text: 'Guardar'
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            saveFileData()
                        }
                    }
                }
            }
        }
    }
    Component{
        id: compRes
        Rectangle{
            width: lv.width
            height: colItem.height+app.fs//txt.contentHeight+app.fs*0.5
            border.width: 1
            border.color: apps.fontColor
            radius: app.fs*0.5
            color: apps.backgroundColor
            anchors.horizontalCenter: parent.horizontalCenter
            Column{
                id: colItem
                spacing: app.fs*0.25
                anchors.centerIn: parent
                Text{
                    id: txtNumRes
                    text: '<b>Respuesta N°: </b>'+numRes
                    width: lv.width-app.fs
                    font.pixelSize: app.fs
                    color: apps.fontColor
                    visible: numRes!==-1
                }
                Text{
                    id: txt
                    text: '<b>Texto: </b>'+texto
                    width: lv.width-app.fs
                    wrapMode: Text.WordWrap
                    font.pixelSize: app.fs
                    color: apps.fontColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
    Component.onCompleted: {
        /*let a=[2,9,3,5,6,1,7,8,4,0]
        for(var i=0;i<10;i++){
            addText('Dato '+a[i]+': la sldkf jañldfk añslfd kjañlkf', a[i])
        }
        sortList()*/
    }
    function clear(){
        lm.clear()
    }
    function addText(t, nr){
        lm.append(lm.addItem(t, nr))
    }
    function sortList(){
        let aNums=[]
        let aRes=[]
        for(var i=0;i<lm.count;i++){
            for(var i2=0;i2<lm.count;i2++){
                let nrItem=lm.get(i2).numRes
                let resItem=lm.get(i2).texto
                if(nrItem===i){
                    aNums.push(nrItem)
                    aRes.push(resItem)
                    break
                }
            }
        }
        lm.clear()
        for(i=0;i<aNums.length;i++){
            addText(aRes[i], aNums[i])
        }
    }
    function getListData(){
        let d=''
        for(var i=0;i<lm.count;i++){
            let resItem=lm.get(i).texto
            d+=resItem+'\n\n'
        }
        return d
    }
    function saveFileData(){
        let fileData=getListData()
        let fileName=tiFile.text
        if(unik.fileExist(fileName)){
            chatGptView.l.lv('Error! Este archivo '+fileName+' ya existe!')
            return
        }
        unik.setFile(fileName, fileData)
        chatGptView.l.lv('Las respuestas se han guardado en el archivo '+fileName)
    }
}
