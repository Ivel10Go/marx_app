$adbPath = "C:\Users\levin\AppData\Local\Android\sdk\platform-tools\adb.exe"
$device = "19051FDF6000J8"

Write-Host "Offline Content Load Test"
Write-Host "=========================="
Write-Host "[1] Stopping app..."
& $adbPath -s $device shell am force-stop com.example.marx_app
Start-Sleep -Seconds 1

Write-Host "[2] Disabling WiFi and Mobile Data..."
& $adbPath -s $device shell svc wifi disable
& $adbPath -s $device shell svc data disable
Start-Sleep -Seconds 2

Write-Host "[3] Starting app (offline)..."
& $adbPath -s $device shell am start -n com.example.marx_app/.MainActivity
Write-Host "Waiting 5 seconds for app to load (should show cached content)..."
Start-Sleep -Seconds 5

Write-Host "[4] Capturing error logs..."
& $adbPath -s $device logcat -d -v time "*:E" | Out-File -FilePath f:\Levi\flutter_projekts\Marx\marx_app\offline_test_log.txt -Encoding utf8

Write-Host "[5] Re-enabling WiFi..."
& $adbPath -s $device shell svc wifi enable

Write-Host "Test complete. Check offline_test_log.txt for errors."
