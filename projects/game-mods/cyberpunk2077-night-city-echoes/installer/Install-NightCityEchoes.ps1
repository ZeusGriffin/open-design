# Night City Echoes - cautious Windows installer v0.3 (patch 2.5 first test)
# Original project by 9 to 5 Studios / ZeusGriffin.
# Only copies this project's init.lua and core.lua; never modifies game executable.
[CmdletBinding()]
param(
  [string]$GamePath = "",
  [switch]$Preview,
  [switch]$Uninstall
)
$ErrorActionPreference = "Stop"
$modRel = "bin\x64\plugins\cyber_engine_tweaks\mods\NightCityEchoes"
$source = Join-Path $PSScriptRoot ("payload\" + $modRel)
# Work both from extracted test ZIP and from a checked-out repository.
$repoSource = Join-Path $PSScriptRoot '..\mod'
if (-not (Test-Path -LiteralPath $source -PathType Container) -and
    (Test-Path -LiteralPath (Join-Path $repoSource 'init.lua') -PathType Leaf) -and
    (Test-Path -LiteralPath (Join-Path $repoSource 'core.lua') -PathType Leaf)) {
  $source = $repoSource
}
# Expected exact SHA-256 of the original GitHub Lua source files.
$expected = @{
  'init.lua' = '297d1820a7032c267941a91c414439256350cbfd212a153245e0f69bfb26c7b2'
  'core.lua' = '2a58ca6281ea64baa29d38811087f72e2702323c5e49428bbbc709dec7cef4ef'
}
$docs = "https://wiki.redmodding.org/cyber-engine-tweaks/getting-started/installing"
$cet = "https://github.com/maximegmd/CyberEngineTweaks/releases/latest"
$red4 = "https://github.com/WopsS/RED4ext/releases/latest"

function Is-GameRoot([string]$p) {
  return ($p -and (Test-Path -LiteralPath (Join-Path $p "bin\x64\Cyberpunk2077.exe") -PathType Leaf))
}
function Pick-GameRoot {
  $candidates = New-Object 'System.Collections.Generic.List[string]'
  foreach ($drive in (Get-PSDrive -PSProvider FileSystem)) {
    $root = $drive.Root
    foreach ($suffix in @(
      "SteamLibrary\steamapps\common\Cyberpunk 2077",
      "Program Files (x86)\Steam\steamapps\common\Cyberpunk 2077",
      "Steam\steamapps\common\Cyberpunk 2077",
      "GOG Games\Cyberpunk 2077",
      "Program Files\Epic Games\Cyberpunk2077",
      "Epic Games\Cyberpunk2077",
      "Games\Cyberpunk 2077"
    )) {
      $candidate = Join-Path $root $suffix
      if (Is-GameRoot $candidate) { $candidates.Add($candidate) }
    }
  }
  $valid = @($candidates | Select-Object -Unique)
  if ($valid.Count -eq 1) { return $valid[0] }
  if ($valid.Count -gt 1) {
    Write-Host "Found multiple installs:"
    for ($i = 0; $i -lt $valid.Count; $i++) { Write-Host (" {0}. {1}" -f ($i + 1), $valid[$i]) }
    $choice = Read-Host "Choose number, or press Enter for a custom path"
    $number = 0
    if ([int]::TryParse($choice, [ref]$number) -and $number -ge 1 -and $number -le $valid.Count) {
      return $valid[$number - 1]
    }
  }
  return (Read-Host "Paste Cyberpunk 2077 GAME folder path (not bin\x64)")
}
function Has-CET([string]$root) {
  return ((Test-Path -LiteralPath (Join-Path $root "bin\x64\plugins\cyber_engine_tweaks.asi")) -and
          (Test-Path -LiteralPath (Join-Path $root "bin\x64\plugins\cyber_engine_tweaks") -PathType Container))
}
function Has-RED4ext([string]$root) {
  return (Test-Path -LiteralPath (Join-Path $root "red4ext\RED4ext.dll"))
}
function Fail([string]$message) {
  Write-Host ""
  Write-Host "NOT INSTALLED: $message" -ForegroundColor Yellow
  Write-Host "Official CET: $cet"
  Write-Host "Official RED4ext: $red4"
  Write-Host "Instructions: $docs"
  exit 1
}

Write-Host "Night City Echoes - Windows first-test installation helper v0.3"
if (-not $GamePath) { $GamePath = Pick-GameRoot }
$GamePath = $GamePath.Trim().Trim('"')
if (-not (Is-GameRoot $GamePath)) { Fail "Cannot verify bin\x64\Cyberpunk2077.exe at the chosen location." }
$GamePath = (Resolve-Path -LiteralPath $GamePath).Path
$destination = Join-Path $GamePath $modRel
Write-Host "Game directory: $GamePath"

$running = @(Get-Process -Name "Cyberpunk2077" -ErrorAction SilentlyContinue)
if ($running.Count -gt 0) { Fail "Close Cyberpunk 2077 before copying or removing scripts." }

if ($Uninstall) {
  if (-not (Test-Path -LiteralPath $destination)) {
    Write-Host "No NightCityEchoes mod folder found; nothing to uninstall."
    exit 0
  }
  Write-Host "Only Night City Echoes code will be removed. Journal is preserved."
  if ($Preview) { Write-Host "[PREVIEW] Would remove init.lua and core.lua only"; exit 0 }
  $ok = Read-Host "Type REMOVE to uninstall the two mod scripts"
  if ($ok -cne "REMOVE") { Write-Host "Cancelled."; exit 0 }
  foreach ($file in @("init.lua","core.lua")) {
    $target = Join-Path $destination $file
    if (Test-Path -LiteralPath $target -PathType Leaf) { Remove-Item -LiteralPath $target -Force }
  }
  Write-Host "Uninstalled mod code. Save journal remains at $destination"
  exit 0
}

# Patch 2.5 first-test gate updated November 3, 2026.
# CET 1.38.1 and RED4ext 1.31.0 are available for patch 2.5.
# RED4ext is not required by this CET-only Lua prototype.
# Presence of framework files alone does not prove in-game compatibility.
# Never modify graphics DLLs, save files, or unrelated mods.
$gameExe = Join-Path $GamePath "bin\x64\Cyberpunk2077.exe"
$exeMeta = (Get-Item -LiteralPath $gameExe).VersionInfo
$versionText = [string]$exeMeta.FileVersion + " " + [string]$exeMeta.ProductVersion
$normalizedVersion = $versionText -replace "[,\s]+", "."
Write-Host "Game executable version metadata: $versionText"
if ($normalizedVersion -notmatch "3\.0\.88\.46235|(^|[^0-9])2\.5([^0-9]|$)") {
  Fail "This first-test installer is restricted to Cyberpunk 2077 patch 2.5. Verify your game version before trying a different kit."
}
if ([string]::IsNullOrWhiteSpace($versionText.Trim())) {
  Fail "Game version could not be verified. Do not install until the Cyberpunk game version is established."
}

if (-not (Test-Path -LiteralPath $source -PathType Container)) { Fail "Missing source Lua files. Extract the entire first-test ZIP, or run from the complete GitHub repository checkout." }
foreach ($file in @("init.lua", "core.lua")) {
  $inputPath = Join-Path $source $file
  if (-not (Test-Path -LiteralPath $inputPath -PathType Leaf)) {
    Fail "Missing source $file; extract the complete ZIP or clone the repo."
  }
  $sourceHash = (Get-FileHash -LiteralPath $inputPath -Algorithm SHA256).Hash.ToLowerInvariant()
  if ($sourceHash -ne $expected[$file]) {
    Fail "Source SHA256 mismatch for $file. File changed or damaged; do not install."
  }
}
$red4Ok = Has-RED4ext $GamePath
$cetOk = Has-CET $GamePath
Write-Host "RED4ext detected: $red4Ok"
Write-Host "CET detected: $cetOk"
if (-not $cetOk) {
  Fail "CET is missing. Install the official patch 2.5-compatible release, verify the overlay in-game, and retry."
}
Write-Host "RED4ext is optional for this CET-only prototype. Existing RED4ext files are untouched."
Write-Host "Recommended official patch 2.5 frameworks: CET v1.38.1; RED4ext v1.31.0 only if other mods need it."
Write-Host "The game and framework versions must match. Check the CET log if the mod does not load."
Write-Host "Target: $destination"
# Read-only on-PC status check, even when preparing a fresh install.
$installedInit = Join-Path $destination 'init.lua'
$installedCore = Join-Path $destination 'core.lua'
if ((Test-Path -LiteralPath $installedInit -PathType Leaf) -and
    (Test-Path -LiteralPath $installedCore -PathType Leaf)) {
  $initHash = (Get-FileHash -LiteralPath $installedInit -Algorithm SHA256).Hash.ToLowerInvariant()
  $coreHash = (Get-FileHash -LiteralPath $installedCore -Algorithm SHA256).Hash.ToLowerInvariant()
  if ($initHash -eq $expected['init.lua'] -and $coreHash -eq $expected['core.lua']) {
    Write-Host 'INSTALL STATUS: Night City Echoes prototype is ALREADY PRESENT (both files match).' -ForegroundColor Green
  } else {
    Write-Host 'INSTALL STATUS: Existing NightCityEchoes files found, but version/hashes differ; review before overwriting.' -ForegroundColor Yellow
  }
} elseif ((Test-Path -LiteralPath $installedInit -PathType Leaf) -or
          (Test-Path -LiteralPath $installedCore -PathType Leaf)) {
  Write-Host 'INSTALL STATUS: PARTIAL NightCityEchoes install detected; one Lua file is missing.' -ForegroundColor Yellow
} else {
  Write-Host 'INSTALL STATUS: Night City Echoes is NOT found in this game installation.' -ForegroundColor Yellow
}
$journalPath = Join-Path $destination 'night_city_echoes.json'
if (Test-Path -LiteralPath $journalPath -PathType Leaf) {
  Write-Host 'EXISTING JOURNAL: present (will be preserved and backed up during update).'
}
Write-Host 'NOTE: Files present does not prove CET loaded the mod inside the game.'
if ($Preview) {
  Write-Host "[PREVIEW] Would create a timestamped backup and copy only init.lua and core.lua."
  exit 0
}
Write-Host 'Before continuing, launch the game once and confirm the CET overlay actually opens; then exit Cyberpunk.' -ForegroundColor Yellow
$ack = Read-Host "Type CET_OK only after verifying patch 2.5 and a working CET overlay in-game"
if ($ack -cne "CET_OK") { Write-Host "Cancelled. No files changed."; exit 0 }
$choice = Read-Host "Type INSTALL to back up existing files and install Night City Echoes"
if ($choice -cne "INSTALL") { Write-Host "Cancelled. No files changed."; exit 0 }
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupRoot = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "NightCityEchoes-Backups"
$backup = Join-Path $backupRoot $stamp
New-Item -ItemType Directory -Path $backup -Force | Out-Null
$previous = @()
foreach ($file in @("init.lua","core.lua","night_city_echoes.json")) {
  $original = Join-Path $destination $file
  if (Test-Path -LiteralPath $original -PathType Leaf) {
    Copy-Item -LiteralPath $original -Destination (Join-Path $backup $file) -Force
    $previous += $file
  }
}
$receipt = [ordered]@{
  gamePath=$GamePath
  backupPath=$backup
  existingFiles=@($previous)
  installedAt=(Get-Date).ToString("o")
  version="0.3-patch25-first-test"
}
($receipt | ConvertTo-Json -Depth 4) | Set-Content -LiteralPath (Join-Path $backup "manifest.json") -Encoding UTF8
New-Item -ItemType Directory -Path $destination -Force | Out-Null
foreach ($file in @("init.lua","core.lua")) {
  $from = Join-Path $source $file
  $to = Join-Path $destination $file
  Copy-Item -LiteralPath $from -Destination $to -Force
  $hashIn = (Get-FileHash -LiteralPath $from -Algorithm SHA256).Hash
  $hashOut = (Get-FileHash -LiteralPath $to -Algorithm SHA256).Hash
  if ($hashIn -ne $hashOut -or $hashOut.ToLowerInvariant() -ne $expected[$file]) {
    Fail "SHA256 mismatch copying $file. Check files and restore from backup: $backup"
  }
}
Write-Host "SUCCESS: two scripts installed and verified by SHA256." -ForegroundColor Green
Write-Host "Backup/manifest: $backup"
Write-Host "Next: start Story Mode, open CET overlay, and bind Night City Echoes: Capture NPC."
Write-Host "Current version logs encounters in a journal; it does not control NPC AI."
