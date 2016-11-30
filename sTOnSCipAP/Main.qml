import QtQuick 2.4
import Ubuntu.Components 1.3
import QtMultimedia 5.0

/*!
    sTOnSCipAP - A further experiment with qml and the Ubuntu SDK, this time with pictures & audio
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "stonscipap.phelion"

    width: units.gu(100)
    height: units.gu(75)

    // Different Background Colour Variables

       property string bgcolour: UbuntuColors.darkAubergine
       property string darkerAubergine: "#270018"
       property string luneBGColour: "#106a10"
       property string wolfBGColour: "#1a0db2"

       // ************************************

       property int lunechoice: 0
       property int wolfchoice: 0
       property bool lunechoosed: false
       property bool wolfchoosed: false

       property int winneris: 0

       property int lunescore: 0
       property int wolfscore: 0

       property bool soundon: true

       property var divinethis: [ [0,1,2], [2,0,1], [1,2,0] ] // results in a 2 Dimensional array - 0 means draw, 1 is lunewin, 2 is wolfwin
       property var winnames: [ i18n.tr("Everyone"), "Lune", "Wolfman" ]

       property int stonecycle: 0
       property int scissorscycle: 1
       property int papercycle: 2

       property var choice: ["qrc:/Pics/stone.png", "qrc:/Pics/scissors.png", "qrc:/Pics/paper.png"]

       property var defaultdramaticpausemessage: i18n.tr("...processing dramatic tension...")
       property var dramaticpausemessage: defaultdramaticpausemessage

       property int defaultdramatime: 7000
       property int dramatime: defaultdramatime

       //property var infoitemspacing: units.gu(2)

       Item {
           id: picchanger

           /* Let the function know which picture it's working on with 'whichpic' (stone = 0, scissors = 1, paper = 2)
              - stonecycle, scissorscycle and papercycle (global variables) allow for each 'picture cycle' to be tracked and incremented.
              - stonepicanimation, scissorspicanimation & paperpicanimation timers each use this function to cycle their picture sources
              - function returns the picture source from the 'choice' array
             */

           function picinc(whichpic, whichcycle)
           {
               whichcycle++;
               if (whichcycle > 2 )
                   whichcycle = 0;         //increment the picture cycle & if it's more than two, reset it to zero

               if (whichpic == 0)
                   stonecycle = whichcycle;
               else if (whichpic == 1)
                   scissorscycle = whichcycle;
               else
                   papercycle = whichcycle;

               return choice[whichcycle];
           }

       } //picchanger

       SequentialAnimation on bgcolour {
           id: screenflash
           running: false
           loops: Animation.Infinite
           alwaysRunToEnd: true
           ColorAnimation { from: bgcolour; to: "#ab0020"; duration: 1000}
           ColorAnimation { from: "#ab0020"; to: bgcolour; duration: 1000}
       }


       SoundEffect {
           id: applause
           source: "qrc:/Audio/applause.wav"
       }

       SoundEffect {
           id: luneichoose
           source: "qrc:/Audio/luneichoose.wav"
       }

       SoundEffect {
           id: wolfichoose
           source: "qrc:/Audio/wolfichoose.wav"
       }

       SoundEffect {
           id: luneichoosed
           source: "qrc:/Audio/luneichoosed.wav"
       }

       SoundEffect {
           id: wolfichoosed
           source: "qrc:/Audio/wolfichoosed.wav"
       }

       PageStack {
           id: pageStack
           Component.onCompleted: push(page0)

           Page {
               id: page0
               visible: false

               header: PageHeader {
                   id: pageHeader
                   title: i18n.tr("sTOnSCipAP")
                   StyleHints {
                       foregroundColor: UbuntuColors.orange
                       backgroundColor: bgcolour
                       dividerColor: Qt.darker(bgcolour)
                   }

               } //pageHeader

               states: [

                   /* There are 5 states to this 'game' - initial splash/welcome, lune choosing, wolfman choosing, dramatic pause, outcome/result.
                      Each state changes a picture or makes a section visible/non-visible where appropriate - the falsedrama state starts a lot of timers too.
                      It allows what is basically a static page to change it's appearance & functionality, but it did start to get a little out of hand...
                   */

                   State {
                       name: "splashstate"


                       PropertyChanges {
                           target: infobuttonrec
                           visible: true
                       }

                       PropertyChanges {
                           target: playbuttonrec
                           visible: true
                       }

                       PropertyChanges {
                           target: choosesection
                           visible: false
                       }

                       PropertyChanges {
                           target: leftpic
                           source: "qrc:/Pics/lune.png"
                       }

                       PropertyChanges {
                           target: scorelune
                           visible: true
                       }

                       PropertyChanges {
                           target: scorewolf
                           visible: true
                       }

                   }, //splashstate

                   State {
                       name: "lunechoosestate"

                       PropertyChanges {
                           target: infobuttonrec
                           visible: false
                       }

                       PropertyChanges {
                           target: playbuttonrec
                           visible: false
                       }

                       PropertyChanges {
                           target: pageHeader
                           title: i18n.tr("Lune to choose...")
                       }

                       PropertyChanges {
                           target: middlepic
                           source: "qrc:/Pics/haschosen.png"
                       }

                       PropertyChanges {
                           target: rightpic
                           source: "qrc:/Pics/choicequestion.png"
                       }


                       PropertyChanges {
                           target: choosesection
                           visible: true
                       }

                       PropertyChanges {
                           target: proceedsection
                           visible: true
                       }

                       PropertyChanges {
                           target: stonepic
                           source: "qrc:/Pics/stone.png"
                       }

                       PropertyChanges {
                           target: scissorspic
                           source: "qrc:/Pics/scissors.png"
                       }

                       PropertyChanges {
                           target: paperpic
                           source: "qrc:/Pics/paper.png"
                       }

                       PropertyChanges {
                           target: wordses
                           text: i18n.tr("Make your choice then press 'Proceed'")
                       }


                   }, //lunechoosestate

                   State {
                       name: "wolfchoosestate"

                       PropertyChanges {
                           target: infobuttonrec
                           visible: false
                       }

                       PropertyChanges {
                           target: playbuttonrec
                           visible: false
                       }

                       PropertyChanges {
                           target: pageHeader
                           title: i18n.tr("Wolfman to choose...")
                       }

                       PropertyChanges {
                           target: choosesection
                           visible: true
                       }

                       PropertyChanges {
                           target: proceedsection
                           visible: true
                       }

                       PropertyChanges {
                           target: leftpic
                           source: "qrc:/Pics/wolfman.png"
                       }

                       PropertyChanges {
                           target: middlepic
                           source: "qrc:/Pics/haschosen.png"
                       }

                       PropertyChanges {
                           target: rightpic
                           source: "qrc:/Pics/choicequestion.png"
                       }

                       PropertyChanges {
                           target: stonepic
                           source: "qrc:/Pics/stone.png"
                       }

                       PropertyChanges {
                           target: scissorspic
                           source: "qrc:/Pics/scissors.png"
                       }

                       PropertyChanges {
                           target: paperpic
                           source: "qrc:/Pics/paper.png"
                       }

                       PropertyChanges {
                           target: wordses
                           text: i18n.tr("Make your choice then press 'Proceed'")
                       }


                   }, //wolfchoosestate

                   State {
                       name: "falsedramastate"

                       PropertyChanges {
                           target: infobuttonrec
                           visible: false
                       }

                       PropertyChanges {
                           target: playbuttonrec
                           visible: false
                       }

                       PropertyChanges {
                           target: pageHeader
                           title: i18n.tr("Who's decision will win?")
                       }

                       PropertyChanges {
                           target: wordses
                           text: dramaticpausemessage
                       }

                       PropertyChanges {
                           target: wordses
                           visible: false
                       }

                       PropertyChanges {
                           target: leftpic
                           source: "qrc:/Pics/lune.png"
                       }

                       PropertyChanges {
                           target: middlepic
                           source: "qrc:/Pics/newthing.png"
                       }

                       PropertyChanges {
                           target: choosesection
                           visible: true
                       }

                       PropertyChanges {
                           target: proceed
                           visible: false
                       }

                       PropertyChanges {
                           target: falsedramatimer
                           running: true
                       }

                       PropertyChanges {
                           target: stonepicanimation
                           running: true
                       }

                       PropertyChanges {
                           target: scissorspicanimation
                           running: true
                       }

                       PropertyChanges {
                           target: paperpicanimation
                           running: true
                       }

                       PropertyChanges {
                           target: screenflash
                           running: true
                       }

                       PropertyChanges {
                           target: flashwriting
                           running: true
                       }

                   }, //falsedramastate

                   State {
                       name: "outcomestate"

                       PropertyChanges {
                           target: infobuttonrec
                           visible: false
                       }

                       PropertyChanges {
                           target: playbuttonrec
                           visible: false
                       }

                       PropertyChanges {
                           target: choosesection
                           visible: true
                       }

                       PropertyChanges {
                           target: middlepic
                           source: "qrc:/Pics/haschosen.png"
                       }

                       PropertyChanges {
                           target: leftpic
                           source: (winneris == 2)? "qrc:/Pics/wolfman.png" : "qrc:/Pics/lune.png"
                       }

                       PropertyChanges {
                           target: stonepic
                           source: (winneris == 2)? "qrc:/Pics/lune.png" : "qrc:/Pics/wolfman.png"
                       }


                       PropertyChanges {
                           target: scissorspic
                           source: "qrc:/Pics/haschosen.png"
                       }

                       PropertyChanges {
                           target: proceedsection
                           visible: true
                       }

                       PropertyChanges {
                           target: proceed
                           text: i18n.tr("Done")
                       }

                       PropertyChanges {
                           target: proceed
                           color: UbuntuColors.midAubergine
                       }

                       PropertyChanges {
                           target: pageHeader
                           title: winnames[winneris] + i18n.tr(" wins!")
                       }

                       PropertyChanges {
                           target: wordses
                           text: ""
                       }

                       PropertyChanges {
                           target: rightpic
                           source: (winneris == 2) ? choice[wolfchoice] : choice[lunechoice]
                       }

                       PropertyChanges {
                           target: paperpic
                           source: (winneris == 2) ? choice[lunechoice] : choice[wolfchoice]
                       }
                   } //outcomestate

               ]

               Timer {
                   id: falsedramatimer
                   running: false
                   interval: dramatime
                   onTriggered:  { page0.state = "outcomestate"; screenflash.stop(); stonepicanimation.stop(); scissorspicanimation.stop(); paperpicanimation.stop(); if(soundon) applause.play() }

               } //falsedramatimer

               Timer {
                   id: stonepicanimation
                   interval: 333
                   running: false
                   repeat: true

                   onTriggered: {
                       stonepic.source = picchanger.picinc(0, stonecycle)
                   }

               } //stonepicanimation

               Timer {
                   id: scissorspicanimation
                   interval: 333
                   running: false
                   repeat: true

                   onTriggered: {
                       scissorspic.source = picchanger.picinc(1, scissorscycle)
                   }

               } //scissorspicanimation


               Timer {
                   id: paperpicanimation
                   interval: 333
                   running: false
                   repeat: true

                   onTriggered: {
                       paperpic.source = picchanger.picinc(2, papercycle)
                   }

               } //paperpicanimation

               Timer {
                   id: flashwriting
                   interval: 1000
                   running: false
                   repeat: true
                   onTriggered: {
                       if (wordses.visible == true)
                           wordses.visible = false
                       else
                           wordses.visible = true
                   }
               }


               Rectangle {
                   id: pagewrapper
                   width: parent.width
                   height: parent.height - pageHeader.height
                   anchors.top: pageHeader.bottom
                   color: bgcolour

                   Rectangle {
                       id: topsection
                       width: parent.width
                       height: parent.height/3
                       color: parent.color
                       anchors.top: parent.top

                       Rectangle {
                           id: leftpicrec
                           width: parent.width/3
                           height: parent.height
                           anchors.left: parent.left
                           color:  parent.color

                           Image {
                               id: leftpic
                               source: "qrc:/Pics/lune.png"
                               width: (pagewrapper.width > pagewrapper.height) ? parent.height/4 * 3 : parent.width/4 * 3
                               height: width
                               anchors.centerIn: parent

                           } //leftpic

                           Label {
                               id: scorelune
                               text: (lunescore > 0 || wolfscore > 0) ? lunescore : ""
                               anchors.bottom: parent.bottom
                               anchors.horizontalCenter: parent.horizontalCenter
                               font.pixelSize: units.gu(2)
                               font.bold: true
                               //font.family: "Purisa"
                               color: UbuntuColors.orange
                               visible: false

                           } //scorelune

                       } //leftpicrec

                       Rectangle {
                           id: middlepicrec
                           width: parent.width/3
                           height: parent.height
                           anchors.left: leftpicrec.right
                           color: parent.color

                           Image {
                               id: middlepic
                               source: "qrc:/Pics/vs.png"
                               width: (pagewrapper.width > pagewrapper.height) ? parent.height/4 * 3 : parent.width/4 * 3
                               height: width
                               anchors.centerIn: parent
                           }

                       } //middlepicrec

                       Rectangle {
                           id: rightpicrec
                           width: parent.width/3
                           height: parent.height
                           anchors.left: middlepicrec.right
                           color: parent.color

                           Image {
                               id: rightpic
                               source: "qrc:/Pics/wolfman.png"
                               width: (pagewrapper.width > pagewrapper.height) ? parent.height/4 * 3 : parent.width/4 * 3
                               height: width
                               anchors.centerIn: parent
                           }

                           Label {
                               id: scorewolf
                               text: (lunescore > 0 || wolfscore > 0) ? wolfscore : ""
                               anchors.bottom: parent.bottom
                               anchors.horizontalCenter: parent.horizontalCenter
                               font.pixelSize: units.gu(2)
                               font.bold: true
                               color: UbuntuColors.orange
                               visible: false

                           } //scorewolf

                       } //rightpicrec


                   } //topsection

                   Rectangle {
                       id: middlesection
                       width: parent.width
                       height: parent.height/6
                       color: parent.color
                       anchors.top: topsection.bottom

                       Rectangle {
                           id: writingrec
                           width: parent.width
                           height: parent.height
                           anchors.top: parent.top
                           color: parent.color

                           Label {
                               id: wordses
                               text: i18n.tr("The Electronic Decision Maker")
                               anchors.centerIn: parent
                               color: UbuntuColors.orange
                               font.pixelSize: units.gu(2)
                               wrapMode: Text.WordWrap

                           } //wordses

                       } //writingrec

                   } //middlesection

                   Rectangle {
                       id: bottomsection
                       width: parent.width
                       height: parent.height/3
                       color: parent.color
                       anchors.top: middlesection.bottom

                       Rectangle {
                           id: infobuttonrec
                           width: parent.width/2
                           height: parent.height/2
                           anchors.horizontalCenter: parent.horizontalCenter
                           color: parent.color

                           Button {
                               id: infobutton
                               text: i18n.tr("Info")
                               anchors.centerIn: parent
                               color: "#600000"

                               onClicked: { pageStack.push(page1) }
                           }
                       }

                       Rectangle {
                           id: playbuttonrec
                           width: parent.width/2
                           height: parent.height/2
                           anchors.horizontalCenter: parent.horizontalCenter
                           anchors.top: infobuttonrec.bottom
                           color: parent.color
                           visible: true

                           Button {
                               id: playbutton
                               text: i18n.tr("Play")
                               anchors.top: parent.top
                               anchors.horizontalCenter: parent.horizontalCenter
                               color: "#006000"

                               onClicked: {
                                   bgcolour = luneBGColour
                                   page0.state = "lunechoosestate"
                               }
                           } //playbutton

                       } //playbuttonrec

                       Rectangle {
                           id: choosesection
                           visible: false
                           anchors.fill: parent
                           color: parent.color

                           Rectangle {
                               id: stonerec
                               width: parent.width/3
                               height: parent.height
                               anchors.left: parent.left
                               color: parent.color

                               Image {
                                   id: stonepic
                                   source: "qrc:/Pics/stone.png"
                                   width: (pagewrapper.width > pagewrapper.height) ? parent.height/4 * 3 : parent.width/4 * 3
                                   height: width
                                   anchors.horizontalCenter: parent.horizontalCenter
                                   anchors.top: parent.top

                                   MouseArea {
                                       anchors.fill: parent

                                       onClicked: {

                                           if(page0.state == "lunechoosestate")
                                           {
                                               lunechoice = 0
                                               lunechoosed = true
                                               rightpic.source = "qrc:/Pics/choosedstone.png"

                                               if(soundon)
                                                   luneichoose.play()
                                           }

                                           if(page0.state == "wolfchoosestate")
                                           {
                                               wolfchoice = 0
                                               wolfchoosed = true
                                               rightpic.source = "qrc:/Pics/choosedstone.png"

                                               if(soundon)
                                                   wolfichoose.play()
                                           }
                                       }

                                   } // MouseArea

                               } //stonepic

                           } //stonerec

                           Rectangle {
                               id: scissorsrec
                               width: parent.width/3
                               height: parent.height
                               anchors.left: stonerec.right
                               color: parent.color

                               Image {
                                   id: scissorspic
                                   source: "qrc:/Pics/scissors.png"
                                   width: (pagewrapper.width > pagewrapper.height) ? parent.height/4 * 3 : parent.width/4 * 3
                                   height: width
                                   anchors.horizontalCenter: parent.horizontalCenter
                                   anchors.top: parent.top

                                   MouseArea {
                                       anchors.fill: parent

                                       onClicked: {

                                           if(page0.state == "lunechoosestate")
                                           {
                                               lunechoice = 1
                                               lunechoosed = true
                                               rightpic.source = "qrc:/Pics/choosedscissors.png"

                                               if(soundon)
                                                   luneichoose.play()
                                           }

                                           if(page0.state == "wolfchoosestate")
                                           {
                                               wolfchoice = 1
                                               wolfchoosed = true
                                               rightpic.source = "qrc:/Pics/choosedscissors.png"

                                               if(soundon)
                                                   wolfichoose.play()
                                           }

                                       } //onClicked

                                   } // MouseArea

                               } //scissorspic

                           } //scissorsrec

                           Rectangle {
                               id: paperrec
                               width: parent.width/3
                               height: parent.height
                               anchors.left: scissorsrec.right
                               color: parent.color

                               Image {
                                   id: paperpic
                                   source: "qrc:/Pics/paper.png"
                                   width: (pagewrapper.width > pagewrapper.height) ? parent.height/4 * 3 : parent.width/4 * 3
                                   height: width
                                   anchors.horizontalCenter: parent.horizontalCenter
                                   anchors.top: parent.top

                                   MouseArea {
                                       anchors.fill: parent

                                       onClicked: {

                                           if(page0.state == "lunechoosestate")
                                           {
                                               lunechoice = 2
                                               lunechoosed = true
                                               rightpic.source = "qrc:/Pics/choosedpaper.png"

                                               if(soundon)
                                                   luneichoose.play()
                                           }

                                           if(page0.state == "wolfchoosestate")
                                           {
                                               wolfchoice = 2
                                               wolfchoosed = true
                                               rightpic.source = "qrc:/Pics/choosedpaper.png"

                                               if(soundon)
                                                   wolfichoose.play()
                                           }
                                       }

                                   } //MouseArea

                               } //paperpic

                           } //paperrec

                       } //choosesection

                   } //bottomsection

                   Rectangle {
                       id: proceedsection
                       visible: false
                       width: parent.width
                       height: parent.height/6
                       anchors.top: bottomsection.bottom
                       color: parent.color


                       Button {
                           id: proceed
                           text: i18n.tr("Proceed")
                           color: UbuntuColors.orange
                           anchors.centerIn: parent

                           onClicked: {
                               if (page0.state == "lunechoosestate")
                                   if (lunechoosed)
                                   {
                                       if(soundon)
                                           luneichoosed.play()

                                       bgcolour = wolfBGColour
                                       page0.state = "wolfchoosestate"
                                   }


                               if (page0.state == "wolfchoosestate")
                                   if (wolfchoosed)
                                   {
                                       if(soundon)
                                           wolfichoosed.play()

                                       winneris = divinethis[lunechoice][wolfchoice]

                                       if (winneris == 1)
                                           lunescore++

                                       else if (winneris == 2)
                                           wolfscore++

                                       bgcolour = UbuntuColors.darkAubergine
                                       page0.state = "falsedramastate"
                                   }

                               if (page0.state == "outcomestate")
                               {
                                   wolfchoosed = false;
                                   lunechoosed = false;

                                   wordses.visible = true;

                                   page0.state = "splashstate";
                               }
                           }
                       }
                   } //proceedsection

               } //pagewrapper

           } //page0

           Page {
               id: page1
               visible: false

               header: PageHeader {
                   id: pageHeaderinfo
                   title: i18n.tr("SeTTinGs & InFO")
                   StyleHints {
                       foregroundColor: UbuntuColors.orange
                       backgroundColor: bgcolour
                       dividerColor: Qt.darker(bgcolour)
                   }

               } //pageHeader

               Rectangle {
                   id: page1wrapper
                   color: bgcolour
                   width: parent.width
                   height: parent.height - pageHeaderinfo.height
                   anchors.top: pageHeaderinfo.bottom

                   Flickable {
                       id: flickpage
                       width: parent.width
                       height: parent.height
                       contentWidth: parent.width
                       contentHeight: page1wrapper.height * 2.5 //flickable needs some extra room to ensure onscreen keyboard doesn't hide the dramaticpausemessage Textfield

                       Column {
                           id: flickcolumn
                           spacing: units.gu(2)
                           width: parent.width - units.gu(3)
                           height: parent.height
                           anchors.horizontalCenter: parent.horizontalCenter

                           Rectangle {
                               id: howtoplayheader
                               width: parent.width
                               height: page1wrapper.height/12
                               color: darkerAubergine
                               radius: 12

                               Label {
                                   id: htpheading
                                   text: i18n.tr("How To Play")
                                   anchors.centerIn: parent
                                   color: UbuntuColors.orange
                                   font.bold: true
                                   font.pixelSize: units.gu(2)
                               }

                           } //howtoplayheader

                           Label {
                               id: playtext
                               text: i18n.tr("sTOnScipAP is a game for 2 players that can help break the stalemate of a decision by utilising the time-old tradition of playing 'Stone, Scissors, Paper'.\n\nEach player makes their choice away from the prying eyes of their opponent and when the 2nd player has chosen and pressed 'Proceed', they can place the device down for both of them to see the drama unfold, the winner be unveiled and the decision be made...\n\nIn the fairly unlikely event of you never having played 'Stone, Scissors, Paper' before, then it might be handy to know the following:\n\nStone beats Scissors.  Scissors beats Paper.  Paper beats Stone.\n")
                               width: parent.width
                               wrapMode: Text.WordWrap
                               color: UbuntuColors.orange
                           }

                           Rectangle {
                               id: soundtogglerheader
                               width: parent.width
                               height: page1wrapper.height/12
                               color: darkerAubergine
                               radius: 12

                               Label {
                                   id: stheading
                                   text: i18n.tr("Sound")
                                   anchors.centerIn: parent
                                   color: UbuntuColors.orange
                                   font.bold: true
                                   font.pixelSize: units.gu(2)
                               }

                           } //soundtogglerheader

                           Rectangle {
                               id: soundtoggler
                               width: parent.width
                               height: page1wrapper.height/12
                               color: bgcolour

                               Label {
                                   id: soundtext
                                   text: (soundon) ? "Sounds ON" : "Sounds OFF"
                                   color: UbuntuColors.orange
                                   anchors.verticalCenter: parent.verticalCenter
                               }

                               Switch {
                                   id: soundonswitch
                                   checked: true
                                   anchors.verticalCenter: parent.verticalCenter
                                   anchors.right: parent.right

                                   onCheckedChanged: {
                                       soundon = soundonswitch.checked
                                   }
                               }

                           } //soundtoggler


                           Rectangle {
                               id: resetscoresheader
                               width: parent.width
                               height: page1wrapper.height/12
                               color: darkerAubergine
                               radius: 12

                               Label {
                                   id: rsheading
                                   text: i18n.tr("Scores")
                                   anchors.centerIn: parent
                                   color: UbuntuColors.orange
                                   font.bold: true
                                   font.pixelSize: units.gu(2)
                               }

                           } //resetscoresheader

                           Rectangle {
                               id: resetscores
                               width: parent.width
                               height: page1wrapper.height/12
                               color: bgcolour

                               Image {
                                   id:scorelunepic
                                   source: "qrc:/Pics/lune.png"
                                   height: parent.height
                                   width: height
                                   anchors.left: parent.left
                               }

                               Label {
                                   id: infoscorelune
                                   text: "  : " + lunescore
                                   color: UbuntuColors.orange
                                   anchors.left: scorelunepic.right
                                   anchors.verticalCenter: parent.verticalCenter
                                   font.pixelSize: units.gu(2)
                               }

                               Image {
                                   id:scorewolfpic
                                   source: "qrc:/Pics/wolfman.png"
                                   height: parent.height
                                   width: height
                                   anchors.left: infoscorelune.right
                                   anchors.leftMargin: units.gu(2)
                               }

                               Label {
                                   id: infoscorewolf
                                   text: "  : " + wolfscore
                                   color: UbuntuColors.orange
                                   anchors.verticalCenter: parent.verticalCenter
                                   anchors.left: scorewolfpic.right
                                   font.pixelSize: units.gu(2)
                                   //anchors.margins: units.gu(2)
                               }

                               Button {
                                   id: scoreresetbutton
                                   text: i18n.tr("Reset")
                                   color: "#600000"
                                   anchors.right: parent.right
                                   anchors.verticalCenter: parent.verticalCenter

                                   onClicked: {
                                       lunescore = 0
                                       wolfscore = 0
                                   }

                               } //scoreresetbutton

                           } //resetscores


                           Rectangle {
                               id: dramaticpauseheader
                               width: parent.width
                               height: page1wrapper.height/12
                               color: darkerAubergine
                               radius: 12

                               Label {
                                   id: dpheading
                                   text: i18n.tr("Dramatic Pause Length")
                                   anchors.centerIn: parent
                                   color: UbuntuColors.orange
                                   font.bold: true
                                   font.pixelSize: units.gu(2)
                               }

                           } //dramaticpauseheader

                           Rectangle {
                               id: dramaticpause
                               width: parent.width
                               height: page1wrapper.height/12
                               color: bgcolour

                               Label {
                                   id: dramaticvalue
                                   text: " " + dramatime/1000 + i18n.tr(" seconds")
                                   color: UbuntuColors.orange
                                   anchors.verticalCenter: parent.verticalCenter
                               }

                               Button {
                                   id: dramaplus
                                   text: "+"
                                   anchors.right: parent.right
                                   anchors.verticalCenter: parent.verticalCenter
                                   width: units.gu(6)
                                   color: "#006000"

                                   onClicked: {
                                       if (dramatime < 20000)
                                           dramatime += 1000
                                   }
                               } //dramaplus

                               Button {
                                   id: dramaminus
                                   text: "-"
                                   anchors.right: dramaplus.left
                                   anchors.rightMargin: units.gu(2)
                                   anchors.verticalCenter: parent.verticalCenter
                                   width: units.gu(6)
                                   color: "#005000"

                                   onClicked: {
                                       if (dramatime > 3000)
                                           dramatime -= 1000
                                   }
                               } //dramaminus

                           } //dramaticpause

                           Rectangle {
                               id: dramamessageheader
                               width: parent.width
                               height: page1wrapper.height/12
                               color: darkerAubergine
                               radius: 12

                               Label {
                                   id: dmheading
                                   text: i18n.tr("Dramatic Pause Message")
                                   anchors.centerIn: parent
                                   color: UbuntuColors.orange
                                   font.bold: true
                                   font.pixelSize: units.gu(2)
                               }

                           } //dramamessageheader

                           Rectangle {
                               id: dramamessagecurrent
                               width: parent.width
                               height: page1wrapper.height/12
                               color: bgcolour

                               Label {
                                   id: dmcurrent
                                   text: i18n.tr(dramaticpausemessage)
                                   color: UbuntuColors.orange
                                   anchors.centerIn: parent
                               }

                           } //dramamessagecurrent

                           Rectangle {
                               id: dramamessagechanger
                               width: parent.width
                               height: page1wrapper.height/12
                               color: bgcolour

                               TextField {
                                   id: messageinput
                                   width: parent.width/3 * 2
                                   anchors.left: parent.left
                                   anchors.verticalCenter: parent.verticalCenter
                                   placeholderText: dramaticpausemessage
                               }

                               Button {
                                   id:dramamessagebutton
                                   text: i18n.tr("Change")
                                   anchors.right: parent.right
                                   anchors.verticalCenter: parent.verticalCenter
                                   color: "#600000"

                                   onClicked: {
                                       dramaticpausemessage = messageinput.displayText
                                   }
                               } //dramamessagebutton

                           } //dramamessage

                       } //flickcolumn

                   } //flickpage

               } //page1wrapper

           } //page1

       } //pageStack
   } //mainView
