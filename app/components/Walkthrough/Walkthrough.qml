/*
 * Copyright (C) 2014-2015
 *      Andrew Hayzen <ahayzen@gmail.com>
 *      Nekhelesh Ramananthan <nik90@ubuntu.com>
 *      Victor Thompson <victor.thompson@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Upstream location:
 * https://github.com/krnekhelesh/flashback
 */

import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

Page {
    id: walkthrough

    // Property to set the app name used in the walkthrough
    property string appName

    // Property to check if this is the first run or not
    property bool isFirstRun: true

    // Property to store the slides shown in the walkthrough (Each slide is a component defined in a separate file for simplicity)
    property list<Component> model

    // Property to signal walkthrough completion
    signal finished

    // ListView to show the slides
    ListView {
        id: listView
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: slideIndicator.top
        }

        model: walkthrough.model
        snapMode: ListView.SnapOneItem
        orientation: Qt.Horizontal
        highlightMoveDuration: UbuntuAnimation.FastDuration
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightFollowsCurrentItem: true

        delegate: Item {
            width: listView.width
            height: listView.height
            clip: true

            Loader {
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    margins: units.gu(2)
                    top: parent.top
                }
                sourceComponent: modelData
                width: units.gu(36)
            }
        }
    }

    // Label to skip the walkthrough.
    Label {
        id: skipLabel

        color: "white"
        fontSize: "medium"
        objectName: "skipLabel"
        text: i18n.tr("Skip")
        visible: listView.currentIndex !== 2
        width: contentWidth

        anchors {
            bottom: parent.bottom
            left: parent.left
            margins: units.gu(2)
        }
    }

    MouseArea {
        anchors {
            bottom: parent.bottom
            horizontalCenter: skipLabel.horizontalCenter
        }
        height: units.gu(6)
        visible: listView.currentIndex !== 2
        width: skipLabel.width + skipLabel.anchors.margins*2

        onClicked: walkthrough.finished()

        Rectangle {
            anchors {
                fill: parent
            }
            color: "#FFF"
            opacity: parent.pressed ? 0.1 : 0

            Behavior on opacity {
                UbuntuNumberAnimation {
                    duration: UbuntuAnimation.FastDuration
                }
            }
        }
    }

    // Indicator element to represent the current slide of the walkthrough
    Row {
        id: slideIndicator
        height: units.gu(6)
        spacing: units.gu(2)
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        Repeater {
            model: walkthrough.model.length
            delegate: Image {
                anchors.verticalCenter: parent.verticalCenter
                antialiasing: true
                height: width
                source: listView.currentIndex == index ?  "../../graphics/Ellipse@27.png" : "../../graphics/Ellipse_15_opacity@27.png"
                width: units.gu(1.5)
            }
        }
    }

    Icon {
        id: nextIcon
        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: units.gu(2)
        }
        color: "white"
        height: units.gu(2)
        name: "chevron"
        visible: listView.currentIndex !== 2
        width: height
    }

    MouseArea {
        anchors {
            bottom: parent.bottom
            horizontalCenter: nextIcon.horizontalCenter
        }
        height: units.gu(6)
        visible: listView.currentIndex !== 2
        width: height

        onClicked: listView.currentIndex++

        Rectangle {
            anchors {
                fill: parent
            }
            color: "#FFF"
            opacity: parent.pressed ? 0.1 : 0

            Behavior on opacity {
                UbuntuNumberAnimation {
                    duration: UbuntuAnimation.FastDuration
                }
            }
        }
    }
}
