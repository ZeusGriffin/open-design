param(
  [string]$VaultPath = "C:\Users\zeegr\Documents\Obsidian Master Vault"
)
$ErrorActionPreference="Stop"
if (-not (Test-Path (Join-Path $VaultPath ".obsidian"))) {
  throw "Obsidian vault not found at $VaultPath. Pass -VaultPath to select the real vault."
}
$Project = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$Source = Join-Path $Project "obsidian\Pocket ESP AI - Source and Multi-Board Build.md"
$Dest = Join-Path $VaultPath "Projects\Hardware\Pocket ESP AI"
New-Item -ItemType Directory -Path $Dest -Force | Out-Null
Copy-Item $Source -Destination (Join-Path $Dest (Split-Path $Source -Leaf)) -Force
Write-Host "Obsidian note installed: $Dest"
