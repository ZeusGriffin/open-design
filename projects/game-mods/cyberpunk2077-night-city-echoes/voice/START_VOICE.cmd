@echo off
setlocal
title Night City Echoes - Local Voice Companion
set /p GAMEPATH=Cyberpunk 2077 game folder: 
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Manage-Voice.ps1" -Action Run -GamePath "%GAMEPATH%"
echo.
pause
