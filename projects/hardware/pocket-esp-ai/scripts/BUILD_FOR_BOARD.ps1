param(
  [ValidateSet("esp32","esp32c3","esp32c5","esp32c6","esp32s3","esp32p4")]
  [string]$Chip = "esp32c3",
  [switch]$SkipMenuconfig,
  [switch]$Flash,
  [string]$Port = ""
)
$ErrorActionPreference = "Stop"
$Project = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$Source = Join-Path $Project "unpacked\POCKET-ESP-AI-PROJECT\source\xiaozhi-esp32"
if (-not (Test-Path (Join-Path $Source "CMakeLists.txt"))) {
  throw "Source not restored. First run scripts/RESTORE_SOURCE.ps1"
}
if (-not (Get-Command idf.py -ErrorAction SilentlyContinue)) {
  throw "idf.py missing. Open an ESP-IDF PowerShell environment and rerun."
}
Push-Location $Source
try {
  Write-Host "Selecting chip target $Chip. Hardware pins and board profile must be checked."
  & idf.py set-target $Chip
  if ($LASTEXITCODE -ne 0) { throw "idf.py set-target failed" }
  if (-not $SkipMenuconfig) {
    & idf.py menuconfig
    if ($LASTEXITCODE -ne 0) { throw "idf.py menuconfig failed" }
  }
  & idf.py build
  if ($LASTEXITCODE -ne 0) { throw "idf.py build failed" }
  Write-Host "Build complete. No device has been flashed."
  if ($Flash) {
    if (-not $Port) { throw "For safety, specify -Port COMx when using -Flash." }
    Write-Warning "Flashing will overwrite device firmware. Confirm board and port are correct."
    $Reply = Read-Host "Enter FLASH to continue"
    if ($Reply -cne "FLASH") { throw "Flash cancelled" }
    & idf.py -p $Port flash
    if ($LASTEXITCODE -ne 0) { throw "Flash failed" }
  }
} finally { Pop-Location }
