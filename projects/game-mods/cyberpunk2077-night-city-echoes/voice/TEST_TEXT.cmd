@echo off
setlocal
title Night City Echoes - Local Voice Typed Test
echo Run START_VOICE.cmd in a separate window first.
set /p GAMEPATH=Cyberpunk 2077 game folder: 
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Manage-Voice.ps1" -Action TextTest -GamePath "%GAMEPATH%"
echo.
pause
