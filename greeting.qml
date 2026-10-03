import Quickshell
import Qt.labs.settings 1.1

Dialog {
	id: wizard
	modal: true
	visible: !settings.firstTimeCompleted
	title: "Let's begin setting up anaRice."
	standardButtons: Dialog.NoButton
	width: 720
	height: 480

	Settings {
		id: settings
		property bool firstTimeCompleted: false
		property string preferredShell: "ohmyzsh"
	}

	property int step: 0
	property int stepCount: 3

	signal finishedSuccessfully()

	function nextStep() {
		if (step < stepCount - 1) step++
	}
	function prevStep() {
		if (step > 0) step--
	}

	ColumnLayout {
		anchors.fill: parent
		spacing: 12
		padding: 16

		// Header
		RowLayout {
			Layout.fillWidth: true
			Label {
				text: wizard.title
				font.pixelSize: 20
				Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
			}
			Spacer { Layout.fillWidth: true }
			Button {
				text: "Skip"
				onClicked: {
					settings.firstTimeCompleted = true
					wizard.close()
				}
			}
		}

		// Content area (simple step pages)
		StackLayout {
			id: pages
			Layout.fillWidth: true
			Layout.fillHeight: true
			currentIndex: step

			// Step 0: Welcome
			Item {
				ColumnLayout {
					anchors.fill: parent
					Label { text: "Welcome to Quickshell Rice"; font.pixelSize: 18 }
					TextArea { readOnly: true; text: "This wizard will help you configure Quickshell for the first time."; Layout.preferredHeight: 120 }
				}
			}

			// Step 1: Choose shell
			Item {
				ColumnLayout {
					anchors.fill: parent
					Label { text: "Preferred Shell" }
					ComboBox {
						model: ["bash", "zsh", "pwsh"]
						currentIndex: model.indexOf(settings.preferredShell)
						onCurrentTextChanged: settings.preferredShell = currentText
						Layout.preferredWidth: 300
					}
				}
			}

			// Step 2: Summary
			Item {
				ColumnLayout {
					anchors.fill: parent
					Label { text: "Summary" }
					TextArea {
						readOnly: true
						text:
							"Preferred shell: " + settings.preferredShell + "\n"
						Layout.preferredHeight: 140
					}
				}
			}
		}

		// Footer with navigation
		RowLayout {
			Layout.fillWidth: true
			Spacer { Layout.preferredWidth: 8 }
			Button {
				text: "Back"
				enabled: step > 0
				onClicked: prevStep()
			}
			Button {
				text: step === stepCount - 1 ? "Finish" : "Next"
				onClicked: {
					if (step === stepCount - 1) {
						settings.firstTimeCompleted = true
						wizard.finishedSuccessfully()
						wizard.close()
					} else nextStep()
				}
			}
		}
	}
}