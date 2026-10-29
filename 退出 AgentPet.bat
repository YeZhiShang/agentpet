@echo off
chcp 936 >nul
setlocal
set "DIR=%~dp0app"
powershell -NoProfile -ExecutionPolicy Bypass -File "%DIR%\runtime\stop-agent.ps1" -TargetDir "%DIR%"
timeout /t 1 >nul
exit
