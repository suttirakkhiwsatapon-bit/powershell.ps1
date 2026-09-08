$correctKey = "ryzenxking"

$key = Read-Host "Enter License Key"

if ($key -eq $correctKey) {
    Write-Host "Key Correct! Running script..." -ForegroundColor Green
    Start-Sleep 2
    Write-Host "Script Running Successfully!"
} else {
    Write-Host "Wrong Key! Access Denied." -ForegroundColor Red
    Start-Sleep 3
    exit
}

# =========================================================================
# 1. NETWORK & TCP OPTIMIZATION (เน้นลด Ping / ส่งข้อมูลทันที)
# =========================================================================
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

# เพิ่มการปรับแต่ง Interface TCP โดยตรง
$interfacesPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
Get-ChildItem $interfacesPath | ForEach-Object {
    Set-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $_.PSPath -Name "TcpDelAckTicks" -Value 0 -Type DWord -ErrorAction SilentlyContinue
}

# =========================================================================
# 2. SYSTEM & MULTIMEDIA PRIORITY (ปลดล็อก Bandwidth และเน้นการประมวลผลเกม)
# =========================================================================
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

# CPU Priority ควบคุมกระบวนการดึงทรัพยากรไปที่เกมหลัก
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -Type DWord -Force

# =========================================================================
# 3. MOUSE & KEYBOARD INPUT RESPONSIVENESS (ลด Input Lag และเพิ่มความไว)
# =========================================================================
# ลด Queue Buffer เพื่อลดดีเลย์การป้อนข้อมูล
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" -Name "MouseDataQueueSize" -Value 20 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" -Name "KeyboardDataQueueSize" -Value 20 -Type DWord -Force

# ปิดการเร่งความเร็วเมาส์ (Mouse Acceleration) เพื่อให้การเล็งในเกม FPS เสถียรที่สุด
$mouseDesktop = "HKCU:\Control Panel\Mouse"
Set-ItemProperty -Path $mouseDesktop -Name "MouseSpeed" -Value "0" -Type String -Force
Set-ItemProperty -Path $mouseDesktop -Name "MouseThreshold1" -Value "0" -Type String -Force
Set-ItemProperty -Path $mouseDesktop -Name "MouseThreshold2" -Value "0" -Type String -Force
Set-ItemProperty -Path $mouseDesktop -Name "MouseSensitivity" -Value "10" -Type String -Force

# เพิ่มความไวการซ้ำปุ่มคีย์บอร์ด (ช่วยเรื่องปุ่มกดงัด/กดสกิลใน FiveM)
$keyboardDesktop = "HKCU:\Control Panel\Keyboard"
Set-ItemProperty -Path $keyboardDesktop -Name "KeyboardDelay" -Value "0" -Type String -Force
Set-ItemProperty -Path $keyboardDesktop -Name "KeyboardSpeed" -Value "31" -Type String -Force

# =========================================================================
# 4. GRAPHICS & DISPLAY OPTIMIZATION (ลด Latency ของหน้าจอและไดรเวอร์ GPU)
# =========================================================================
$dxgPath = "HKLM:\SYSTEM\CurrentControlSet\Services\DXGKrnl"
Set-ItemProperty -Path $dxgPath -Name "MonitorLatencyTolerance" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $dxgPath -Name "MonitorRefreshLatencyTolerance" -Value 0 -Type DWord -Force

# ปิด Game DVR และ Game Bar (สาเหตุหลักของอาการ FPS Drop และ Micro-Stuttering)
$gameBar = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR"
Set-ItemProperty -Path $gameBar -Name "AppCaptureEnabled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $gameBar -Name "HistoricalCaptureEnabled" -Value 0 -Type DWord -Force

$gameDVR = "HKCU:\System\GameConfigStore"
Set-ItemProperty -Path $gameDVR -Name "GameDVR_Enabled" -Value 0 -Type DWord -Force
Set-ItemProperty -Path $gameDVR -Name "GameDVR_FSEBehaviorMode" -Value 2 -Type DWord -Force
Set-ItemProperty -Path $gameDVR -Name "GameDVR_HonorUserFSEBehaviorMode" -Value 1 -Type DWord -Force
Set-ItemProperty -Path $gameDVR -Name "GameDVR_DXGIHonorFSEWindowsMode" -Value 1 -Type DWord -Force

Write-Host "Optimization Complete! Please restart your PC for all changes to take effect." -ForegroundColor Cyan
