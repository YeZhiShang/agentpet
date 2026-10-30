@echo off
chcp 936 >nul
setlocal
set "TARGET_DIR=%~dp0app"
if "%TARGET_DIR:~-1%"=="\" set "TARGET_DIR=%TARGET_DIR:~0,-1%"
set "VBS_PATH=%TARGET_DIR%\launch.vbs"
set "ICON_PATH=%TARGET_DIR%\assets\claude.ico"
if not exist "%VBS_PATH%" (
    echo [错误] 未找到启动脚本: "%VBS_PATH%"
    echo 请把本脚本放在 AgentPet 根目录（app 文件夹旁边）后再运行。
    pause
    exit /b 1
)
if not exist "%ICON_PATH%" (
    echo [提示] 未找到图标 "%ICON_PATH%"，将使用默认图标。
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference = 'Stop'; $vbs = $env:VBS_PATH; $workDir = $env:TARGET_DIR; $icon = $env:ICON_PATH; $desktop = [Environment]::GetFolderPath('Desktop'); $lnkPath = Join-Path $desktop 'AgentPet.lnk'; $ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut($lnkPath); $s.TargetPath = 'wscript.exe'; $s.Arguments = [char]34 + $vbs + [char]34; $s.WorkingDirectory = $workDir; if (Test-Path $icon) { $s.IconLocation = $icon }; $s.Description = 'AgentPet'; $s.Save(); if (-not (Test-Path $lnkPath)) { throw ('快捷方式未生成: ' + $lnkPath) }; $chk = $ws.CreateShortcut($lnkPath); Write-Host ('[验证] 目标: ' + $chk.TargetPath); Write-Host ('[验证] 参数: ' + $chk.Arguments); Write-Host ('[验证] 目录: ' + $chk.WorkingDirectory); Write-Host ('[验证] 图标: ' + $chk.IconLocation)"
set "RC=%ERRORLEVEL%"
if not "%RC%"=="0" (
    echo.
    echo [错误] 创建桌面快捷方式失败，退出码: %RC%
    pause
    exit /b %RC%
)
echo.
echo [成功] 桌面快捷方式 [AgentPet] 已创建并验证！
pause
exit /b 0
