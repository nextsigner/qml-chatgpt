import QtQuick 2.12
import QtQuick.Controls 2.12


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
            text: '<b>Lista de Requerimientos</b>'
            font.pixelSize: app.fs
            color: apps.fontColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
        ListView{
            id: lv
            width: r.width-app.fs
            height: r.height-tit.contentHeight-app.fs
            model:lm
            delegate: compRes
            spacing: app.fs*0.25
            anchors.horizontalCenter: parent.horizontalCenter
            ListModel{
                id: lm
                onCountChanged: {
                    for(var i=0;i<count;i++){
                        let item=lv.itemAtIndex(i)
                        item.setVisible()
                    }
                }
                function addItem(t){
                    return {
                        texto: t
                    }
                }

            }
        }
    }
    Component{
        id: compRes
        Rectangle{
            id: xItem
            width: lv.width
            height: colItem.height+app.fs//txt.contentHeight+app.fs*0.5
            border.width: 1
            border.color: apps.fontColor
            radius: app.fs*0.5
            color: apps.backgroundColor
            anchors.horizontalCenter: parent.horizontalCenter
            Row{
                anchors.centerIn: parent
                Column{
                    id: colItem
                    spacing: app.fs*0.25
                    anchors.verticalCenter: parent.verticalCenter
                    Text{
                        id: txtNumRes
                        text: '<b>Requerimiento N°: </b>'+parseInt(index + 1)
                        width: lv.width-app.fs
                        font.pixelSize: app.fs*0.5
                        color: apps.fontColor
                    }
                    Text{
                        id: txt
                        text: texto
                        width: lv.width-app.fs*2
                        wrapMode: Text.WordWrap
                        font.pixelSize: app.fs
                        color: apps.fontColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Btns{id: btns; ci:index}
            }
            function setVisible(){
                btns.setVisible()
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
    function append(t){
        lm.append(lm.addItem(t))
    }
    function getListData(){
        let d=''
        for(var i=0;i<lm.count;i++){
            let resItem=lm.get(i).texto
            d+=resItem+'\n'
        }
        return d
    }
    function saveFileData(fileName){
        let fileData=getListData()
        if(unik.fileExist(fileName)){
            chatGptView.l.lv('Error! Este archivo '+fileName+' ya existe!')
            return
        }
        unik.setFile(fileName, fileData)
        chatGptView.l.lv('Los requerimientos se han guardado en el archivo '+fileName)
    }
}
