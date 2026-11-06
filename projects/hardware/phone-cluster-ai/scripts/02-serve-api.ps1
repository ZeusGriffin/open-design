param(
    [Parameter(Mandatory = $true)]
    [string]$RoomLink,

    [string]$Token = ""
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    throw "Node.js is required. Run 00-preflight.ps1 first."
}

$nodeMajor = [int]((& node -p "process.versions.node.split('.')[0]").Trim())
if ($nodeMajor -lt 22) {
    throw "Pooled CLI requires Node.js 22 or newer."
}

if ($Token) {
    $env:POOLED_TOKEN = $Token
    Write-Host "Starting API bridge with token authentication..." -ForegroundColor Cyan
} else {
    Remove-Item Env:POOLED_TOKEN -ErrorAction SilentlyContinue
    Write-Host "Starting API bridge on localhost without a custom token..." -ForegroundColor Cyan
}

Write-Host "Room: $RoomLink"
Write-Host "OpenAI base URL will be http://127.0.0.1:8080/v1"
Write-Host "Press Ctrl+C to stop the bridge."
Write-Host ""

& npx -y "@pooled/cli" serve "$RoomLink"
if ($LASTEXITCODE -ne 0) {
    throw "Pooled API bridge exited with code $LASTEXITCODE"
}
