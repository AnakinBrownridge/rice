# anaRice

A lightweight Quickshell desktop rice for Hyprland, built to feel clean, minimal, and quick to reload.

This setup includes:
- a slim top bar with workspace indicators and clock
- Wi‑Fi status in the panel
- a first-run setup wizard for shell preferences
- a simple reload script to restart the Quickshell session

## Preview

This project is designed around a dark, low-noise aesthetic with teal accents and a compact status bar.

## Features

- Hyprland workspace tracking
- Quickshell-based top panel
- Real-time clock and Wi‑Fi detection
- Minimal onboarding flow for first-time setup
- Fast reload workflow for iterative tweaking

## Files

- `shell.qml` — main Quickshell panel UI
- `greeting.qml` — first-run setup dialog
- `reload.sh` — starts/reloads the Quickshell instance
- `backgrounds/` — wallpaper assets
- `anarice.slnx` — project solution metadata

## Requirements

- Hyprland
- Quickshell (`qs`)
- A supported font stack such as JetBrains Mono and Inter
- `nmcli` for Wi‑Fi status lookup

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/AnakinBrownridge/rice.git
   cd rice
   ```

2. Make sure Quickshell is installed and available in your PATH.

3. Launch the setup from your Hyprland session:
   ```bash
   qs -p "$HOME/.quickshell/anarice"
   ```

4. Or use the included reload script:
   ```bash
   ./reload.sh
   ```

## Customization

Most of the styling and layout is controlled in `shell.qml`. You can tweak:
- panel height and spacing
- colors and accent tones
- workspace labels and layout
- clock format
- Wi‑Fi label behavior

The first-time setup wizard is in `greeting.qml`, which can be modified to add more configuration steps or defaults.

## Notes

This project is a personal desktop setup and is intentionally simple. It is meant to be easy to read, easy to tweak, and quick to reload while iterating on the look and behavior.

## License

This project is licensed under the MIT License. See `LICENSE` for details.
