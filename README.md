# X32/M32 Mute Hotkeys via OSC

This project provides global keyboard hotkeys for toggling mute states (ON/OFF) on Behringer X32 or Midas M32 mixing consoles. Since the **X32 EDIT** application does not support custom hotkeys, this solution uses **AutoHotkey (v2)** to trigger a **PowerShell** script that communicates with the mixer over UDP (OSC protocol).

## Prerequisites

* [cite_start]**AutoHotkey v2**: Download and install from [autohotkey.com](https://www.autohotkey.com/)[cite: 2].
* **PowerShell 5.1+**: Standard on Windows 10/11.
* **Network Access**: Your PC must be on the same network as the X32/M32 console.

## Setup

1.  Place `X32MuteHotkeys.ahk` and `X32ToggleChannel.ps1` in the same folder.
2.  Open `X32MuteHotkeys.ahk` in a text editor and update the `X32_IP` variable to match your console's IP address (default is set to `192.168.86.115`).
3.  Double-click `X32MuteHotkeys.ahk` to run the script.
4.  [cite_start](Optional) Press **F11** to confirm the script is active[cite: 13].

## Default Hotkeys

[cite_start]The script uses **Alt + Top Row Numbers** as global hotkeys[cite: 6]. Note that some keys are remapped to specific channels in the provided code:

| Hotkey | Target Channel |
| :--- | :--- |
| `Alt + 1` | [cite_start]Channel 1 [cite: 6] |
| `Alt + 2` | [cite_start]Channel 2 [cite: 7] |
| `Alt + 3` | [cite_start]**Channel 11** [cite: 8] |
| `Alt + 4` | [cite_start]**Channel 13** [cite: 9] |
| `Alt + 5` | [cite_start]Channel 5 [cite: 10] |
| `Alt + 6` | [cite_start]Channel 6 [cite: 10] |
| `Alt + 7` | [cite_start]Channel 7 [cite: 11] |
| `Alt + 8` | [cite_start]Channel 8 [cite: 11] |
| `Alt + 9` | [cite_start]Channel 9 [cite: 12] |
| `Alt + 0` | [cite_start]Channel 10 [cite: 12] |

## How it Works

1.  [cite_start]**AutoHotkey** captures the global keypress[cite: 3].
2.  [cite_start]It executes a hidden PowerShell command using `RunToggle()`[cite: 5].
3.  [cite_start]**PowerShell** sends an OSC query to the mixer at port `10023` to check the current mute state[cite: 3].
4.  It calculates the opposite state (Toggle) and sends the command back to the mixer.

## Troubleshooting

Logs are generated in your temporary folder to help diagnose issues:
[cite_start]`%TEMP%\x32-hotkeys.log` [cite: 5]
