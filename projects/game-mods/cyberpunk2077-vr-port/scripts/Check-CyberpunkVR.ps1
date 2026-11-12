# Read-only Cyberpunk VR preflight inventory. Does not install, download, delete or modify game files.
param([Parameter(Mandatory=$true)][string]$GamePath)

$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $GamePath).Path
$exe = Join-Path $root 'bin\x64\Cyberpunk2077.exe'
if (-not (Test-Path -LiteralPath $exe -PathType Leaf)) {
    throw "Cyberpunk2077.exe not found under $root\bin\x64"
}

$info = (Get-Item -LiteralPath $exe).VersionInfo

Write-Host '=== Cyberpunk VR read-only preflight ==='
Write-Host "Game directory: $root"
Write-Host "Executable version: $($info.FileVersion)"
Write-Host "Product version: $($info.ProductVersion)"
Write-Host "Executable SHA256: $((Get-FileHash -LiteralPath $exe -Algorithm SHA256).Hash)"
Write-Host ''

$paths = @(
    'red4ext',
    'red4ext\plugins\cyberpunkvrport',
    'red4ext\plugins\cyberpunkvrport\cyberpunkvrport.dll',
    'red4ext\plugins\CyberpunkVR_Stereo',
    'red4ext\plugins\CyberpunkVR_Hands',
    'bin\x64\vrport.ini',
    'bin\x64\dxgi.dll',
    'bin\x64\openvr_api.dll',
    'bin\x64\plugins\cyber_engine_tweaks',
    'bin\x64\plugins\cyber_engine_tweaks\mods\NightCityEchoes',
    'archive\pc\mod',
    'r6\scripts',
    'mods'
)

foreach ($p in $paths) {
    $full = Join-Path $root $p
    Write-Host ("{0}: {1}" -f $p, $(if(Test-Path -LiteralPath $full){'PRESENT'}else{'not found'}))
}

Write-Host ''
Write-Host 'Interpretation:'
Write-Host '- Current VR Port 0.2.x lives under red4ext\plugins\cyberpunkvrport.'
Write-Host '- Old CyberpunkVR_Stereo / CyberpunkVR_Hands folders or an unrelated dxgi.dll may be legacy/competing VR files; identify before updating.'
Write-Host '- CET and other frameworks can remain if Night City Echoes or another mod needs them.'
Write-Host ''
Write-Host 'No files were modified.'
