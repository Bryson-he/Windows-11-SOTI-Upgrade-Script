# Ensure the script is running with administrative privileges
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Error "This script requires administrative privileges. Please run as Administrator."
    exit 1
}

# Define paths
$AssistantPath = "C:\Users\Public\Downloads\Windows11InstallationAssistant.exe"
$LogFile = "C:\ProgramData\Windows11_Upgrade_Log.txt"

# Optional: Start a transcript for complete logging
Start-Transcript -Path $LogFile -Append

# Log message function for output clarity
function LogMessage {
    param([string]$Message)
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$TimeStamp - $Message"
    Write-Output $LogEntry
    # You can still use Add-Content if you want duplicate logging
    Add-Content -Path $LogFile -Value $LogEntry
}

# Start logging
LogMessage "=== Starting Windows 11 Upgrade Process ==="

# Check if the Installation Assistant executable exists
if (Test-Path $AssistantPath) {
    LogMessage "Windows 11 Installation Assistant found at: $AssistantPath"
    
    try {
        LogMessage "Starting the Installation Assistant in quiet mode..."

        # Run the Installation Assistant in quiet mode, wait for it to exit, and capture the process
        $process = Start-Process -FilePath $AssistantPath `
                                 -ArgumentList "/quietinstall", "/SkipEULA", "/SkipCompatCheck" `
                                 -NoNewWindow -PassThru -Wait

        # Check exit code if available
        if ($process.ExitCode -eq 0) {
            LogMessage "Windows 11 Installation process completed successfully."
        }
        else {
            LogMessage "Windows 11 Installation process completed with exit code: $($process.ExitCode)"
        }
    } 
    catch {
        # Catch and log any errors during execution
        LogMessage "Error while running Windows 11 Installation Assistant: $_"
    }
}
else {
    LogMessage "Error: Windows 11 Installation Assistant not found at: $AssistantPath"
}

# End of script logging
LogMessage "=== Script execution finished ==="

# End transcript if used
Stop-Transcript
