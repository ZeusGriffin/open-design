# JUKEBOXX / JUKE View -- minimal Obsidian note installer
# Copies ONLY the two project Markdown notes. Does not create or configure a vault.
param([string]$VaultPath = "C:\Users\zeegr\Documents\Obsidian Master Vault")
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not (Test-Path -LiteralPath (Join-Path $VaultPath ".obsidian") -PathType Container)) {
  throw "Existing master Obsidian vault not verified at: $VaultPath. No changes made."
}
$source = Join-Path $here "obsidian"
$dest = Join-Path $VaultPath "Projects\Creative\JUKEBOXX"
if (-not (Test-Path -LiteralPath $source)) { throw "Missing source notes at $source" }
New-Item -ItemType Directory -Path $dest -Force | Out-Null
foreach ($name in @("JUKEBOXX — Project Hub.md", "JUKE View — Review Workflow.md")) {
  $from = Join-Path $source $name
  $to = Join-Path $dest $name
  if (-not (Test-Path -LiteralPath $from)) { throw "Missing source: $from" }
  if (Test-Path -LiteralPath $to) {
    Write-Warning "Already exists, leaving untouched: $to"
    continue
  }
  Copy-Item -LiteralPath $from -Destination $to
  Write-Host "Added $to"
}
Write-Host "JUKEBOXX note installation finished. Existing notes preserved."
