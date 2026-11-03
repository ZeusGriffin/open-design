param([string]$VaultPath)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
if (-not $VaultPath) {
  $picker = New-Object System.Windows.Forms.FolderBrowserDialog
  $picker.Description = 'Select your EXISTING Obsidian master vault (must contain .obsidian)'
  if ($picker.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
    Write-Host 'Cancelled. Nothing changed.'; exit 0
  }
  $VaultPath = $picker.SelectedPath
}
if (-not (Test-Path -LiteralPath (Join-Path $VaultPath '.obsidian') -PathType Container)) {
  throw 'This folder is not a confirmed Obsidian vault (.obsidian missing). No vault created.'
}
$noteDir = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\obsidian'))
$destDir = Join-Path $VaultPath 'Projects\AI Hardware\Be More Agent'
New-Item -ItemType Directory -Path $destDir -Force | Out-Null
$notes = @(Get-ChildItem -LiteralPath $noteDir -Filter '*.md' -File)
if ($notes.Count -eq 0) { throw 'No Obsidian notes found. Nothing copied.' }
foreach ($note in $notes) {
  $source = $note.FullName
  $dest = Join-Path $destDir $note.Name
  if (Test-Path -LiteralPath $dest) {
    $existingHash = (Get-FileHash -LiteralPath $dest -Algorithm SHA256).Hash
    $newHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
    if ($existingHash -eq $newHash) {
      Write-Host "Already imported (identical): $dest"
      continue
    }
    $review = Join-Path $destDir 'Needs Review'
    New-Item -ItemType Directory -Path $review -Force | Out-Null
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss-ffff'
    $dest = Join-Path $review ($note.BaseName + " - imported $stamp.md")
    Write-Host 'Existing note differs; preserved and staged replacement in Needs Review.'
  }
  Copy-Item -LiteralPath $source -Destination $dest -ErrorAction Stop
  Write-Host "Imported: $dest"
}
Write-Host 'Existing Obsidian vault preserved. No vault root or settings changed.'