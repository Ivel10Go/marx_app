param(
  [string]$DeviceId = "19051FDF6000J8",
  [string]$OutDir = "assets/screenshots/play/raw"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $OutDir)) {
  New-Item -ItemType Directory -Path $OutDir | Out-Null
}

$adb = "adb"

Write-Output "Using device: $DeviceId"
Write-Output "Output dir: $OutDir"
Write-Output "Capture flow: Open target screen on device, then press Enter in terminal."

function Capture-Shot {
  param([string]$Name)

  $remote = "/sdcard/$Name.png"
  & $adb -s $DeviceId shell screencap -p $remote | Out-Null
  & $adb -s $DeviceId pull $remote "$OutDir/$Name.png" | Out-Null
  & $adb -s $DeviceId shell rm $remote | Out-Null
  Write-Output "Captured: $OutDir/$Name.png"
}

$shots = @(
  "phone67_01_home",
  "phone67_02_detail",
  "phone67_03_archive",
  "phone67_04_paywall",
  "phone51_01_home",
  "phone51_02_detail",
  "phone51_03_archive",
  "phone51_04_paywall"
)

foreach ($shot in $shots) {
  Read-Host "Prepare screen '$shot' on device and press Enter"
  Capture-Shot -Name $shot
}

Write-Output "Done. Review files in $OutDir and move approved images to assets/screenshots/play/."
