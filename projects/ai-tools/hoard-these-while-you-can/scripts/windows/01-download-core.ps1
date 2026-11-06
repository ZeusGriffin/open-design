param(
  [string]$Destination = (Join-Path $PSScriptRoot "..\..\payload"),
  [switch]$IncludeComfyNvidia
)

$ErrorActionPreference = "Stop"
$Destination = [System.IO.Path]::GetFullPath($Destination)

function New-Folder([string]$Path) {
  if (-not (Test-Path $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

function Download-File([string]$Url, [string]$OutFile) {
  New-Folder (Split-Path $OutFile -Parent)

  if ((Test-Path $OutFile) -and ((Get-Item $OutFile).Length -gt 0)) {
    Write-Host "Already present, skipping: $OutFile"
    return
  }

  Write-Host "Downloading: $Url"
  Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
}

New-Folder $Destination
New-Folder (Join-Path $Destination "installers")
New-Folder (Join-Path $Destination "whisper-models")

# 1) Ollama — official Windows installer
Download-File "https://ollama.com/download/OllamaSetup.exe" (Join-Path $Destination "installers\OllamaSetup.exe")

# 2) Kiwix Desktop — known stable Windows x64 release
Download-File "https://download.kiwix.org/release/kiwix-desktop/kiwix-desktop_windows_x64_2.5.1.zip" (Join-Path $Destination "installers\kiwix-desktop_windows_x64_2.5.1.zip")

# 3) whisper.cpp — newest GitHub release containing the Windows x64 asset
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/ggml-org/whisper.cpp/releases/latest" -Headers @{"User-Agent"="Emergency-AI-Kit"}
$asset = $release.assets | Where-Object { $_.name -eq "whisper-bin-x64.zip" } | Select-Object -First 1
if (-not $asset) {
  throw "Could not find whisper-bin-x64.zip in the latest whisper.cpp release."
}
Download-File $asset.browser_download_url (Join-Path $Destination "installers\whisper-bin-x64.zip")

# Small multilingual Whisper model for the first offline smoke test.
Download-File "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin" (Join-Path $Destination "whisper-models\ggml-base.bin")

# 4) ComfyUI — optional NVIDIA portable package.
# Leave OFF unless the target laptop has a compatible NVIDIA GPU.
if ($IncludeComfyNvidia) {
  Download-File "https://github.com/comfyanonymous/ComfyUI/releases/latest/download/ComfyUI_windows_portable_nvidia.7z" (Join-Path $Destination "installers\ComfyUI_windows_portable_nvidia.7z")
}

@"
Emergency AI Kit payload
Created: $(Get-Date -Format o)

Core downloads:
- Ollama Windows installer
- Kiwix Desktop Windows x64
- whisper.cpp Windows x64
- Whisper base multilingual model

ComfyUI NVIDIA portable included: $IncludeComfyNvidia

Large LLM, Wikipedia ZIM, and image-model files are intentionally NOT downloaded automatically.
Choose those after checking the target laptop hardware and memory-card capacity.
"@ | Set-Content -Path (Join-Path $Destination "README-FIRST.txt") -Encoding UTF8

Write-Host ""
Write-Host "DONE: $Destination"
Write-Host "Next: run 02-build-checksums.ps1"
