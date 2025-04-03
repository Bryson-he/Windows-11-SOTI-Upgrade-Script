# Define paths
$AssistantPath = "C:\Users\Public\Downloads\Windows11InstallationAssistant.exe"
$CustomLogFile = "C:\ProgramData\Windows11_Upgrade_CustomLog.txt"
$TranscriptFile = "C:\ProgramData\Windows11_Upgrade_Transcript.txt"

# Start transcript logging to a separate file
Start-Transcript -Path $TranscriptFile -Append

# Log message function for output clarity (writes only to custom log)
function LogMessage {
    param([string]$Message)
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$TimeStamp - $Message"
    Write-Output $LogEntry
    Add-Content -Path $CustomLogFile -Value $LogEntry
}

LogMessage "=== Starting Windows 11 Upgrade Process ==="

if (Test-Path $AssistantPath) {
    LogMessage "Windows 11 Installation Assistant found at: $AssistantPath"
    
    try {
        LogMessage "Starting the Installation Assistant in quiet mode..."
        $process = Start-Process -FilePath $AssistantPath `
                                 -ArgumentList "/quietinstall", "/SkipEULA", "/SkipCompatCheck" `
                                 -NoNewWindow -PassThru -Wait
        if ($process.ExitCode -eq 0) {
            LogMessage "Windows 11 Installation process completed successfully."
        } else {
            LogMessage "Windows 11 Installation process completed with exit code: $($process.ExitCode)"
        }
    } catch {
        LogMessage "Error while running Windows 11 Installation Assistant: $_"
    }
} else {
    LogMessage "Error: Windows 11 Installation Assistant not found at: $AssistantPath"
}

LogMessage "=== Script execution finished ==="
Stop-Transcript
