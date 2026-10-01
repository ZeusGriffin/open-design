# setup-claude-ponytail.ps1
$ErrorActionPreference = "Stop"

Write-Host "Checking prerequisites..."
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "Git is not installed or not on PATH." }
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { Write-Warning "Node is not on PATH. Ponytail skills can work, but lifecycle hooks may not auto-activate." }

$root = Join-Path $HOME "ponytail"
if (Test-Path $root) {
  Write-Host "Updating existing Ponytail checkout..."
  git -C $root pull --ff-only
} else {
  Write-Host "Cloning canonical Ponytail..."
  git clone https://github.com/DietrichGebert/ponytail.git $root
}

Write-Host ""
Write-Host "Local Ponytail source is ready at: $root"
Write-Host ""
Write-Host "Now open Claude Code and send these TWO commands separately:"
Write-Host "  /plugin marketplace add DietrichGebert/ponytail"
Write-Host "  /plugin install ponytail@ponytail"
Write-Host ""
Write-Host "Then start a fresh Claude Code session and run /ponytail-help to verify all six skills."
