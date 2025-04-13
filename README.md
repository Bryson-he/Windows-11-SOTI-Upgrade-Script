# Windows 11 Upgrade Script

## Overview
This PowerShell script automates the execution of the [Windows 11 Installation Assistant](https://www.microsoft.com/en-us/software-download/windows11) to silently upgrade devices to Windows 11. It is designed for seamless deployment with an MDM solution like **SOTI MobiControl**, enabling bulk upgrades across multiple devices while ensuring proper logging and error handling. The script is also compatible with manual execution using Task Scheduler or PowerShell.

## Why Use This Script?

Organizations face challenges upgrading devices to Windows 11 at scale:
- **Time-Consuming**: Manual upgrades require significant effort.
- **Compatibility Concerns**: Ensuring hardware compatibility across devices.
- **End-User Disruption**: Minimizing interruptions to user workflows.
- **Automation Needs**: Leveraging MDM solutions to push upgrades remotely.

### Benefits of This Script:
1. **Streamlined Process**: Automates the upgrade workflow using the [Windows 11 Installation Assistant](https://www.microsoft.com/en-us/software-download/windows11).
2. **Reduced Manual Effort**: Deploy and execute scripts via SOTI or Task Scheduler.
3. **Centralized Logging**: Provides clear logs for troubleshooting issues.

## Pre-Requisites

1. **Windows 11 Hardware Compatibility**: Ensure devices meet Windows 11 system requirements.
2. **Installation Assistant**: Place `Windows11InstallationAssistant.exe` at `C:\Users\Public\Downloads`. The script will launch it from that path.
3. **PowerShell Execution Policy**: Use the following to bypass restrictions if needed:
   ```powershell
   powershell.exe -ExecutionPolicy Bypass -File "C:\Users\Public\Downloads\Launch_Win11_Assistant.ps1"
   ```

## Deployment with SOTI MobiControl

### Step 1: Upload the Windows 11 Installation Assistant
- Push `Windows11InstallationAssistant.exe` to:
  ```
  C:\Users\Public\Downloads
  ```

### Step 2: Upload the PowerShell Script
- Save your script as `Launch_Win11_Assistant.ps1`
- Deploy it to:
  ```
  C:\Users\Public\Downloads
  ```

### Step 3: Trigger the Script via SOTI Script Send

Use this **PowerShell command** in the SOTI script console to execute the upgrade script immediately:
```powershell
Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `\"C:\Users\Public\Downloads\Launch_Win11_Assistant.ps1`\"" -WindowStyle Hidden -Verb RunAs
```

This ensures the script runs with elevated privileges, even in a user session.

## Script Contents

```powershell
# === Windows 11 Upgrade via Installation Assistant ===

$AssistantPath = "C:\Users\Public\Downloads\Windows11InstallationAssistant.exe"
$CustomLogFile = "C:\ProgramData\Windows11_Upgrade_CustomLog.txt"
$TranscriptFile = "C:\ProgramData\Windows11_Upgrade_Transcript.txt"

Start-Transcript -Path $TranscriptFile -Append

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

## Example Manual Use (Without SOTI)

1. Place both:
   - `Windows11InstallationAssistant.exe`
   - `Launch_Win11_Assistant.ps1`
   in `C:\Users\Public\Downloads`

2. Open PowerShell **as Administrator**

3. Run:
   ```powershell
   powershell.exe -ExecutionPolicy Bypass -File "C:\Users\Public\Downloads\Launch_Win11_Assistant.ps1"
   ```

## Logging
- Transcript: `C:\ProgramData\Windows11_Upgrade_Transcript.txt`
- Custom log: `C:\ProgramData\Windows11_Upgrade_CustomLog.txt`

## Contributing
Contributions are welcome! Please open issues or PRs with improvements, fixes, or enhancements.

