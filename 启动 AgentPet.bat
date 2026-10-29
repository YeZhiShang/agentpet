@echo off
chcp 936 >nul
cd /d "%~dp0"
start wscript.exe "%~dp0app\launch.vbs"
exit
