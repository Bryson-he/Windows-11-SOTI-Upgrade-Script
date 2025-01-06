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
   ```
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
```
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
```
Example Usage with SOTI

    Upload the script and Installation Assistant to SOTI.
    Use the following command in SOTI’s Run Script feature:

    powershell.exe -ExecutionPolicy Bypass -File "C:\Users\Public\Downloads\UpgradeToWindows11.ps1"

    Monitor deployment progress via the SOTI dashboard and check logs for troubleshooting.
