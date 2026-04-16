# X32/M32 Mute Hotkeys via OSC

This project provides global keyboard hotkeys for toggling mute states (ON/OFF) on Behringer X32 or Midas M32 mixing consoles. Since the **X32 EDIT** application does not support custom hotkeys, this solution uses **AutoHotkey (v2)** to trigger a **PowerShell** script that communicates with the mixer over UDP (OSC protocol).

## Prerequisites

* **AutoHotkey v2**: Download and install from [autohotkey.com](https://www.autohotkey.com/).
* **PowerShell 5.1+**: Standard on Windows 10/11.
* **Network Access**: Your PC must be on the same network as the X32/M32 console.

## Setup

1.  Place `X32MuteHotkeys.ahk` and `X32ToggleChannel.ps1` in the same folder.
2.  Open `X32MuteHotkeys.ahk` in a text editor and update the `X32_IP` variable to match your console's IP address (default is set to `192.168.86.115`).
3.  Double-click `X32MuteHotkeys.ahk` to run the script.
4.  (Optional) Press **F11** to confirm the script is active.

## Default Hotkeys

The script uses **Alt + Top Row Numbers** as global hotkeys. Note that some keys are remapped to specific channels in the provided code:

| Hotkey | Target Channel |
| :--- | :--- |
| `Alt + 1` | Channel 1 |
| `Alt + 2` | Channel 2 |
| `Alt + 3` | **Channel 11** |
| `Alt + 4` | **Channel 13** |
| `Alt + 5` | Channel 5 |
| `Alt + 6` | Channel 6 |
| `Alt + 7` | Channel 7 |
| `Alt + 8` | Channel 8 |
| `Alt + 9` | Channel 9 |
| `Alt + 0` | Channel 10 |

## Troubleshooting

Logs are generated in your temporary folder to help diagnose issues:
`%TEMP%\x32-hotkeys.log`
