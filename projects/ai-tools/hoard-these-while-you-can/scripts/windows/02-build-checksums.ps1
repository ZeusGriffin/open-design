param(
  [string]$Payload = (Join-Path $PSScriptRoot "..\..\payload")
)

$ErrorActionPreference = "Stop"
$Payload = [System.IO.Path]::GetFullPath($Payload)

if (-not (Test-Path $Payload)) {
  throw "Payload folder not found: $Payload"
}

$out = Join-Path $Payload "SHA256SUMS.txt"
$files = Get-ChildItem -Path $Payload -File -Recurse | Where-Object { $_.FullName -ne $out }

$lines = foreach ($file in $files) {
  $hash = (Get-FileHash -Algorithm SHA256 -Path $file.FullName).Hash.ToLowerInvariant()

  # Compatible with Windows PowerShell 5.1 and PowerShell 7.
  $relative = $file.FullName.Substring($Payload.Length)
  $relative = $relative.TrimStart([char[]]@('\','/'))

  "$hash  $relative"
}

$lines | Set-Content -Path $out -Encoding UTF8
Write-Host "Wrote: $out"
Write-Host "Files hashed: $($lines.Count)"
