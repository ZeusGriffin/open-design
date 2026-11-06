# Night City Echoes — opt-in voice prototype installer (source-verified, v0.1).
# The DEFAULT action is read-only Preview. No unrelated mods/graphics files touched.
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
if (-not (Test-Path -LiteralPath $cet) -or -not (Test-Path -LiteralPath $red)) {
  throw 'CET and its RED4ext prerequisite must already be installed and working. This helper does not modify frameworks.'
}
$modDir = Join-Path $root 'bin\x64\plugins\cyber_engine_tweaks\mods\NightCityEchoes'
$modSrc = Join-Path $PSScriptRoot '..\mod'
$coreTarget = Join-Path $modDir 'core.lua'
$initTarget = Join-Path $modDir 'init.lua'
$voiceTarget = Join-Path $modDir 'voice_bridge.lua'
$baselineInitHash = '297d1820a7032c267941a91c414439256350cbfd212a153245e0f69bfb26c7b2'
$baselineCoreHash = '2a58ca6281ea64baa29d38811087f72e2702323c5e49428bbbc709dec7cef4ef'
if (-not (Test-Path -LiteralPath $coreTarget) -or -not (Test-Path -LiteralPath $initTarget)) {
  throw 'Install and test the original Night City Echoes memory journal before attempting voice.'
}
$coreHash = (Get-FileHash -LiteralPath $coreTarget -Algorithm SHA256).Hash.ToLowerInvariant()
if ($coreHash -ne $baselineCoreHash) {
  throw 'Existing core.lua differs from baseline. Stopping to protect installed custom modifications.'
}
$sourceInit = Join-Path $modSrc 'init.lua'
$sourceBridge = Join-Path $modSrc 'voice_bridge.lua'
foreach ($f in @($sourceInit,$sourceBridge)) {
  if (-not (Test-Path -LiteralPath $f -PathType Leaf)) { throw "Missing voice source: $f" }
}
$current = (Get-FileHash -LiteralPath $initTarget -Algorithm SHA256).Hash.ToLowerInvariant()
$newHash = (Get-FileHash -LiteralPath $sourceInit -Algorithm SHA256).Hash.ToLowerInvariant()
if ($current -ne $baselineInitHash -and $current -ne $newHash) {
  throw 'Installed init.lua has third-party edits. Do not overwrite; review and merge manually.'
}
Write-Host "Game patch: $version"
Write-Host "Existing baseline memory journal: present; core hash verified."
Write-Host "CET + RED4ext: present (check actual versions and overlay independently)."
Write-Host "Voice bridge target: $voiceTarget"
Write-Host "Voice implementation already installed: $($current -eq $newHash)"
Write-Host "PREVIEW: will back up NightCityEchoes Lua files and journal, then copy ONLY init.lua and voice_bridge.lua."
if (-not $Install) { Write-Host 'Preview only; no files changed.'; exit 0 }
if (Get-Process -Name Cyberpunk2077 -ErrorAction SilentlyContinue) { throw 'Exit Cyberpunk before installing.' }
$choice = Read-Host 'Type INSTALL_VOICE to confirm the two-file update (otherwise cancel)'
if ($choice -cne 'INSTALL_VOICE') { Write-Host 'Cancelled, nothing changed.'; exit 0 }
$backup = Join-Path ([Environment]::GetFolderPath('MyDocuments')) ('NightCityEchoes-Backups\voice-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Path $backup -Force | Out-Null
foreach ($f in @('init.lua','core.lua','voice_bridge.lua','night_city_echoes.json','voice_history.json')) {
  $existing = Join-Path $modDir $f
  if (Test-Path -LiteralPath $existing -PathType Leaf) {
    Copy-Item -LiteralPath $existing -Destination (Join-Path $backup $f) -Force
  }
}
Copy-Item -LiteralPath $sourceInit -Destination $initTarget -Force
Copy-Item -LiteralPath $sourceBridge -Destination $voiceTarget -Force
foreach ($entry in @(@($sourceInit,$initTarget),@($sourceBridge,$voiceTarget))) {
  if ((Get-FileHash -LiteralPath $entry[0] -Algorithm SHA256).Hash -ne
      (Get-FileHash -LiteralPath $entry[1] -Algorithm SHA256).Hash) {
    throw "Copy verification failed. Restore from backup folder: $backup"
  }
}
Write-Host "Voice bridge Lua files installed; backups at $backup" -ForegroundColor Green
Write-Host "Next, start Python companion manually, then bind Talk in CET. No game test has run yet."
