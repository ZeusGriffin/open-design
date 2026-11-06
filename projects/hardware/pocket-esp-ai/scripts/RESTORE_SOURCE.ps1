param(
  [switch]$Force
)
$ErrorActionPreference = "Stop"
$Project = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$PartsDir = Join-Path $Project "source-archive"
$Output = Join-Path $Project "pocket-esp-ai-project-complete.zip"
$Extracted = Join-Path $Project "unpacked"
$Expected = "fa2748b253e356b7947276b5f4e7654e3515466a62a5d6fddee898ee08259958"
if ((Test-Path $Extracted) -and -not $Force) {
  throw "unpacked folder already exists. To replace it explicitly, rerun with -Force."
}
$OutputStream = [System.IO.File]::Open($Output, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write)
try {
  foreach ($N in 1..10) {
    $Part = Join-Path $PartsDir ("pocket-esp-ai-project-complete.zip.part{0:D2}" -f $N)
    if (-not (Test-Path $Part)) { throw "Missing archive part: $Part" }
    $InputStream = [System.IO.File]::OpenRead($Part)
    try { $InputStream.CopyTo($OutputStream) } finally { $InputStream.Dispose() }
  }
} finally { $OutputStream.Dispose() }
$Hash = (Get-FileHash -Algorithm SHA256 $Output).Hash.ToLowerInvariant()
if ($Hash -ne $Expected) {
  Remove-Item $Output -Force
  throw "SHA-256 mismatch. Restored archive discarded. Got $Hash"
}
if ((Test-Path $Extracted) -and $Force) { Remove-Item $Extracted -Recurse -Force }
Expand-Archive -Path $Output -DestinationPath $Extracted -Force
$Source = Join-Path $Extracted "POCKET-ESP-AI-PROJECT\source\xiaozhi-esp32"
if (-not (Test-Path (Join-Path $Source "CMakeLists.txt"))) { throw "Archive structure invalid: CMakeLists.txt missing" }
Write-Host "Verified complete original source at: $Source"
Write-Host "Next: run scripts/BUILD_FOR_BOARD.ps1 -Chip esp32s3 (choose an exact board profile)"
