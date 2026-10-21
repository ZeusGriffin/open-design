@echo off
setlocal
title Night City Echoes - Save to Obsidian
cd /d "%~dp0"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0SAVE_TO_OBSIDIAN.ps1"
echo.
pause
