# Run from PowerShell: powershell -ExecutionPolicy Bypass -File .\scripts\START-Z-LAUNCHER.ps1
$ErrorActionPreference = 'Stop'
Set-Location (Resolve-Path (Join-Path $PSScriptRoot '..'))
Write-Host "== Z Launcher: Windows setup ==" -ForegroundColor Magenta
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
  Write-Host 'Node.js LTS is required. Install from https://nodejs.org/en/download or run:' -ForegroundColor Yellow
  Write-Host 'winget install OpenJS.NodeJS.LTS'
  exit 1
}
if (-not (Get-Command npm.cmd -ErrorAction SilentlyContinue)) {
  Write-Host 'npm is missing. Repair the Node.js LTS installation.' -ForegroundColor Red
  exit 1
}
Write-Host ('Node: ' + (node --version))
Write-Host 'Installing application dependencies (first run requires internet)...'
& npm.cmd install
if ($LASTEXITCODE -ne 0) { throw 'Dependency installation failed.' }
Write-Host 'Checking application code and Steam parser...'
& npm.cmd run check
if ($LASTEXITCODE -ne 0) { throw 'Validation failed; startup aborted.' }
Write-Host 'Starting Z Launcher...'
& npm.cmd start
exit $LASTEXITCODE
