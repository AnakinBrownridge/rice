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

      Text {
        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date(), "hh:mm:ss")
      }

      SystemClock {
        id: clock
        percision: SystemClock.Second
      }
    }
  }
}