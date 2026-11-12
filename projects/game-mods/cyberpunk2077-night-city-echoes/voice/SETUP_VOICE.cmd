@echo off
setlocal
title Night City Echoes - Install Local AI Voice Requirements
echo This installs Python packages and downloads Ollama and Whisper models for local use.
echo It does not change Cyberpunk 2077 files.
pause
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Manage-Voice.ps1" -Action Setup
echo.
pause
