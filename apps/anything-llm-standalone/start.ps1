# AnythingLLM standalone launcher for Windows (Docker Desktop required).
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw 'Docker not found. Install and start Docker Desktop first: https://www.docker.com/products/docker-desktop/'
}
& docker info *> $null
if ($LASTEXITCODE -ne 0) { throw 'Docker is not running. Start Docker Desktop, then run this launcher again.' }

$data = Join-Path $PSScriptRoot 'data'
if (-not (Test-Path $data)) { New-Item -ItemType Directory -Path $data | Out-Null }
$envPath = Join-Path $data '.env'
if (-not (Test-Path $envPath)) {
    $bytes = New-Object byte[] 48
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    try { $rng.GetBytes($bytes) } finally { $rng.Dispose() }
    $secret = [Convert]::ToBase64String($bytes)
    [System.IO.File]::WriteAllText($envPath, "JWT_SECRET=$secret`n")
}

& docker compose -f compose.yaml pull
if ($LASTEXITCODE -ne 0) { throw 'Docker image download failed.' }
& docker compose -f compose.yaml up -d
if ($LASTEXITCODE -ne 0) { throw 'AnythingLLM failed to start. Check docker compose logs.' }
Write-Host 'AnythingLLM is starting at http://localhost:3001' -ForegroundColor Green
Start-Process 'http://localhost:3001'
Write-Host 'First launch: choose/download a local model during onboarding.'
