# Stages official CyberpunkVR Port 0.2.3 + RED4ext 1.31.0.
# It does NOT modify the game installation.
param(
    [string]$StagingDir = "$env:USERPROFILE\Downloads\CyberpunkVR-0.2.3-Ready"
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$vrTag = 'v0.2.3'
$redTag = 'v1.31.0'
$redExpectedSha256 = 'B9AE4351F547F90AF58DFBF7445D45C55CD5BA24FBEE27FB16FB5D91E9DF621E'

New-Item -ItemType Directory -Force -Path $StagingDir | Out-Null

$headers = @{
    'User-Agent' = 'ZeusGriffin-CyberpunkVR-Stager'
    'Accept' = 'application/vnd.github+json'
}

function Get-ReleaseAsset {
    param(
        [Parameter(Mandatory=$true)][string]$Repo,
        [Parameter(Mandatory=$true)][string]$Tag,
        [Parameter(Mandatory=$true)][string]$NameRegex
    )
    $release = Invoke-RestMethod -Headers $headers -Uri "https://api.github.com/repos/$Repo/releases/tags/$Tag"
    $asset = $release.assets | Where-Object { $_.name -match $NameRegex } | Select-Object -First 1
    if (-not $asset) { throw "No asset matching '$NameRegex' found for $Repo $Tag" }
    return $asset
}

Write-Host "Staging official Cyberpunk VR files to: $StagingDir"

$vrAsset = Get-ReleaseAsset -Repo 'dariulone/cyberpunk-vr-port' -Tag $vrTag -NameRegex '^CyberpunkVRPort-0\.2\.3\.zip$'
$redAsset = Get-ReleaseAsset -Repo 'WopsS/RED4ext' -Tag $redTag -NameRegex '^red4ext-1\.31\.0\.zip$'

$vrZip = Join-Path $StagingDir $vrAsset.name
$redZip = Join-Path $StagingDir $redAsset.name

Invoke-WebRequest -Headers $headers -Uri $vrAsset.browser_download_url -OutFile $vrZip
Invoke-WebRequest -Headers $headers -Uri $redAsset.browser_download_url -OutFile $redZip

$redHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $redZip).Hash.ToUpperInvariant()
if ($redHash -ne $redExpectedSha256) {
    Remove-Item -LiteralPath $redZip -Force
    throw "RED4ext SHA256 mismatch. Download removed."
}

$vrHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $vrZip).Hash.ToUpperInvariant()

$manifest = [ordered]@{
    staged_at = (Get-Date).ToString('o')
    cyberpunk_required = '2.5'
    vr_port = '0.2.3'
    vr_port_file = $vrAsset.name
    vr_port_sha256 = $vrHash
    red4ext = '1.31.0'
    red4ext_file = $redAsset.name
    red4ext_sha256 = $redHash
    red4ext_sha256_verified_against_release_notes = $true
    source_video = 'https://youtu.be/6sDvHXDF1yM'
    next_step = 'Prefer MrSurviv0r VR HUB > Cyberpunk 2077 > Install Update. Use these staged files only as the direct-official fallback.'
}
$manifest | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 (Join-Path $StagingDir 'manifest.json')

@"
Cyberpunk VR update staging complete.

Pinned files:
- CyberpunkVR Port 0.2.3
- RED4ext 1.31.0

This script did NOT modify Cyberpunk.

Preferred install:
1. Close Cyberpunk.
2. Use newest MrSurviv0r VR HUB.
3. Cyberpunk 2077 > Install Update.
4. Start OpenXR runtime.
5. Launch and run the quick verification checklist.

Fallback:
Follow the upstream CyberpunkVR Port README using the staged ZIPs.

VR ZIP SHA256:
$vrHash

RED4ext SHA256:
$redHash
"@ | Set-Content -Encoding UTF8 (Join-Path $StagingDir 'NEXT-STEPS.txt')

Write-Host ""
Write-Host "READY:"
Write-Host "  $vrZip"
Write-Host "  $redZip"
Write-Host "  $(Join-Path $StagingDir 'NEXT-STEPS.txt')"
Write-Host ""
Write-Host "No game files were changed."
