$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$vendorRoot = Join-Path $projectRoot "vendor"
$pooledRoot = Join-Path $vendorRoot "pooled"
$repoUrl = "https://github.com/Nehanth/pooled.git"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is required. Run 00-preflight.ps1 first."
}

if (-not (Test-Path $vendorRoot)) {
    New-Item -ItemType Directory -Path $vendorRoot | Out-Null
}

if (-not (Test-Path $pooledRoot)) {
    Write-Host "Cloning Pooled..." -ForegroundColor Cyan
    & git clone --depth 1 $repoUrl $pooledRoot
    if ($LASTEXITCODE -ne 0) {
        throw "git clone failed with exit code $LASTEXITCODE"
    }
} else {
    Write-Host "Pooled already exists. Updating with fast-forward only..." -ForegroundColor Cyan
    & git -C $pooledRoot pull --ff-only
    if ($LASTEXITCODE -ne 0) {
        throw "git pull failed with exit code $LASTEXITCODE"
    }
}

Write-Host ""
Write-Host "Pooled source is ready at:" -ForegroundColor Green
Write-Host "  $pooledRoot"
Write-Host ""
Write-Host "To study/run the local copy:" -ForegroundColor Cyan
Write-Host "  cd \"$pooledRoot\""
Write-Host "  npx -y serve -l 8080 ."
Write-Host ""
Write-Host "Then open http://localhost:8080/room on this PC."
