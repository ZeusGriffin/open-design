# Sync the Night City Echoes master prompt into an existing Obsidian vault.
# Does not touch unrelated notes, plugins, or Obsidian settings.
[CmdletBinding()]
param([string]$VaultPath = "")

$ErrorActionPreference = "Stop"
$source = "https://raw.githubusercontent.com/ZeusGriffin/open-design/main/projects/game-mods/cyberpunk2077-night-city-echoes/MASTER_PROMPT_DESKTOP_COMMANDER.md"
$relative = "Projects\Game Mods\Cyberpunk 2077\Night City Echoes\MASTER_PROMPT_DESKTOP_COMMANDER.md"

Write-Host "Night City Echoes - Save Master Prompt to Obsidian" -ForegroundColor Cyan
if (-not $VaultPath) {
  Write-Host "Your vault is the folder containing .obsidian"
  $VaultPath = Read-Host "Paste your Obsidian vault folder path"
}
$VaultPath = $VaultPath.Trim().Trim('"')
if (-not (Test-Path -LiteralPath $VaultPath -PathType Container)) {
  throw "Obsidian vault folder does not exist: $VaultPath"
}
if (-not (Test-Path -LiteralPath (Join-Path $VaultPath ".obsidian") -PathType Container)) {
  throw "No .obsidian directory found at that location. Nothing written."
}
$vaultRoot = (Resolve-Path -LiteralPath $VaultPath).Path
$destination = Join-Path $vaultRoot $relative
$folder = Split-Path -Parent $destination

# Check received data before writing anything.
$tmp = Join-Path ([IO.Path]::GetTempPath()) ("night-city-echoes-prompt-" + [guid]::NewGuid().ToString("N") + ".md")
try {
  Invoke-WebRequest -Uri $source -OutFile $tmp -UseBasicParsing
  $text = [IO.File]::ReadAllText($tmp, [Text.Encoding]::UTF8)
  if (-not ($text.StartsWith("---") -and $text.Contains("NIGHT CITY ECHOES") -and $text.Contains("PHASE 6"))) {
    throw "Downloaded note failed a basic completeness check."
  }
  if ((Test-Path -LiteralPath $destination -PathType Leaf)) {
    $current = [IO.File]::ReadAllText($destination, [Text.Encoding]::UTF8)
    if ($current -ceq $text) {
      Write-Host "Already up-to-date: $destination"
      exit 0
    }
    Write-Host "An existing note differs from GitHub: $destination" -ForegroundColor Yellow
    $ok = Read-Host "Type UPDATE to back it up and replace it with the GitHub version"
    if ($ok -cne "UPDATE") {
      Write-Host "Cancelled: no files changed."
      exit 0
    }
    $backup = $destination + ".backup-" + (Get-Date -Format "yyyyMMdd-HHmmss") + ".md"
    Copy-Item -LiteralPath $destination -Destination $backup -ErrorAction Stop
    Write-Host "Backup saved: $backup"
  }
  New-Item -ItemType Directory -Path $folder -Force | Out-Null
  [IO.File]::WriteAllText($destination,$text,(New-Object System.Text.UTF8Encoding($false)))
  if ((Get-FileHash -LiteralPath $tmp -Algorithm SHA256).Hash -ne
      (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash) {
    throw "SHA256 verification failed. Inspect: $destination"
  }
  Write-Host "SAVED AND VERIFIED:" -ForegroundColor Green
  Write-Host $destination
  Write-Host "Open Obsidian and search for MASTER_PROMPT_DESKTOP_COMMANDER."
}
finally {
  if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Force }
}
