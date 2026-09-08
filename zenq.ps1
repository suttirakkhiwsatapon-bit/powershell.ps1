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
$correctKey = "ryzenxking"
$key = Read-Host "Enter License Key"

if ($key -ne $correctKey) {
    Write-Host "Wrong Key! Access Denied." -ForegroundColor Red
    Start-Sleep 3
    exit
}

Write-Host "Key Correct! Welcome..." -ForegroundColor Green
Start-Sleep 1

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
            Start-Sleep 1

            # --- 1. NETWORK & TCP OPTIMIZATION ---
            $tcpPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
            Set-ItemProperty -Path $tcpPath -Name "TcpAckFrequency" -Value 1 -Type DWord -Force
            Set-ItemProperty -Path $tcpPath -Name "TcpDelAckTicks" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $tcpPath -Name "TCPNoDelay" -Value 1 -Type DWord -Force
            Set-ItemProperty -Path $tcpPath -Name "TcpWindowSize" -Value 1079576 -Type DWord -Force
            Set-ItemProperty -Path $tcpPath -Name "SackOpts" -Value 1 -Type DWord -Force
            Set-ItemProperty -Path $tcpPath -Name "TcpMaxDataRetransmissions" -Value 2 -Type DWord -Force
            Set-ItemProperty -Path $tcpPath -Name "TCPTimedWaitDelay" -Value 30 -Type DWord -Force
            Set-ItemProperty -Path $tcpPath -Name "DefaultTTL" -Value 64 -Type DWord -Force
            Set-ItemProperty -Path $tcpPath -Name "KeepAliveTime" -Value 30000 -Type DWord -Force
            Set-ItemProperty -Path $tcpPath -Name "KeepAliveInterval" -Value 1000 -Type DWord -Force
            Set-ItemProperty -Path $tcpPath -Name "GlobalMaxTcpWindowSize" -Value 1079576 -Type DWord -Force
            Set-ItemProperty -Path $tcpPath -Name "MaxUserPort" -Value 65534 -Type DWord -Force

            $interfacesPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
            Get-ChildItem $interfacesPath | ForEach-Object {
                Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 -Type DWord -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $_.PSPath -Name "TcpDelAckTicks" -Value 0 -Type DWord -ErrorAction SilentlyContinue
            }

            # --- 2. SYSTEM & MULTIMEDIA PRIORITY ---
            $sysProfile = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
            Set-ItemProperty -Path $sysProfile -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord -Force
            Set-ItemProperty -Path $sysProfile -Name "SystemResponsiveness" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $sysProfile -Name "AlawaysOn" -Value 1 -Type DWord -Force

            $tasksGames = "$sysProfile\Tasks\Games"
            Set-ItemProperty -Path $tasksGames -Name "Affinity" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $tasksGames -Name "Background Only" -Value "False" -Type String -Force
            Set-ItemProperty -Path $tasksGames -Name "Clock Rate" -Value 10000 -Type DWord -Force
            Set-ItemProperty -Path $tasksGames -Name "GPU Priority" -Value 8 -Type DWord -Force
            Set-ItemProperty -Path $tasksGames -Name "Priority" -Value 6 -Type DWord -Force
            Set-ItemProperty -Path $tasksGames -Name "Scheduling Category" -Value "High" -Type String -Force
            Set-ItemProperty -Path $tasksGames -Name "SFIO Priority" -Value "High" -Type String -Force
            Set-ItemProperty -Path $tasksGames -Name "Latency Sensitive" -Value "True" -Type String -Force

            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -Type DWord -Force

            # --- 3. MOUSE & KEYBOARD INPUT RESPONSIVENESS ---
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" -Name "MouseDataQueueSize" -Value 20 -Type DWord -Force
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" -Name "KeyboardDataQueueSize" -Value 20 -Type DWord -Force

            $mouseDesktop = "HKCU:\Control Panel\Mouse"
            Set-ItemProperty -Path $mouseDesktop -Name "MouseSpeed" -Value "0" -Type String -Force
            Set-ItemProperty -Path $mouseDesktop -Name "MouseThreshold1" -Value "0" -Type String -Force
            Set-ItemProperty -Path $mouseDesktop -Name "MouseThreshold2" -Value "0" -Type String -Force
            Set-ItemProperty -Path $mouseDesktop -Name "MouseSensitivity" -Value "10" -Type String -Force

            $keyboardDesktop = "HKCU:\Control Panel\Keyboard"
            Set-ItemProperty -Path $keyboardDesktop -Name "KeyboardDelay" -Value "0" -Type String -Force
            Set-ItemProperty -Path $keyboardDesktop -Name "KeyboardSpeed" -Value "31" -Type String -Force

            # --- 4. GRAPHICS & DISPLAY OPTIMIZATION ---
            $dxgPath = "HKLM:\SYSTEM\CurrentControlSet\Services\DXGKrnl"
            Set-ItemProperty -Path $dxgPath -Name "MonitorLatencyTolerance" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $dxgPath -Name "MonitorRefreshLatencyTolerance" -Value 0 -Type DWord -Force

            $gameBar = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR"
            Set-ItemProperty -Path $gameBar -Name "AppCaptureEnabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $gameBar -Name "HistoricalCaptureEnabled" -Value 0 -Type DWord -Force

            $gameDVR = "HKCU:\System\GameConfigStore"
            Set-ItemProperty -Path $gameDVR -Name "GameDVR_Enabled" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $gameDVR -Name "GameDVR_FSEBehaviorMode" -Value 2 -Type DWord -Force
            Set-ItemProperty -Path $gameDVR -Name "GameDVR_HonorUserFSEBehaviorMode" -Value 1 -Type DWord -Force
            Set-ItemProperty -Path $gameDVR -Name "GameDVR_DXGIHonorFSEWindowsMode" -Value 1 -Type DWord -Force

            Write-Host ""
            Write-Host "Optimization Complete! Please restart your PC." -ForegroundColor Green
            Read-Host "Press Enter to return to menu..."
        }

        '2' {
            Clear-Host
            Write-Host "Clearing History and Temporary Data..." -ForegroundColor Yellow
            Start-Sleep 1

            # 1. Clear PowerShell Session & History File
            Clear-History
            $psHistoryPath = (Get-PSReadLineOption).HistorySavePath
            if (Test-Path $psHistoryPath) {
                Remove-Item $psHistoryPath -Force -ErrorAction SilentlyContinue
            }

            # 2. Clear Run Dialog History (Win + R)
            Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name * -ErrorAction SilentlyContinue

            # 3. Clear Recent Files & Jump Lists
            Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Recurse -Force -ErrorAction SilentlyContinue

            # 4. Clear Temp Files
            Remove-Item "$env:LOCALAPPDATA\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

            Write-Host ""
            Write-Host "All History Successfully Cleared!" -ForegroundColor Green
            Read-Host "Press Enter to return to menu..."
        }

        '3' {
            Write-Host "Exiting ZENQ Optimizer..." -ForegroundColor Yellow
            Start-Sleep 1
            exit
        }

        default {
            Write-Host "Invalid Option! Please try again." -ForegroundColor Red
            Start-Sleep 1
        }
    }
} while ($choice -ne '3')
