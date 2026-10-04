import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

ShellRoot {
  PanelWindow {
    anchors {
      top: true
      left: true
      right: true
    }
    implicitHeight: 30
    color: "050505"

    font: Font {
      family: "JetBrains Mono"
      letterSpacing: 0.5
      pixelSize: 14
      weight: 600
    }
  }

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 10
    anchors.rightMargin: 10

    RowLayout {
      spacing: 10

      Repeater {
        model: 9

        Text {
          property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
          text: (index + 1).toString()
          color: isActive ? "#20e3b9" : "#8abab0"

          font.family: "Inter"
          font.weight: isActive ? "600" : "400"
        }
      }

      Item { Layout.fillWidth: true }

      // Wi‑Fi display (Quickshell wiring)
      RowLayout {
        spacing: 8
        anchors.verticalCenter: parent.verticalCenter

        Text {
          id: wifiLabel
          text: "Wi‑Fi:"
          color: "#8abab0"
          font.family: "Inter"
          font.weight: "600"
        }

        Text {
          id: wifiName
          text: "—"
          color: "#20e3b9"
          font.family: "Inter"
          font.weight: "600"
        }

        // Quickshell wiring helper (uses Quickshell.wiring.run(command) -> Promise<string>)
        QtObject {
          id: qsAdapter
          function runNmcli() {
            wifiName.text = "…"
            if (typeof Quickshell !== "undefined" && Quickshell.wiring && typeof Quickshell.wiring.run === "function") {
              Quickshell.wiring.run("nmcli -t -f active,ssid dev wifi").then(function(output) {
                var ssid = "—"
                if (output) {
                  var lines = output.split(/\r?\n/)
                  for (var i = 0; i < lines.length; ++i) {
                    var cols = lines[i].split(":")
                    if (cols[0] === "yes" && cols[1]) { ssid = cols[1]; break }
                  }
                }
                wifiName.text = ssid
              }).catch(function() { wifiName.text = "—" })
            } else {
              // Fallback/no-op when Quickshell wiring is not available
              wifiName.text = "—"
            }
          }
        }

        Timer {
          id: wifiTimer
          interval: 5000
          repeat: true
          running: true
          onTriggered: qsAdapter.runNmcli()
        }
      }

      // Time display with shutdown menu trigger
      Rectangle {
        id: timeContainer
        Layout.fillWidth: false
        width: timeLabel.implicitWidth + 10
        height: 24
        color: "transparent"
        radius: 4

        Text {
          id: timeLabel
          anchors.centerIn: parent
          text: Qt.formatDateTime(clock.date(), "hh:mm:ss")
          color: "#20e3b9"
          font.family: "Inter"
          font.weight: "600"
        }

        MouseArea {
          anchors.fill: parent
          onClicked: {
            if ((mouse.modifiers & Qt.ControlModifier) && 
                (mouse.modifiers & Qt.AltModifier)) {
              shutdownMenu.visible = !shutdownMenu.visible
            }
          }
        }
      }

      SystemClock {
        id: clock
        percision: SystemClock.Second
      }

      // Shutdown menu popup
      Rectangle {
        id: shutdownMenu
        visible: false
        width: 150
        height: shutdownColumn.implicitHeight + 16
        color: "#1a1a1a"
        border.color: "#20e3b9"
        border.width: 2
        radius: 4
        anchors.right: timeContainer.right
        anchors.top: timeContainer.bottom
        anchors.topMargin: 8
        z: 1000

        Column {
          id: shutdownColumn
          anchors.fill: parent
          anchors.margins: 8
          spacing: 8

          ShutdownMenuItem {
            text: "Lock"
            onActivated: Quickshell.wiring.run("loginctl lock-session")
            shutdownMenu: shutdownMenu
          }

          ShutdownMenuItem {
            text: "Suspend"
            onActivated: Quickshell.wiring.run("systemctl suspend")
            shutdownMenu: shutdownMenu
          }

          ShutdownMenuItem {
            text: "Logout"
            onActivated: Quickshell.wiring.run("loginctl terminate-session")
            shutdownMenu: shutdownMenu
          }

          ShutdownMenuItem {
            text: "Reboot"
            onActivated: Quickshell.wiring.run("systemctl reboot")
            shutdownMenu: shutdownMenu
          }

          ShutdownMenuItem {
            text: "Shutdown"
            isDestructive: true
            onActivated: Quickshell.wiring.run("systemctl poweroff")
            shutdownMenu: shutdownMenu
          }
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          onExited: shutdownMenu.visible = false
        }
      }
    }
  }

  // Shutdown menu item component
  component ShutdownMenuItem: Rectangle {
    id: menuItem
    property string text: ""
    property bool isDestructive: false
    property var shutdownMenu: null
    signal activated()

    implicitWidth: menuItemText.implicitWidth + 16
    implicitHeight: menuItemText.implicitHeight + 8
    color: mouseArea.containsMouse ? "#2a2a2a" : "transparent"
    radius: 3

    Text {
      id: menuItemText
      anchors.centerIn: parent
      text: menuItem.text
      color: menuItem.isDestructive ? "#ff6b6b" : "#20e3b9"
      font.family: "Inter"
      font.weight: "500"
      font.pixelSize: 12
    }

    MouseArea {
      id: mouseArea
      anchors.fill: parent
      hoverEnabled: true
      onClicked: {
        menuItem.activated()
        if (menuItem.shutdownMenu) {
          menuItem.shutdownMenu.visible = false
        }
      }
    }
  }
}
