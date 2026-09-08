function Show-Menu {
    Clear-Host
    Write-Host @"
╔═╗┌─┐┌┐┌┌─┐   ╔═╗┌─┐┌┬┐┬┌┬┐┬┌─┐┌─┐┬─┐
╔═╝├┤ ││││─┼┐  ║ ║├─┘ │ │││││┌─┘├┤ ├┬┘
╚═╝└─┘┘└┘└─┘└  ╚═╝┴   ┴ ┴┴ ┴┴└─┘└─┘┴└─
"@ -ForegroundColor Cyan

    Write-Host "=========================================================" -ForegroundColor DarkGray
    Write-Host "         ZENQ OPTIMIZER & UTILITY SUITE                  " -ForegroundColor Yellow
    Write-Host "=========================================================" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host " [1] ZENQ Optimizer (FiveM & FPS Optimization)" -ForegroundColor Green
    Write-Host " [2] Clear History (PowerShell, CMD & Windows)" -ForegroundColor Red
    Write-Host " [3] Exit" -ForegroundColor Gray
    Write-Host ""
}

# -------------------------------------------------------------------------
# Check License Key
# -------------------------------------------------------------------------
Clear-Host
$correctKey = "key-zenq-x1tzy"
$key = Read-Host "Enter License Key"

if ($key -ne $correctKey) {
    Write-Host "Wrong Key! Access Denied." -ForegroundColor Red
    Start-Sleep -Seconds 3
    exit
}

Write-Host "Key Correct! Welcome..." -ForegroundColor Green
Start-Sleep -Seconds 1

# -------------------------------------------------------------------------
# Main Menu Loop
# -------------------------------------------------------------------------
do {
    Show-Menu
    $choice = Read-Host "Select Choice [1-3]"

    switch ($choice) {
        '1' {
            Clear-Host
            Write-Host "Running ZENQ Optimizer..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1

            # --- 1. NETWORK & TCP OPTIMIZATION ---
            netsh int tcp set global rss=enabled
            netsh int tcp set global autotuninglevel=normal
            netsh int tcp set global ecncapability=disabled
            netsh int tcp set global timestamps=disabled
            netsh int tcp set global rsc=disabled
            netsh int tcp set global fastopen=enabled

            # Global TCP Registry Tweaks
            Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f
            Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "1" /f
            Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f
            Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /t REG_DWORD /d "1" /f

            # --- 2. SYSTEM PROFILE & MULTIMEDIA TWEAKS ---
            Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f
            Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f

            # Games Profile Tweaks
            Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "8" /f
            Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "6" /f
            Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f
            Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f

            # Priority Control
            Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f

            Write-Host "Optimization Completed!" -ForegroundColor Green
            Start-Sleep -Seconds 2
        }
        '2' {
            Clear-Host
            Write-Host "Clearing History..." -ForegroundColor Yellow
            
            # Clear PowerShell History
            Remove-Item (Get-PSReadLineOption).HistorySavePath -ErrorAction SilentlyContinue
            
            # Clear Temp Files
            Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
            
            Write-Host "History & Temp Cleared!" -ForegroundColor Green
            Start-Sleep -Seconds 2
        }
        '3' {
            Write-Host "Exiting..." -ForegroundColor Gray
            exit
        }
        default {
            Write-Host "Invalid option, try again." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
} while ($choice -ne '3')
