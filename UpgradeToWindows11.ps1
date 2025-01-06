# Define paths
$AssistantPath = "C:\Users\Public\Downloads\Windows11InstallationAssistant.exe"
$LogFile = "C:\ProgramData\Windows11_Upgrade_Log.txt"

# Log message function for output clarity
function LogMessage($Message) {
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$TimeStamp - $Message"
    Add-Content -Path $LogFile -Value "$TimeStamp - $Message"
}

# Start logging
LogMessage "=== Starting Windows 11 Upgrade Process ==="

# Check if the Installation Assistant executable exists
if (Test-Path $AssistantPath) {
    LogMessage "Windows 11 Installation Assistant found at: $AssistantPath"
    
    try {
        LogMessage "Starting the Installation Assistant in quiet mode..."

        # Run the Installation Assistant in quiet mode
        Start-Process -FilePath $AssistantPath -ArgumentList "/quietinstall /SkipEULA /SkipCompatCheck" -NoNewWindow -PassThru

        # Log that the process was initiated
        LogMessage "Windows 11 Installation process initiated. Please wait for the upgrade to complete."

    } catch {
        # Catch and log any errors during execution
        LogMessage "Error while running Windows 11 Installation Assistant: $_"
    }
} else {
    LogMessage "Error: Windows 11 Installation Assistant not found at: $AssistantPath"
}

# End of script logging
LogMessage "=== Script execution finished ==="
