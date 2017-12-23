/***************************************************************************
 *   Copyright (C) 2015 Kai Uwe Broulik <kde@privat.broulik.de>            *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1 as Controls

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.sessions 2.0

import "../components"

Item {
    id: root

    signal dismissed
    signal ungrab

    SessionsModel {
        id: sessionsModel
        showNewSessionEntry: true

        // the calls takes place asynchronously; if we were to dismiss the dialog right
        // after startNewSession/switchUser we would be destroyed before the reply
        // returned leaving us do nothing (Bug 356945)
        onStartedNewSession: root.dismissed()
        onSwitchedUser: root.dismissed()

        onAboutToLockScreen: root.ungrab()
    }

    Controls.Action {
        onTriggered: root.dismissed()
        shortcut: "Escape"
    }

    BreezeBlock {
        id: brblock
        height: units.largeSpacing * 14
        width: screenGeometry.width
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
        }

        main: SessionManagementScreen {
            id: block
            anchors {
                top: parent.verticalCenter
            }

            userListModel: sessionsModel

            Item {
                Layout.fillWidth: true
                height: buttons.height

                RowLayout {
                    id: buttons
                    anchors.centerIn: parent

                    PlasmaComponents.Button {
                        id: cancelButton
                        text: i18nd("plasma_lookandfeel_rosa.fresh.lookandfeel","Cancel")
                        Layout.preferredWidth: Math.max(commitButton.implicitWidth, cancelButton.implicitWidth)
                        onClicked: root.dismissed()
                    }
                    PlasmaComponents.Button {
                        id: commitButton
                        text: i18nd("plasma_lookandfeel_rosa.fresh.lookandfeel","Switch")
                        visible: sessionsModel.count > 0
                        Layout.preferredWidth: Math.max(commitButton.implicitWidth, cancelButton.implicitWidth)
                        onClicked: {
                            sessionsModel.switchUser(block.userListCurrentModelData.vtNumber, sessionsModel.shouldLock)
                        }
                            Controls.Action {
                            onTriggered: commitButton.clicked()
                            shortcut: "Return"
                        }
                        Controls.Action {
                            onTriggered: commitButton.clicked()
                            shortcut: "Enter" // on numpad
                        }
                    }
                }
            }
        }
    }
}
