# Night City Echoes — safe voice prototype installer (patch 2.5 only).
# Default action is READ-ONLY preview. Only installs 3 NightCityEchoes Lua files.
# No graphics, game executable, CET/RED4ext binaries, other mods or saves are modified.
[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$GamePath, [switch]$Install)
$ErrorActionPreference = 'Stop'
$GamePath = $GamePath.Trim('"').Trim()
$root = (Resolve-Path -LiteralPath $GamePath -ErrorAction Stop).Path
$exe = Join-Path $root 'bin\x64\Cyberpunk2077.exe'
if (-not (Test-Path -LiteralPath $exe -PathType Leaf)) { throw 'Cyberpunk2077.exe not found in GamePath.' }
$meta = (Get-Item -LiteralPath $exe).VersionInfo
$version = ([string]$meta.FileVersion + ' ' + [string]$meta.ProductVersion) -replace '[,\s]+','.'
if ($version -notmatch '3\.0\.88\.46235|(^|[^0-9])2\.5([^0-9]|$)') {
  throw "Voice prototype install blocked for unverified game patch: $version"
}

$cet = Join-Path $root 'bin\x64\plugins\cyber_engine_tweaks.asi'
$red = Join-Path $root 'red4ext\RED4ext.dll'
if (-not (Test-Path -LiteralPath $cet -PathType Leaf) -or
    -not (Test-Path -LiteralPath $red -PathType Leaf)) {
  throw 'Required CET/RED4ext files not detected. Inspect working framework installation first; this installer never modifies frameworks.'
}
$modDir = Join-Path $root 'bin\x64\plugins\cyber_engine_tweaks\mods\NightCityEchoes'
$modSrc = (Resolve-Path (Join-Path $PSScriptRoot '..\mod')).Path
$expectedCore = '2a58ca6281ea64baa29d38811087f72e2702323c5e49428bbbc709dec7cef4ef'
$baselineInit = '297d1820a7032c267941a91c414439256350cbfd212a153245e0f69bfb26c7b2'
$allowed = @('init.lua','core.lua','voice_bridge.lua')
$sourceHashes = @{}
foreach ($f in $allowed) {
  $src = Join-Path $modSrc $f
  if (-not (Test-Path -LiteralPath $src -PathType Leaf)) { throw "Voice project source missing: $src" }
  $sourceHashes[$f] = (Get-FileHash -LiteralPath $src -Algorithm SHA256).Hash.ToLowerInvariant()
}
if ($sourceHashes['core.lua'] -ne $expectedCore) {
  throw 'Unexpected core.lua source. Stop to protect the original memory journal baseline.'
}

$present = @()
$missing = @()
$matching = @()
foreach ($f in $allowed) {
  $target = Join-Path $modDir $f
  if (-not (Test-Path -LiteralPath $target -PathType Leaf)) {
    $missing += $f
    continue
  }
  $present += $f
  $actual = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant()
  if ($actual -eq $sourceHashes[$f]) {
    $matching += $f
  } elseif ($f -eq 'init.lua' -and $actual -eq $baselineInit) {
    Write-Host 'Original memory-only init.lua detected. Voice update is compatible with this baseline.' -ForegroundColor Yellow
  } else {
    throw "Existing $f has unknown/custom changes. Stop instead of overwriting: $target"
  }
}
$journalPath = Join-Path $modDir 'night_city_echoes.json'
$journalPresent = Test-Path -LiteralPath $journalPath -PathType Leaf
Write-Host "Game: $root"
Write-Host "Build: $version"
Write-Host 'CET and RED4ext: detected (runtime compatibility still requires in-game verification).'
Write-Host "NightCityEchoes folder: $modDir"
Write-Host ("Present: " + ($present -join ', '))
Write-Host ("Already up to date: " + ($matching -join ', '))
Write-Host ("Missing: " + ($missing -join ', '))
Write-Host "Journal exists: $journalPresent (will be preserved)"
if (-not $Install) {
  Write-Host 'PREVIEW COMPLETE: no files changed. Run again with -Install only after CET actually opens in game.'
  exit 0
}
if (Get-Process -Name Cyberpunk2077 -ErrorAction SilentlyContinue) { throw 'Exit Cyberpunk before installing.' }
$confirmation = Read-Host 'Type CET_OK only after confirming the CET overlay worked in game on patch 2.5'
if ($confirmation -cne 'CET_OK') { Write-Host 'Cancelled; no files changed.'; exit 0 }
$choice = Read-Host 'Type INSTALL_VOICE to backup and install the three Lua mod files'
if ($choice -cne 'INSTALL_VOICE') { Write-Host 'Cancelled; no files changed.'; exit 0 }

$backup = Join-Path ([Environment]::GetFolderPath('MyDocuments')) ('NightCityEchoes-Backups\voice-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Path $backup -Force | Out-Null
foreach ($f in @('init.lua','core.lua','voice_bridge.lua','night_city_echoes.json','voice_request.json','voice_response.json','voice_history.json')) {
  $existing = Join-Path $modDir $f
  if (Test-Path -LiteralPath $existing -PathType Leaf) {
    Copy-Item -LiteralPath $existing -Destination (Join-Path $backup $f) -Force
  }
}
$receipt = [ordered]@{
  gamePath=$root
  backupPath=$backup
  existingFiles=@($present)
  installedAt=(Get-Date).ToString('o')
  sourceHashes=$sourceHashes
  version='voice-0.1-first-test'
}
($receipt | ConvertTo-Json -Depth 5) | Set-Content -LiteralPath (Join-Path $backup 'manifest.json') -Encoding UTF8
New-Item -ItemType Directory -Path $modDir -Force | Out-Null
foreach ($f in $allowed) {
  $src = Join-Path $modSrc $f
  $dst = Join-Path $modDir $f
  Copy-Item -LiteralPath $src -Destination $dst -Force
  $dstHash = (Get-FileHash -LiteralPath $dst -Algorithm SHA256).Hash.ToLowerInvariant()
  if ($dstHash -ne $sourceHashes[$f]) {
    throw "Copy hash verification failed for $f. Restore existing files from backup: $backup"
  }
}
Write-Host "INSTALLED: Night City Echoes memory + voice Lua files. Backup: $backup" -ForegroundColor Green
Write-Host 'This is not yet a successful game/voice test. Start the local Python companion before using Talk.'
