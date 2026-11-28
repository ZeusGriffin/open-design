@echo off
setlocal
title Night City Echoes - Voice Bridge Installer
set /p GAMEPATH=Cyberpunk 2077 game folder: 
echo Running safe preview first.
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install-VoiceBridge.ps1" -GamePath "%GAMEPATH%"
if errorlevel 1 goto done
echo.
choice /m "Proceed to interactive voice bridge installation (backs up existing files)"
if errorlevel 2 goto done
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install-VoiceBridge.ps1" -GamePath "%GAMEPATH%" -Install
:done
echo.
pause
