import QtQuick 2.15
import calamares.slideshow 1.0

Presentation {
    id: presentation

    Timer {
        interval: 20000
        running: true
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0f172a"
        }
        Text {
            anchors.centerIn: parent
            width: parent.width * 0.8
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: "#f8fafc"
            font.pixelSize: 28
            text: qsTr("Installing jkOS\nAn Arch-based system with KDE Plasma")
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0f172a"
        }
        Text {
            anchors.centerIn: parent
            width: parent.width * 0.8
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: "#f8fafc"
            font.pixelSize: 26
            text: qsTr("Packages are downloaded from Arch Linux mirrors.\nKeep this machine online until setup finishes.")
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#0f172a"
        }
        Text {
            anchors.centerIn: parent
            width: parent.width * 0.8
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: "#f8fafc"
            font.pixelSize: 26
            text: qsTr("After reboot you will land in Plasma.\nUpdate with pacman or discover later.")
        }
    }
}
