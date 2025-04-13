# === Windows 11 Assistant Launch Script with Logging ===

$AssistantPath = "C:\Users\Public\Downloads\Windows11InstallationAssistant.exe"
$LogFile = "C:\ProgramData\Windows11_Upgrade_CustomLog.txt"
$TranscriptFile = "C:\ProgramData\Windows11_Upgrade_Transcript.txt"

# Start logging
Start-Transcript -Path $TranscriptFile -Append

function LogMessage {
    param([string]$Message)
    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Entry = "$Time - $Message"
    Write-Output $Entry
    Add-Content -Path $LogFile -Value $Entry
}

LogMessage "=== Launching Windows 11 Assistant from Scheduled Task ==="

if (Test-Path $AssistantPath) {
    LogMessage "Assistant located: $AssistantPath"
    
    $Args = "/Install /SkipEULA /SkipCompatCheck /QuietInstall /NoRestartUI /UninstallUponExit /SetPriorityLow /ShowProgressInTaskBarIcon"
    
    try {
        LogMessage "Launching Assistant with arguments: $Args"
        $process = Start-Process -FilePath $AssistantPath `
                                 -ArgumentList $Args `
                                 -NoNewWindow `
                                 -PassThru `
                                 -Wait
        LogMessage "Assistant exited with code: $($process.ExitCode)"
    } catch {
        LogMessage "❌ Failed to launch Assistant: $_"
    }
} else {
    LogMessage "❌ Assistant not found at: $AssistantPath"
}

LogMessage "=== Script finished ==="
Stop-Transcript
