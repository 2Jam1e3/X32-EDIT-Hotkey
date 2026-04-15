#Requires -Version 5.1
<#
.SYNOPSIS
  Toggle X32/M32 channel ON state via OSC (UDP port 10023).
  /ch/XX/mix/on : i 0 = channel OFF (muted), i 1 = channel ON (unmuted).

  X32 EDIT does not assign hotkeys for this; use AutoHotkey + this script, or Bitfocus Companion.

.PARAMETER Channel
  One or more channel numbers (1-32). Example: 13,14 toggles both channels.

.PARAMETER X32Host
  IP address of the console (same network as this PC).

.PARAMETER Port
  OSC UDP port (default 10023).
#>
param(
    [Parameter(Mandatory = $true)]
    [string[]]$Channel,

    [Parameter(Mandatory = $false)]
    [string]$X32Host = "192.168.1.1",

    [int]$Port = 10023
)

function Resolve-ChannelList {
    param([string[]]$InputValues)
    $out = New-Object System.Collections.Generic.List[int]
    foreach ($item in $InputValues) {
        if ($null -eq $item) { continue }
        foreach ($part in ($item -split '[,\s]+')) {
            if ([string]::IsNullOrWhiteSpace($part)) { continue }
            $n = 0
            if (-not [int]::TryParse($part, [ref]$n)) {
                throw "Invalid channel value '$part'. Use channel numbers 1-32."
            }
            if ($n -lt 1 -or $n -gt 32) {
                throw "Channel $n is out of range. Valid range is 1-32."
            }
            $out.Add($n)
        }
    }
    if ($out.Count -eq 0) {
        throw "No valid channel values were provided."
    }
    return $out.ToArray()
}

function Get-OscPaddedString {
    param([string]$Text)
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($Text)
    $buf = New-Object byte[] ($bytes.Length + 1)
    [Array]::Copy($bytes, $buf, $bytes.Length)
    $buf[$bytes.Length] = 0
    $pad = (4 - ($buf.Length % 4)) % 4
    if ($pad -gt 0) {
        $padded = New-Object byte[] ($buf.Length + $pad)
        [Array]::Copy($buf, $padded, $buf.Length)
        return ,$padded
    }
    return ,$buf
}

function Build-OscMessageInt {
    param([string]$Address, [int]$Value)
    $addr = Get-OscPaddedString $Address
    $typeTag = Get-OscPaddedString ",i"
    $intBytes = [BitConverter]::GetBytes([int32]$Value)
    if ([BitConverter]::IsLittleEndian) {
        [Array]::Reverse($intBytes)
    }
    $msg = New-Object byte[] ($addr.Length + $typeTag.Length + $intBytes.Length)
    [Array]::Copy($addr, 0, $msg, 0, $addr.Length)
    [Array]::Copy($typeTag, 0, $msg, $addr.Length, $typeTag.Length)
    [Array]::Copy($intBytes, 0, $msg, $addr.Length + $typeTag.Length, $intBytes.Length)
    return ,$msg
}

function Build-OscQuery {
    param([string]$Address)
    $addr = Get-OscPaddedString $Address
    $typeTag = Get-OscPaddedString ","
    $msg = New-Object byte[] ($addr.Length + $typeTag.Length)
    [Array]::Copy($addr, 0, $msg, 0, $addr.Length)
    [Array]::Copy($typeTag, 0, $msg, $addr.Length, $typeTag.Length)
    return ,$msg
}

function Read-OscIntFromResponse {
    param([byte[]]$Data)
    if ($null -eq $Data -or $Data.Length -lt 12) { return $null }
    # Find ",i" type tag; int follows the 4-byte padded type-tag string
    for ($i = 0; $i -lt $Data.Length - 5; $i++) {
        if ($Data[$i] -eq 0x2C -and $Data[$i + 1] -eq 0x69) {
            $intOffset = $i + 4
            if ($intOffset + 4 -le $Data.Length) {
                $b = $Data[$intOffset..($intOffset + 3)]
                if ([BitConverter]::IsLittleEndian) {
                    [Array]::Reverse($b)
                }
                return [BitConverter]::ToInt32($b, 0)
            }
        }
    }
    return $null
}

function Invoke-X32ToggleOne {
    param(
        [int]$ChNum,
        [string]$MixerHost,
        [int]$Port
    )
    $ch = "{0:D2}" -f $ChNum
    $path = "/ch/$ch/mix/on"
    $udp = New-Object System.Net.Sockets.UdpClient(0)
    try {
        $udp.Client.ReceiveTimeout = 800
        $query = Build-OscQuery $path
        $end = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any, 0)
        $null = $udp.Send($query, $query.Length, $MixerHost, $Port)
        try {
            $bytes = $udp.Receive([ref]$end)
        }
        catch {
            Write-Warning "No OSC reply from $MixerHost for $path (check IP, network, firewall, and console OSC port $Port)."
            return
        }
        $current = Read-OscIntFromResponse $bytes
        if ($null -eq $current) {
            Write-Warning "Could not parse OSC reply for $path; not changing."
            return
        }
        $next = if ($current -eq 0) { 1 } else { 0 }
        $set = Build-OscMessageInt $path $next
        $null = $udp.Send($set, $set.Length, $MixerHost, $Port)
    }
    finally {
        $udp.Close()
    }
}

foreach ($c in (Resolve-ChannelList -InputValues $Channel)) {
    Invoke-X32ToggleOne -ChNum $c -MixerHost $X32Host -Port $Port
}
