$adbPath = "C:\Users\levin\AppData\Local\Android\sdk\platform-tools\adb.exe"
$device = "19051FDF6000J8"

Write-Host "[1/3] Stopping app..."
& $adbPath -s $device shell am force-stop com.example.marx_app
Start-Sleep -Seconds 2

Write-Host "[2/3] Clearing logcat..."
& $adbPath -s $device logcat -c
Start-Sleep -Seconds 1

Write-Host "[3/3] Starting cold app..."
& $adbPath -s $device shell am start -n com.example.marx_app/.MainActivity
Write-Host "App started, waiting 8 seconds for load..."
Start-Sleep -Seconds 8

Write-Host "Cold start complete. Capturing final logcat..."
& $adbPath -s $device logcat -d -v time *:E > "f:\Levi\flutter_projekts\Marx\marx_app\cold_start_log.txt"
Write-Host "Logs captured to cold_start_log.txt"
