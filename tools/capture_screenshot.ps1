# Capture a device screenshot via adb and produce two resized versions for Play Store
# Usage: 1) Open the screen you want on the device/emulator.
#        2) Run: .\tools\capture_screenshot.ps1 -name home
param(
    [string]$name = "screenshot"
)

$adb = "adb"

# temp file on host
$outRaw = "$PSScriptRoot\..\assets\screenshots\${name}_raw.png"
$out6x7 = "$PSScriptRoot\..\assets\screenshots\${name}_6x7.png"
$out5x1 = "$PSScriptRoot\..\assets\screenshots\${name}_5x1.png"

# ensure folder exists
$dir = Split-Path $outRaw
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }

Write-Host "Capturing screen to $outRaw ..."
# capture PNG from device
& $adb exec-out screencap -p > $outRaw
if ($LASTEXITCODE -ne 0) { Write-Error "adb screencap failed. Ensure device/emulator is connected and adb is in PATH."; exit 1 }

# Resize using .NET System.Drawing (requires Windows PowerShell Full)
Add-Type -AssemblyName System.Drawing
function Resize-Image($inPath, $outPath, $width, $height) {
    $img = [System.Drawing.Image]::FromFile($inPath)
    $thumb = New-Object System.Drawing.Bitmap $width, $height
    $g = [System.Drawing.Graphics]::FromImage($thumb)
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.DrawImage($img, 0, 0, $width, $height)
    $img.Dispose()
    $g.Dispose()
    $thumb.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $thumb.Dispose()
}

Write-Host "Resizing to 1440x2560 -> $out6x7"
Resize-Image $outRaw $out6x7 1440 2560
Write-Host "Resizing to 1080x1920 -> $out5x1"
Resize-Image $outRaw $out5x1 1080 1920

Write-Host "Screenshots saved: `n  $out6x7`n  $out5x1"