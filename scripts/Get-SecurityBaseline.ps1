[CmdletBinding()]
param(
    [Parameter()]
    [string]$OutputPath = ".\security-baseline.local.csv"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$results = [System.Collections.Generic.List[object]]::new()

function Add-BaselineResult {
    param(
        [string]$Control,
        [string]$Observed,
        [string]$Desired,
        [string]$Status,
        [string]$Notes
    )

    $results.Add([pscustomobject]@{
        CheckedAt = (Get-Date).ToString("o")
        Control   = $Control
        Observed  = $Observed
        Desired   = $Desired
        Status    = $Status
        Notes     = $Notes
    })
}

# Firewall profile state
try {
    $profiles = @(Get-NetFirewallProfile -ErrorAction Stop)
    $disabledProfiles = @($profiles | Where-Object { -not $_.Enabled })

    if ($profiles.Count -eq 0) {
        Add-BaselineResult "Windows Firewall" "No profiles returned" "Required profiles enabled" "REVIEW" "No profile state was returned."
    }
    elseif ($disabledProfiles.Count -eq 0) {
        Add-BaselineResult "Windows Firewall" "All returned profiles enabled" "Required profiles enabled" "PASS" "Confirm against the device's approved policy."
    }
    else {
        $names = ($disabledProfiles | ForEach-Object { $_.Name }) -join ", "
        Add-BaselineResult "Windows Firewall" "Disabled profiles: $names" "Required profiles enabled" "REVIEW" "Confirm policy and investigate before changing configuration."
    }
}
catch {
    Add-BaselineResult "Windows Firewall" "Not available" "Required profiles enabled" "NOT AVAILABLE" $_.Exception.Message
}

# Microsoft Defender status, where available
try {
    $defender = Get-MpComputerStatus -ErrorAction Stop
    $serviceEnabled = [bool]$defender.AMServiceEnabled
    $realTimeEnabled = [bool]$defender.RealTimeProtectionEnabled
    $observed = "AMServiceEnabled=$serviceEnabled; RealTimeProtectionEnabled=$realTimeEnabled"

    if ($serviceEnabled -and $realTimeEnabled) {
        Add-BaselineResult "Microsoft Defender" $observed "Protection enabled or approved equivalent present" "PASS" "Check organizational policy and any approved third-party endpoint protection."
    }
    else {
        Add-BaselineResult "Microsoft Defender" $observed "Protection enabled or approved equivalent present" "REVIEW" "A managed device may use another approved product; verify policy before concluding."
    }
}
catch {
    Add-BaselineResult "Microsoft Defender" "Status query unavailable" "Protection enabled or approved equivalent present" "NOT AVAILABLE" $_.Exception.Message
}

# UAC registry value
try {
    $uac = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA -ErrorAction Stop
    $enabled = ([int]$uac.EnableLUA -eq 1)

    Add-BaselineResult "User Account Control (UAC)" "EnableLUA=$($uac.EnableLUA)" "EnableLUA=1, subject to policy" $(if ($enabled) { "PASS" } else { "REVIEW" }) "Compare with the organization's endpoint baseline."
}
catch {
    Add-BaselineResult "User Account Control (UAC)" "Registry value unavailable" "EnableLUA=1, subject to policy" "NOT AVAILABLE" $_.Exception.Message
}

# Remote Desktop setting
try {
    $rdp = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name fDenyTSConnections -ErrorAction Stop
    $rdpDisabled = ([int]$rdp.fDenyTSConnections -eq 1)

    Add-BaselineResult "Remote Desktop" "fDenyTSConnections=$($rdp.fDenyTSConnections)" "Remote Desktop disabled unless approved" $(if ($rdpDisabled) { "PASS" } else { "REVIEW" }) "If remote access is required, confirm approved access controls and exposure."
}
catch {
    Add-BaselineResult "Remote Desktop" "Registry value unavailable" "Remote Desktop disabled unless approved" "NOT AVAILABLE" $_.Exception.Message
}

$resolvedOutput = [System.IO.Path]::GetFullPath($OutputPath)
$parentDirectory = Split-Path -Parent $resolvedOutput

if ($parentDirectory -and -not (Test-Path -LiteralPath $parentDirectory)) {
    New-Item -ItemType Directory -Path $parentDirectory -Force | Out-Null
}

$results | Export-Csv -LiteralPath $resolvedOutput -NoTypeInformation -Encoding UTF8
$results | Format-Table Control, Status, Observed -AutoSize

Write-Host ""
Write-Host "Baseline report saved to: $resolvedOutput" -ForegroundColor Green
Write-Host "This is a limited read-only check, not a full security audit." -ForegroundColor Yellow
Write-Host "Review and sanitize identifying information before sharing." -ForegroundColor Yellow
