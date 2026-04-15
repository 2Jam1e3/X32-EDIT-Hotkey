#Requires AutoHotkey v2.0
; Hotkeys for X32 channel mute toggle (ON/OFF) via OSC.
; Edit X32_IP to match your console. Install AutoHotkey v2 from https://www.autohotkey.com/
;
; X32 EDIT does not support custom mute hotkeys; this script calls X32ToggleChannel.ps1
; which talks to the mixer over UDP (port 10023).
;
; Global hotkeys (work even when X32 EDIT is minimized/unfocused).
; Note: Alt+number may conflict with other apps.

global X32_IP := "192.168.86.115"
global PS1 := A_ScriptDir "\X32ToggleChannel.ps1"

RunToggle(channels*) {
    local list := ""
    for i, c in channels {
        if (i > 1)
            list .= ","
        list .= c
    }
    local log := A_Temp "\x32-hotkeys.log"
    cmd := A_ComSpec ' /c powershell.exe -NoProfile -ExecutionPolicy Bypass -File "' PS1 '" -X32Host "' X32_IP '" -Channel "' list '" >> "' log '" 2>&1'
    Run cmd, , "Hide"
}

; Alt + top row (US layout: same physical keys with or without Shift)
!1::RunToggle(1)      ; 1 / !
!2::RunToggle(2)      ; 2 / @
!3::RunToggle(11)     ; 3 / #  -> channel 11
!4::RunToggle(13)     ; 4 / $  -> channel 13
!5::RunToggle(5)      ; 5 / %
!6::RunToggle(6)      ; 6 / ^
!7::RunToggle(7)      ; 7 / &
!8::RunToggle(8)      ; 8 / *
!9::RunToggle(9)      ; 9 / (
!0::RunToggle(10)     ; 0 / )  -> channel 10

; Health check: press F11 to confirm script is running.
F11::MsgBox "X32 hotkey script is running."
