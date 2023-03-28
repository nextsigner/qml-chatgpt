import QtQuick 2.0

Column{
    id: r
    spacing: app.fs*0.25
    anchors.verticalCenter: parent.verticalCenter
    property int ci: -1
    property int lmCount: -1
    //    signal eliminar()
    //    signal subir()
    //    signal bajar()

    onCiChanged: setVisible()

    //Eliminar
    Rectangle{
        id: bot1
        width: app.fs*0.75
        height: width
        radius: width*0.5
        color: apps.fontColor
        //rotation:index===0?0:(index===1?-90:-90)
        MouseArea{
            anchors.fill: parent
            onClicked: {
                lm.remove(r.ci)
                lm.update()
            }
        }
        Text{
            text: 'X'
            font.pixelSize: parent.width*0.8
            color: apps.backgroundColor
            anchors.centerIn: parent
        }
    }
    //Subir
    Rectangle{
        id: bot2
        width: app.fs*0.75
        height: width
        radius: width*0.5
        color: apps.fontColor
        rotation:90
        MouseArea{
            anchors.fill: parent
            onClicked: {
                lm.move(r.ci, r.ci-1, 1)
            }
        }
        Text{
            text: '<'
            font.pixelSize: parent.width*0.8
            color: apps.backgroundColor
            anchors.centerIn: parent
        }
    }
    //Bajar
    Rectangle{
        id: bot3
        width: app.fs*0.75
        height: width
        radius: width*0.5
        color: apps.fontColor
        rotation:90
        MouseArea{
            anchors.fill: parent
            onClicked: {
                lm.move(r.ci, r.ci+1, 1)
            }
        }
        Text{
            text: '>'
            font.pixelSize: parent.width*0.8
            color: apps.backgroundColor
            anchors.centerIn: parent
        }
    }
    Item{
        width: 1
        height: 1
        Text{
            text: 'Ci:'+r.ci
            font.pixelSize: app.fs
            color: 'yellow'
            anchors.right: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0-app.fs
            visible: app.dev
        }
    }
    function setVisible(){
        let v=true
        if(r.ci===0){
            bot2.visible=false
            bot3.visible=true
        }else if(r.ci===lm.count-1){
            bot2.visible=true
            bot3.visible=false
        }else{
            bot2.visible=true
            bot3.visible=true
        }
    }
}
