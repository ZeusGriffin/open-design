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
  $relative = [System.IO.Path]::GetRelativePath($Payload, $file.FullName)
  "$hash  $relative"
}

$lines | Set-Content -Path $out -Encoding UTF8
Write-Host "Wrote: $out"
Write-Host "Files hashed: $($lines.Count)"
