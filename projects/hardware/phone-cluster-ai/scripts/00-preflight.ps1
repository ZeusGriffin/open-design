$ErrorActionPreference = "Stop"

Write-Host "=== Phone Cluster AI Preflight ===" -ForegroundColor Cyan

function Require-Command {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [string]$InstallHint = ""
    )

    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if (-not $cmd) {
        Write-Host "[FAIL] $Name was not found." -ForegroundColor Red
        if ($InstallHint) {
            Write-Host "       $InstallHint"
        }
        exit 1
    }

    Write-Host "[ OK ] $Name -> $($cmd.Source)" -ForegroundColor Green
}

Require-Command -Name "git" -InstallHint "Install Git for Windows, then reopen PowerShell."
Require-Command -Name "node" -InstallHint "Install Node.js 22 or newer."
Require-Command -Name "npx" -InstallHint "npx is installed with Node.js."

$nodeVersion = (& node -p "process.versions.node").Trim()
$nodeMajor = [int]($nodeVersion.Split(".")[0])

Write-Host "[INFO] Node.js version: $nodeVersion"

if ($nodeMajor -lt 22) {
    Write-Host "[FAIL] Pooled CLI requires Node.js 22 or newer." -ForegroundColor Red
    exit 1
}

Write-Host "[ OK ] Node.js requirement satisfied." -ForegroundColor Green

try {
    $npmVersion = (& npm --version).Trim()
    Write-Host "[ OK ] npm -> $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "[WARN] npm check failed, but npx was found." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Preflight passed." -ForegroundColor Green
Write-Host "Next: open https://pooled.run/room and create a Qwen3 1.7B room."
