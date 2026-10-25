# Z-Firmware SF32 v0.1: download the exact LILYGO source and apply launcher patch.
# Run from a standard Windows PowerShell window. Does not flash or install SDK.
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Upstream = Join-Path $Root 'vendor\T-Display-SF32'
$Ref = '6f98f80d9ac4b147940593a9a2c2738586a4436e'  # LILYGO master 2026-09-17
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Install Git for Windows first: https://git-scm.com/downloads/win' }
if (-not (Get-Command py -ErrorAction SilentlyContinue)) { throw 'Install Python 3 for Windows first: https://www.python.org/downloads/windows/' }
if (-not (Test-Path (Join-Path $Upstream '.git'))) {
    New-Item -ItemType Directory -Path (Split-Path $Upstream -Parent) -Force | Out-Null
    git clone --filter=blob:none --no-checkout https://github.com/Xinyuan-LilyGO/T-Display-SF32.git $Upstream
    if ($LASTEXITCODE -ne 0) { throw 'LILYGO git clone failed' }
    git -C $Upstream fetch --depth 1 origin $Ref
    if ($LASTEXITCODE -ne 0) { throw 'Pinned LILYGO revision download failed' }
    git -C $Upstream checkout --detach FETCH_HEAD
    if ($LASTEXITCODE -ne 0) { throw 'Unable to check out pinned revision' }
}
# Prevent patching an unrelated or locally modified upstream checkout.
$Head = (git -C $Upstream rev-parse HEAD).Trim()
if ($Head -ne $Ref) { throw "Expected official commit $Ref; found $Head. Use a clean vendor folder." }
py -3 (Join-Path $Root 'apply_z.py') --upstream $Upstream
if ($LASTEXITCODE -ne 0) { throw 'Firmware patch validation failed. Do not flash.' }
Write-Host 'Z-Firmware source is prepared. Read README.md before building or flashing.' -ForegroundColor Green
