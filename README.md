# 🎛️ X32 Mute Hotkeys (AutoHotkey + PowerShell)

Control your **Behringer X32 / Midas M32** mixer channel mute states using global keyboard shortcuts.

This project provides a simple way to toggle channel **mute/unmute (ON/OFF)** via OSC using:
- **AutoHotkey v2** (for hotkeys)
- **PowerShell** (for OSC communication over UDP)

---

## ✨ Features

- Global hotkeys (work even when other apps are focused)
- Toggle one or multiple channels instantly
- Uses OSC over UDP (port `10023`)
- Lightweight, no external dependencies beyond PowerShell + AutoHotkey
- Easy to customize channel mappings

---

## 📁 Files

### `X32MuteHotkeys.ahk`
- Defines global keyboard shortcuts
- Calls the PowerShell script with selected channel(s)
- Logs output to a temp file

### `X32ToggleChannel.ps1`
- Sends OSC messages to the mixer
- Toggles `/ch/XX/mix/on` state:
  - `0` = OFF (muted)
  - `1` = ON (unmuted)
- Supports multiple channels at once

---

## ⚙️ Requirements

- Windows
- **AutoHotkey v2.0+**
- **PowerShell 5.1+**
- X32/M32 mixer on the same network

---

## 🚀 Setup

1. **Download / Clone the repository**

2. **Edit the mixer IP**

   Open `X32MuteHotkeys.ahk` and set:
   ```ahk
   global X32_IP := "192.168.86.115"
