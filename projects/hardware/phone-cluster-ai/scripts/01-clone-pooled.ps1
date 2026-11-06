$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$vendorRoot = Join-Path $projectRoot "vendor"
$pooledRoot = Join-Path $vendorRoot "pooled"
$repoUrl = "https://github.com/Nehanth/pooled.git"
$pinnedCommit = "45b5ee275a8754a37fce4a6ce174f31e4a216ef4"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is required. Run 00-preflight.ps1 first."
}

if (-not (Test-Path $vendorRoot)) {
    New-Item -ItemType Directory -Path $vendorRoot | Out-Null
}

if (-not (Test-Path $pooledRoot)) {
    Write-Host "Cloning Pooled..." -ForegroundColor Cyan
    & git clone $repoUrl $pooledRoot
    if ($LASTEXITCODE -ne 0) {
        throw "git clone failed with exit code $LASTEXITCODE"
    }
}

Write-Host "Fetching pinned Pooled baseline..." -ForegroundColor Cyan
& git -C $pooledRoot fetch origin $pinnedCommit --depth 1
if ($LASTEXITCODE -ne 0) {
    throw "git fetch failed with exit code $LASTEXITCODE"
}

& git -C $pooledRoot checkout --detach $pinnedCommit
if ($LASTEXITCODE -ne 0) {
    throw "git checkout failed with exit code $LASTEXITCODE"
}

$actualCommit = (& git -C $pooledRoot rev-parse HEAD).Trim()

Write-Host ""
Write-Host "Pooled source is ready at:" -ForegroundColor Green
Write-Host "  $pooledRoot"
Write-Host "Pinned commit:"
Write-Host "  $actualCommit"
Write-Host ""
Write-Host "To study/run the local copy:" -ForegroundColor Cyan
Write-Host ('  cd "' + $pooledRoot + '"')
Write-Host "  npx -y serve -l 8080 ."
Write-Host ""
Write-Host "Then open http://localhost:8080/room on this PC."
