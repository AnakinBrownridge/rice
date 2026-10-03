# anaRice

A lightweight Quickshell desktop rice for Hyprland, built to feel clean, minimal, and quick to reload.

This setup includes:
- a slim top bar with workspace indicators and clock
- Wi‑Fi status in the panel
- a first-run setup wizard for shell preferences
- a matching Rofi theme for launcher and app selection
- a simple reload script to restart the Quickshell session

## Preview

This project is designed around a dark, low-noise aesthetic with teal accents, soft contrast, and a compact status bar.

## Features

- Hyprland workspace tracking
- Quickshell-based top panel
- Real-time clock and Wi‑Fi detection
- Minimal onboarding flow for first-time setup
- Rofi theming for a polished launcher experience
- Fast reload workflow for iterative tweaking

## Files

- `shell.qml` — main Quickshell panel UI
- `greeting.qml` — first-run setup dialog
- `reload.sh` — starts/reloads the Quickshell instance
- `rofi/fancy2.rasi` — custom Rofi theme
- `backgrounds/` — wallpaper assets
- `anarice.slnx` — project solution metadata

## Requirements

- Hyprland
- Quickshell (`qs`)
- Rofi
- A supported font stack such as JetBrains Mono and Inter
- `nmcli` for Wi‑Fi status lookup

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/AnakinBrownridge/rice.git
   cd rice
   ```

2. Make sure Quickshell and Rofi are installed and available in your PATH.

3. Launch the setup from your Hyprland session:
   ```bash
   qs -p "$HOME/.quickshell/anarice"
   ```

4. Or use the included reload script:
   ```bash
   ./reload.sh
   ```

5. Apply the custom Rofi theme if you want the matching launcher styling:
   ```bash
   rofi -theme ~/.config/rofi/fancy2.rasi
   ```

   If your config is elsewhere, copy or symlink the theme into your Rofi config directory and load it from there.

## Customization

Most of the styling and layout is controlled in `shell.qml`. You can tweak:
- panel height and spacing
- colors and accent tones
- workspace labels and layout
- clock format
- Wi‑Fi label behavior

The first-time setup wizard is in `greeting.qml`, which can be modified to add more configuration steps or defaults.

The Rofi appearance is controlled in `rofi/fancy2.rasi`, which you can edit to match your preferred color palette and launcher density.

## Notes

This project is a personal desktop setup and is intentionally simple. It is meant to be easy to read, easy to tweak, and quick to reload while iterating on the look and behavior.

## License

This project is licensed under the MIT License. See `LICENSE` for details.
