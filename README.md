# Windows 11 Upgrade Script

## Overview
This PowerShell script automates the execution of the Windows 11 Installation Assistant to silently upgrade devices to Windows 11. It is designed for seamless deployment with an MDM solution like **SOTI MobiControl**, enabling bulk upgrades across multiple devices while ensuring proper logging and error handling.

## Why Use This Script?
Many organizations face challenges when upgrading devices to Windows 11 at scale:
- **Time-Consuming**: Manual upgrades on each device require significant effort.
- **Compatibility Concerns**: Ensuring hardware compatibility across all devices.
- **End-User Disruption**: Minimizing interruptions to user workflows during upgrades.
- **Automation**: Leveraging existing MDM solutions to push upgrades remotely.

This script addresses these challenges by:
1. **Streamlining the Process**: Automating the upgrade workflow using the Windows 11 Installation Assistant.
2. **Reducing Manual Effort**: Easily deploying and executing scripts via SOTI or similar MDM systems.
3. **Centralized Logging**: Providing a clear, centralized log for troubleshooting any issues during the upgrade process.

## Pre-Requisites
- **Windows 11 Hardware Compatibility**: Devices must meet the Windows 11 system requirements.
- **Installation Assistant**: `Windows11InstallationAssistant.exe` must be available at `C:\Users\Public\Downloads`.
- **PowerShell Execution Policy**: May need to bypass restrictions with:
  ```powershell
  powershell.exe -ExecutionPolicy Bypass -File "C:\Path\To\Script.ps1"
