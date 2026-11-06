param(
  [Parameter(Mandatory=$true)][string]$DestinationDrive,
  [string]$Payload = (Join-Path $PSScriptRoot "..\..\payload"),
  [string]$FolderName = "EMERGENCY-AI-CORE"
)

$ErrorActionPreference = "Stop"
$Payload = [System.IO.Path]::GetFullPath($Payload)

if (-not (Test-Path $Payload)) { throw "Payload not found: $Payload" }
if (-not (Test-Path $DestinationDrive)) { throw "Destination drive/path not found: $DestinationDrive" }

$dest = Join-Path $DestinationDrive $FolderName
Write-Host "Copying:"
Write-Host "  FROM $Payload"
Write-Host "  TO   $dest"

New-Item -ItemType Directory -Path $dest -Force | Out-Null
Copy-Item -Path (Join-Path $Payload "*") -Destination $dest -Recurse -Force

Write-Host "Copy complete."
Write-Host "Verify the copied payload by running 03-verify-payload.ps1 against:"
Write-Host "  $dest"
