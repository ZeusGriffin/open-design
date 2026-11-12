@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Stage-CyberpunkVR-Update.ps1"
echo.
pause
