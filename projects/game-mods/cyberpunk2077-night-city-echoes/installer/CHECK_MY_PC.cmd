@echo off
setlocal
title Night City Echoes - Check only
cd /d "%~dp0"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install-NightCityEchoes.ps1" -Preview
echo.
pause
