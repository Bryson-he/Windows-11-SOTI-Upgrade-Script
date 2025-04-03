# Windows 11 Upgrade Script

## Overview
This PowerShell script automates the execution of the [Windows 11 Installation Assistant](https://www.microsoft.com/en-us/software-download/windows11) to silently upgrade devices to Windows 11. It is designed for seamless deployment with an MDM solution like **SOTI MobiControl**, enabling bulk upgrades across multiple devices while ensuring proper logging and error handling. The version of the Installation Assistant used in this script is included in the GitHub repository.

## Why Use This Script?
Organizations face challenges upgrading devices to Windows 11 at scale:
- **Time-Consuming**: Manual upgrades require significant effort.
- **Compatibility Concerns**: Ensuring hardware compatibility across devices.
- **End-User Disruption**: Minimizing interruptions to user workflows.
- **Automation Needs**: Leveraging MDM solutions to push upgrades remotely.

### Benefits of This Script:
1. **Streamlined Process**: Automates the upgrade workflow using the [Windows 11 Installation Assistant](https://www.microsoft.com/en-us/software-download/windows11).
2. **Reduced Manual Effort**: Deploy and execute scripts via SOTI or similar MDM systems.
3. **Centralized Logging**: Provides clear logs for troubleshooting issues.

## Pre-Requisites
1. **Windows 11 Hardware Compatibility**: Ensure devices meet Windows 11 system requirements.
2. **Installation Assistant**: Place `Windows11InstallationAssistant.exe` at `C:\Users\Public\Downloads`. The version used in this script is provided in the GitHub repository.
3. **PowerShell Execution Policy**: Use the following to bypass restrictions if needed:
   ```powershell
   powershell.exe -ExecutionPolicy Bypass -File "C:\Path\To\Script.ps1"
   ```
4. **MDM Solution**: Verify that your MDM supports file deployment and PowerShell script execution.

## Deployment with SOTI MobiControl
**Step 1**: Upload the Windows 11 Installation Assistant

    Upload Windows11InstallationAssistant.exe to your MDM system.
    Set the destination path to: C:\Users\Public\Downloads

**Step 2**: Upload the PowerShell Script

    Save the script as UpgradeToWindows11.ps1.
    Upload the script to your MDM system.
    Ensure paths are correctly set:
        Installation Assistant: C:\Users\Public\Downloads\Windows11InstallationAssistant.exe
        Log File: C:\ProgramData\Windows11_Upgrade_Log.txt

**Step 3**: Execute the Script

    Push the script to devices using your MDM’s Run Script feature.
    Use the following command:

    powershell.exe -ExecutionPolicy Bypass -File "C:\Users\Public\Downloads\UpgradeToWindows11.ps1"

    Monitor logs at: C:\ProgramData\Windows11_Upgrade_Log.txt

**Script Content**

Below is the complete PowerShell script for automating the Windows 11 upgrade process:
```powershell
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
```
## Example Usage with SOTI

1. **Upload and Deploy the Script**:
   - Copy and paste the `UpgradeToWindows11.ps1` script into the **Managed Scripts** section of SOTI MobiControl.
   - Push the script to devices individually or in bulk, depending on your deployment needs.

2. **Setting Up a Scheduled Upgrade**:
   - To automate the upgrade process at a specific time, create a **package** that deploys the `Windows11InstallationAssistant.exe` to the correct location (`C:\Users\Public\Downloads`).
   - Create a **profile** to deploy this package to the target devices.
   - Use SOTI's **Task Scheduler** to schedule the execution of the PowerShell script (`UpgradeToWindows11.ps1`) at a specified time, ensuring the upgrade happens without manual intervention.

3. **Monitoring Deployment**:
   - Monitor the progress of the upgrade through the SOTI dashboard.
   - Review the logs to troubleshoot any issues by checking the log file located at `C:\ProgramData\Windows11_Upgrade_Log.txt` on the target devices.

## Contributing
Contributions are welcome! If you have ideas for improvements or run into issues, please open an issue or submit a pull request.
