for ($i=0; $i -lt 50; $i++) {
  & 'C:\Users\levin\AppData\Local\Android\sdk\platform-tools\adb.exe' -s 19051FDF6000J8 shell input keyevent 4
  Start-Sleep -Milliseconds 200
}
Write-Output "Sent $i back events"