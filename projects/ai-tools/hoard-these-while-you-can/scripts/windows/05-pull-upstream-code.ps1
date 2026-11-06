param(
  [string]$Destination = (Join-Path $PSScriptRoot "..\..\upstream")
)

$ErrorActionPreference = "Stop"
$Destination = [System.IO.Path]::GetFullPath($Destination)

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  throw "Git is not installed or not in PATH. Install Git for Windows first."
}

if (-not (Test-Path $Destination)) {
  New-Item -ItemType Directory -Path $Destination | Out-Null
}

$repos = @(
  @{ Name="ollama"; Url="https://github.com/ollama/ollama.git" },
  @{ Name="whisper.cpp"; Url="https://github.com/ggml-org/whisper.cpp.git" },
  @{ Name="ComfyUI"; Url="https://github.com/Comfy-Org/ComfyUI.git" },
  @{ Name="kiwix-desktop"; Url="https://github.com/kiwix/kiwix-desktop.git" },
  @{ Name="deepseek-harness"; Url="https://github.com/deepseek-ai/deepseek-harness.git" },
  @{ Name="playwright"; Url="https://github.com/microsoft/playwright.git" },
  @{ Name="firecrawl"; Url="https://github.com/firecrawl/firecrawl.git" },
  @{ Name="dsh-firecrawl"; Url="https://github.com/firecrawl/dsh-firecrawl.git" },
  @{ Name="nuclei"; Url="https://github.com/projectdiscovery/nuclei.git" }
)

foreach ($repo in $repos) {
  $target = Join-Path $Destination $repo.Name

  if (Test-Path (Join-Path $target ".git")) {
    Write-Host ""
    Write-Host "Updating $($repo.Name)"
    git -C $target fetch --all --tags --prune
    git -C $target pull --ff-only
  } else {
    Write-Host ""
    Write-Host "Cloning $($repo.Name)"
    git clone --filter=blob:none $repo.Url $target
  }

  $commit = (git -C $target rev-parse HEAD).Trim()
  Write-Host "Pinned current HEAD: $commit"
}

Write-Host ""
Write-Host "DONE"
Write-Host "Upstream code is in: $Destination"
Write-Host "Do not run install scripts blindly. Review each project's README and lockfiles first."
