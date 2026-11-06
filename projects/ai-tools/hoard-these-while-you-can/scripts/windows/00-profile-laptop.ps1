$ErrorActionPreference = "Stop"

$out = Join-Path (Get-Location) "hardware-profile.txt"

$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$cpu = Get-CimInstance Win32_Processor
$gpus = Get-CimInstance Win32_VideoController
$drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

$lines = @()
$lines += "Emergency AI Kit - Laptop Hardware Profile"
$lines += "Generated: $(Get-Date -Format o)"
$lines += ""
$lines += "WINDOWS"
$lines += "Caption: $($os.Caption)"
$lines += "Version: $($os.Version)"
$lines += "Build: $($os.BuildNumber)"
$lines += ""
$lines += "MEMORY"
$lines += ("Installed RAM: {0:N1} GB" -f ($cs.TotalPhysicalMemory / 1GB))
$lines += ""
$lines += "CPU"
foreach ($item in $cpu) {
  $lines += "Name: $($item.Name)"
  $lines += "Cores: $($item.NumberOfCores)"
  $lines += "Logical processors: $($item.NumberOfLogicalProcessors)"
}
$lines += ""
$lines += "GPU"
foreach ($gpu in $gpus) {
  $lines += "Name: $($gpu.Name)"
  if ($gpu.AdapterRAM) {
    $lines += ("Reported VRAM: {0:N1} GB" -f ($gpu.AdapterRAM / 1GB))
  } else {
    $lines += "Reported VRAM: unavailable"
  }
  $lines += "Driver: $($gpu.DriverVersion)"
  $lines += ""
}
$lines += "STORAGE"
foreach ($drive in $drives) {
  $lines += ("{0} Free {1:N1} GB / Size {2:N1} GB" -f $drive.DeviceID, ($drive.FreeSpace/1GB), ($drive.Size/1GB))
}

$lines | Set-Content -Path $out -Encoding UTF8
$lines | ForEach-Object { Write-Host $_ }

Write-Host ""
Write-Host "Saved: $out"
Write-Host "Send me this file/output before we choose the large local models."
