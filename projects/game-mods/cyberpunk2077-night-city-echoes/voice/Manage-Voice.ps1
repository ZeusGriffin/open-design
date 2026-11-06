# Night City Echoes — standalone Windows local voice environment manager.
# Only -Action Setup installs Python dependencies/downloads an Ollama model and Whisper model.
# Does NOT modify Cyberpunk files or start the game; voice stays opt-in.
[CmdletBinding()]
param(
  [ValidateSet('Check','Setup','Run','TextTest')][string]$Action = 'Check',
  [string]$GamePath = '',
  [string]$Model = 'llama3.2:3b'
)
$ErrorActionPreference = 'Stop'
$voiceDir = $PSScriptRoot
$repoRoot = (Resolve-Path (Join-Path $voiceDir '..')).Path
$venvPy = Join-Path $voiceDir '.venv\Scripts\python.exe'
$req = Join-Path $voiceDir 'requirements.txt'

function Get-PythonCommand {
  $python = Get-Command 'py.exe' -ErrorAction SilentlyContinue
  if ($python) { return @{ Path = $python.Source; Prefix = @('-3') } }
  $python = Get-Command 'python.exe' -ErrorAction SilentlyContinue
  if ($python) { return @{ Path = $python.Source; Prefix = @() } }
  throw 'Install Python 3.11 or 3.12 (64-bit) and enable the Python launcher, then run Setup again.'
}

function Get-GamePath {
  if (-not $GamePath) {
    $GamePath = Read-Host 'Enter the Cyberpunk 2077 GAME folder (contains bin and archive)'
  }
  $p = $GamePath.Trim().Trim('"')
  if (-not (Test-Path -LiteralPath (Join-Path $p 'bin\x64\Cyberpunk2077.exe') -PathType Leaf)) {
    throw "This is not a Cyberpunk 2077 installation folder: $p"
  }
  return (Resolve-Path -LiteralPath $p).Path
}

function Get-ModDir {
  $root = Get-GamePath
  return Join-Path $root 'bin\x64\plugins\cyber_engine_tweaks\mods\NightCityEchoes'
}

if ($Action -eq 'Setup') {
  if (-not (Test-Path $req)) { throw 'requirements.txt missing; download complete repo.' }
  $py = Get-PythonCommand
  Write-Host "Creating local Python environment in $voiceDir\.venv"
  & $py.Path @($py.Prefix) -m venv (Join-Path $voiceDir '.venv')
  if ($LASTEXITCODE -ne 0) { throw 'Creating the virtual environment failed.' }
  & $venvPy -m pip install --upgrade pip
  if ($LASTEXITCODE -ne 0) { throw 'pip upgrade failed.' }
  & $venvPy -m pip install -r $req
  if ($LASTEXITCODE -ne 0) { throw 'Installing offline voice packages failed.' }
  $ollama = Get-Command 'ollama.exe' -ErrorAction SilentlyContinue
  if (-not $ollama) {
    throw 'Python voice packages installed. Ollama executable was not found; install Ollama for Windows from https://ollama.com/download/windows, then rerun Setup.'
  }
  Write-Host "Downloading local Ollama conversation model: $Model"
  & $ollama.Source pull $Model
  if ($LASTEXITCODE -ne 0) { throw 'Ollama pull failed.' }
  Write-Host 'Downloading faster-whisper base model one time for offline use...'
  & $venvPy -c 'from faster_whisper import WhisperModel; WhisperModel("base", device="cpu", compute_type="int8"); print("Whisper cache ready")'
  if ($LASTEXITCODE -ne 0) { throw 'Whisper model download failed.' }
  Write-Host 'SETUP COMPLETE. No game files were changed.' -ForegroundColor Green
  exit 0
}

if ($Action -eq 'Check') {
  $modDir = Get-ModDir
  Write-Host "Cyberpunk mod directory: $modDir"
  foreach ($p in @('init.lua','core.lua','voice_bridge.lua')) {
    $target = Join-Path $modDir $p
    Write-Host ("{0}: {1}" -f $p,(Test-Path -LiteralPath $target -PathType Leaf))
  }
  Write-Host "Python virtual environment: $(Test-Path -LiteralPath $venvPy -PathType Leaf)"
  $ollama = Get-Command 'ollama.exe' -ErrorAction SilentlyContinue
  Write-Host "Ollama command found: $([bool]$ollama)"
  if ($ollama) {
    & $ollama.Source list
    Write-Host 'Ollama local-server availability may still require launching the app.'
  }
  Write-Host 'Read-only check complete. File presence is not proof of in-game functionality.'
  exit 0
}

$modDir = Get-ModDir
if (-not (Test-Path -LiteralPath (Join-Path $modDir 'voice_bridge.lua') -PathType Leaf)) {
  throw 'Voice bridge not installed. First review and run voice/Install-VoiceBridge.ps1.'
}
if (-not (Test-Path -LiteralPath $venvPy -PathType Leaf)) {
  throw 'Local Python environment missing; run .\Manage-Voice.ps1 -Action Setup first.'
}

if ($Action -eq 'Run') {
  Write-Host 'Starting local voice companion (push-to-talk only). Ctrl+C closes it.'
  & $venvPy (Join-Path $voiceDir 'bridge_service.py') --mod-dir $modDir --model $Model
  exit $LASTEXITCODE
}
if ($Action -eq 'TextTest') {
  Write-Host 'Run the voice companion in another terminal first, then this no-microphone test.'
  & $venvPy (Join-Path $voiceDir 'send_text_test.py') --mod-dir $modDir
  exit $LASTEXITCODE
}
