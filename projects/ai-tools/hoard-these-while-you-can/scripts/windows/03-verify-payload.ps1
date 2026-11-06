param(
  [string]$Payload = (Join-Path $PSScriptRoot "..\..\payload")
)

$ErrorActionPreference = "Stop"
$Payload = [System.IO.Path]::GetFullPath($Payload)
$sumFile = Join-Path $Payload "SHA256SUMS.txt"

if (-not (Test-Path $sumFile)) {
  throw "Missing checksum file: $sumFile"
}

$failed = 0
$checked = 0

foreach ($line in Get-Content $sumFile) {
  if ([string]::IsNullOrWhiteSpace($line)) { continue }
  if ($line -notmatch '^([a-fA-F0-9]{64})\s\s(.+)$') {
    Write-Warning "Skipping malformed line: $line"
    continue
  }

  $expected = $matches[1].ToLowerInvariant()
  $relative = $matches[2]
  $path = Join-Path $Payload $relative
  $checked++

  if (-not (Test-Path $path)) {
    Write-Host "MISSING  $relative"
    $failed++
    continue
  }

  $actual = (Get-FileHash -Algorithm SHA256 -Path $path).Hash.ToLowerInvariant()
  if ($actual -eq $expected) {
    Write-Host "OK       $relative"
  } else {
    Write-Host "BAD HASH $relative"
    $failed++
  }
}

Write-Host ""
Write-Host "Checked: $checked"
Write-Host "Failed:  $failed"

if ($failed -gt 0) { exit 1 }
exit 0
