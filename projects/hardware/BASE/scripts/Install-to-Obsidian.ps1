# Copies ONLY the BASE note into the user's existing master Obsidian vault.
param([string]$VaultPath = 'C:\Users\zeegr\Documents\Obsidian Master Vault')
$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot '..\Obsidian\Projects\Hardware\BASE\BASE - iPhone 15 Case.md'
$vault = Resolve-Path $VaultPath -ErrorAction Stop
if (-not (Test-Path (Join-Path $vault '.obsidian'))) {
  throw "No .obsidian folder found in '$vault'. Verify the vault location manually."
}
$dest = Join-Path $vault 'Projects\Hardware\BASE'
New-Item -ItemType Directory -Force -Path $dest | Out-Null
$dstFile = Join-Path $dest 'BASE - iPhone 15 Case.md'
if (Test-Path $dstFile) {
  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
  Copy-Item $dstFile "$dstFile.backup-$stamp" -ErrorAction Stop
}
Copy-Item -LiteralPath $source -Destination $dstFile -Force
Write-Host "BASE note installed: $dstFile"
