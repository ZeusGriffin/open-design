@echo off
setlocal
title Night City Echoes - Read-only Voice Check
set /p GAMEPATH=Cyberpunk 2077 game folder: 
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Manage-Voice.ps1" -Action Check -GamePath "%GAMEPATH%"
echo.
pause
