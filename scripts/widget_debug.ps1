<#
PowerShell helper to debug the Android home widget for marx_app.
Usage:
  .\scripts\widget_debug.ps1                # auto-picks first online device
  .\scripts\widget_debug.ps1 -DeviceId 19051FDF6000J8

What it does:
 - selects an online device (or uses -DeviceId)
 - launches the app (monkey)
 - dumps filtered logcat to widget_log.txt
 - dumps /data/data/.../HomeWidgetPreferences.xml to HomeWidgetPreferences.xml (if run-as works)
 - attempts to broadcast APPWIDGET_UPDATE (may be blocked on modern Android)
 - writes results to the script folder and prints short summaries
#>

param(
  [string]$DeviceId
)

Push-Location $PSScriptRoot

function Choose-Device {
  $devices = & adb devices | Select-String "^(?!List).*" | ForEach-Object { $_.ToString().Trim() } | Where-Object { $_ -and ($_ -notmatch "offline") }
  $devices = $devices -replace "\s+device$",""
  if ($devices.Count -eq 0) { return $null }
  if ($devices.Count -eq 1) { return $devices[0] }
  # multiple online devices -> prefer emulator absent; otherwise pick first
  Write-Host "Mehrere Geräte gefunden:" -ForegroundColor Yellow
  $i = 0
  $devices | ForEach-Object { Write-Host "[$i] $_"; $i++ }
  Write-Host "Wähle Index für Gerät (oder ENTER für 0): " -NoNewline
  $choice = Read-Host
  if ($choice -match '^[0-9]+$') { return $devices[[int]$choice] }
  return $devices[0]
}

if (-not $DeviceId) {
  $DeviceId = Choose-Device
}

if (-not $DeviceId) {
  Write-Error "Kein online-Gerät gefunden. Bitte schließe ein Gerät an oder starte einen Emulator."
  Exit 1
}

Write-Host "Using device: $DeviceId" -ForegroundColor Cyan

# helper to run adb for this device
function ADB([string]$args) {
  & adb -s $DeviceId $args
}

# ensure log files dir
$OutDir = Join-Path $PSScriptRoot "output"
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }

$logFile = Join-Path $OutDir "widget_log.txt"
$prefsFile = Join-Path $OutDir "HomeWidgetPreferences.xml"
$broadcastOut = Join-Path $OutDir "broadcast_out.txt"

Write-Host "Launching app to trigger widget sync..." -ForegroundColor Green
ADB "shell monkey -p com.example.marx_app -c android.intent.category.LAUNCHER 1"
Start-Sleep -Seconds 3

Write-Host "Collecting filtered logcat to $logFile ..." -ForegroundColor Green
# clear log buffer first for cleaner output
ADB "logcat -c"
Start-Sleep -Milliseconds 200
ADB "logcat -d -s QuoteWidgetProvider HomeWidget WidgetSync > $logFile"

Write-Host "Dumping SharedPreferences (run-as)..." -ForegroundColor Green
$runAsSuccess = $false
try {
  & adb -s $DeviceId shell run-as com.example.marx_app cat /data/data/com.example.marx_app/shared_prefs/HomeWidgetPreferences.xml > $prefsFile 2>&1
  if (Test-Path $prefsFile) { $runAsSuccess = $true }
} catch {
  $runAsSuccess = $false
}
if (-not $runAsSuccess) {
  Write-Host "run-as failed; listing shared_prefs folder instead." -ForegroundColor Yellow
  ADB "shell ls -l /data/data/com.example.marx_app/shared_prefs" | Out-File -FilePath (Join-Path $OutDir "shared_prefs_list.txt") -Encoding utf8
}

Write-Host "Attempting APPWIDGET_UPDATE broadcast (may be blocked by system)..." -ForegroundColor Green
ADB "shell am broadcast -a android.appwidget.action.APPWIDGET_UPDATE -n com.example.marx_app/.QuoteWidgetProvider > $broadcastOut 2>&1"

Write-Host "--- Summary ---" -ForegroundColor Cyan
Write-Host "Log file: $logFile"
if (Test-Path $logFile) {
  Write-Host "Top lines of log:" -ForegroundColor Cyan
  Get-Content $logFile -TotalCount 200 | ForEach-Object { Write-Host $_ }
} else { Write-Host "No log file generated." }

if ($runAsSuccess -and (Test-Path $prefsFile)) {
  Write-Host "HomeWidgetPreferences.xml (head):" -ForegroundColor Cyan
  Get-Content $prefsFile -TotalCount 200 | ForEach-Object { Write-Host $_ }
} else {
  Write-Host "HomeWidgetPreferences.xml not available via run-as. See output/shared_prefs_list.txt for folder listing." -ForegroundColor Yellow
  $listFile = Join-Path $OutDir "shared_prefs_list.txt"
  if (Test-Path $listFile) { Get-Content $listFile | ForEach-Object { Write-Host $_ } }
}

Write-Host "Broadcast output (broadcast_out.txt):" -ForegroundColor Cyan
if (Test-Path $broadcastOut) { Get-Content $broadcastOut | ForEach-Object { Write-Host $_ } }

Write-Host "All output is in: $OutDir" -ForegroundColor Green

Pop-Location
