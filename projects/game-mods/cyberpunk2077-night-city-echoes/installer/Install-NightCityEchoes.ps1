# Night City Echoes - cautious Windows installer v0.2
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

Write-Host "Night City Echoes - Windows installation helper v0.2"
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

# Patch 2.5 safety gate, added October 22, 2026.
# CET 1.38.0 explicitly supports patch 2.5; RED4ext 2.5 support and this mod are NOT live-verified.
# Do not treat existing DLL/ASI files as evidence of game-patch compatibility.
$gameExe = Join-Path $GamePath "bin\x64\Cyberpunk2077.exe"
$exeMeta = (Get-Item -LiteralPath $gameExe).VersionInfo
$versionText = [string]$exeMeta.FileVersion + " " + [string]$exeMeta.ProductVersion
$normalizedVersion = $versionText -replace "[,\s]+", "."
Write-Host "Game executable version metadata: $versionText"
if ($normalizedVersion -match "3\.0\.88\.46235|(^|[^0-9])2\.5([^0-9]|$)") {
  Fail "Cyberpunk 2077 patch 2.5 detected. Installation is intentionally blocked until RED4ext and this mod are verified on patch 2.5. CET 1.38.0 alone does not verify the entire stack. Read PATCH_2_5_STATUS.md in GitHub."
}
if ([string]::IsNullOrWhiteSpace($versionText.Trim())) {
  Fail "Game version could not be verified. Do not install until the Cyberpunk game version is established."
}

if (-not (Test-Path -LiteralPath $source -PathType Container)) { Fail "ZIP not fully extracted; missing payload folder." }
foreach ($file in @("init.lua", "core.lua")) {
  if (-not (Test-Path -LiteralPath (Join-Path $source $file) -PathType Leaf)) {
    Fail "Missing payload $file; extract the entire ZIP before running this installer."
  }
}
$red4Ok = Has-RED4ext $GamePath
$cetOk = Has-CET $GamePath
Write-Host "RED4ext detected: $red4Ok"
Write-Host "CET detected: $cetOk"
if (-not $red4Ok -or -not $cetOk) {
  Fail "Install both compatible frameworks using their official ZIPs first. This helper will not download unknown versions or overwrite them."
}
Write-Host "The game and framework versions must match. Check the CET log if the mod does not load."
Write-Host "Target: $destination"
if ($Preview) {
  Write-Host "[PREVIEW] Would create a timestamped backup and copy only init.lua and core.lua."
  exit 0
}
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
  version="0.2-install-kit"
}
($receipt | ConvertTo-Json -Depth 4) | Set-Content -LiteralPath (Join-Path $backup "manifest.json") -Encoding UTF8
New-Item -ItemType Directory -Path $destination -Force | Out-Null
foreach ($file in @("init.lua","core.lua")) {
  $from = Join-Path $source $file
  $to = Join-Path $destination $file
  Copy-Item -LiteralPath $from -Destination $to -Force
  $hashIn = (Get-FileHash -LiteralPath $from -Algorithm SHA256).Hash
  $hashOut = (Get-FileHash -LiteralPath $to -Algorithm SHA256).Hash
  if ($hashIn -ne $hashOut) { Fail "SHA256 mismatch copying $file. Check files and restore from backup: $backup" }
}
Write-Host "SUCCESS: two scripts installed and verified by SHA256." -ForegroundColor Green
Write-Host "Backup/manifest: $backup"
Write-Host "Next: start Story Mode, open CET overlay, and bind Night City Echoes: Capture NPC."
Write-Host "Current version logs encounters in a journal; it does not control NPC AI."
