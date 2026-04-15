````markdown
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
````

3. **Install AutoHotkey v2**

   [https://www.autohotkey.com/](https://www.autohotkey.com/)

4. **Run the script**

   Double-click:

   ```
   X32MuteHotkeys.ahk
   ```

---

## 🎹 Default Hotkeys

| Hotkey  | Channel |
| ------- | ------- |
| Alt + 1 | 1       |
| Alt + 2 | 2       |
| Alt + 3 | 11      |
| Alt + 4 | 13      |
| Alt + 5 | 5       |
| Alt + 6 | 6       |
| Alt + 7 | 7       |
| Alt + 8 | 8       |
| Alt + 9 | 9       |
| Alt + 0 | 10      |

👉 You can edit these mappings inside `X32MuteHotkeys.ahk`.

---

## 🧪 Test / Health Check

Press:

```
F11
```

You should see:

```
X32 hotkey script is running.
```

---

## 🛠️ Customization

### Change or Add Hotkeys

Example:

```ahk
!q::RunToggle(3)     ; Alt + Q → Channel 3
```

### Toggle Multiple Channels

```ahk
!w::RunToggle(13,14) ; Alt + W → Channels 13 & 14
```

---

## 📡 How It Works

1. AutoHotkey detects a keypress
2. It runs:

   ```
   X32ToggleChannel.ps1
   ```
3. PowerShell sends an OSC message to:

   ```
   /ch/{channel}/mix/on
   ```
4. The mixer toggles the channel state

---

## ⚠️ Notes

* `Alt + number` may conflict with other applications
* Make sure:

  * Your PC and mixer are on the same network
  * Firewall allows outbound UDP on port `10023`
* X32 Edit software does **not** support custom mute hotkeys natively — this is a workaround

---

## 💡 Alternatives

* Bitfocus Companion (more advanced control)
* MIDI controllers with OSC bridges

---

## 📜 License

MIT License (or specify your preferred license)

---

## 🙌 Contributing

Feel free to:

* Add more hotkey presets
* Improve OSC handling
* Extend to other mixer functions (faders, sends, scenes)

```
```
