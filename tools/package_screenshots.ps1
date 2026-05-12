# Paketiert alle Play-Store-Screenshots in assets/screenshots/play_screenshots.zip
$zipPath = "$PSScriptRoot\..\assets\screenshots\play_screenshots.zip"
$src = "$PSScriptRoot\..\assets\screenshots\"
if (-not (Test-Path $src)) { Write-Error "Screenshot-Ordner nicht gefunden: $src"; exit 1 }
if (Test-Path $zipPath) { Remove-Item $zipPath }
Add-Type -AssemblyName System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory($src, $zipPath)
Write-Host "ZIP erstellt: $zipPath"