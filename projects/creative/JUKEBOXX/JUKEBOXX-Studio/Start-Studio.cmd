@echo off
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js is required. Install Node.js and run this again.
  pause
  exit /b 1
)
node "%~dp0server\studio-server.cjs"
