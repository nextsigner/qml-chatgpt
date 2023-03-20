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
    property int fs: apps.fs
    Unik{id: unik}
    property string apiKey: ''
    Settings{
        id: apps
        fileName: unik.getPath(5)+'/qml-chatgpt.cfg'
        property int fs: 32
        property color fontColor: 'white'
        property color backgroundColor: 'black'
        property bool showLog: true
        property bool speakEnabled: true
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
                ChatGptRequestList{id: chatGptRequestList}
            }
            Item{
                id: xChatGptView
                width: app.width/2
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
    }
}
