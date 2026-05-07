$adbPath = "C:\Users\levin\AppData\Local\Android\sdk\platform-tools\adb.exe"
$device = "19051FDF6000J8"

Write-Host "Back Button Doppel-Click Test"
Write-Host "=============================="
Write-Host "Sending 2 back events quickly..."

& $adbPath -s $device shell input keyevent 4
Start-Sleep -Milliseconds 300
& $adbPath -s $device shell input keyevent 4

Write-Host "2 back events sent. App should have closed."
Start-Sleep -Seconds 2

Write-Host "Checking if app is still running..."
$result = & $adbPath -s $device shell pidof com.example.marx_app
if ($result) {
    Write-Host "❌ FAIL: App still running (PID: $result)"
} else {
    Write-Host "✅ PASS: App closed successfully"
}
