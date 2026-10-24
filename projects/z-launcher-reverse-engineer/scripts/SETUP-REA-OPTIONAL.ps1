# Optional developer-only setup. Not required for Z Launcher.
$ErrorActionPreference = 'Stop'
if (-not (Get-Command npx.cmd -ErrorAction SilentlyContinue)) {
  Write-Host 'Install Node.js LTS first: https://nodejs.org/en/download' -ForegroundColor Yellow
  exit 1
}
Write-Host 'REA installs an MCP server in the coding agent you choose.' -ForegroundColor Yellow
Write-Host 'Review its configuration changes and download approvals before accepting.'
Write-Host 'Official project: https://github.com/morluto/rea'
$answer = Read-Host 'Launch the interactive official REA setup now? (type YES)'
if ($answer -cne 'YES') { Write-Host 'Cancelled. No configuration changes requested.'; exit 0 }
& npx.cmd rea-agents@latest setup
exit $LASTEXITCODE
