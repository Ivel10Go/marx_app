param(
  [string]$DeviceId = "19051FDF6000J8",
  [string]$AppId = "com.example.marx_app",
  [string]$OutDir = "qa_reports"
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

if (-not (Test-Path $OutDir)) {
  New-Item -ItemType Directory -Path $OutDir | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$reportPath = Join-Path $OutDir "pixel6_final_qa_$timestamp.md"

function Write-Section {
  param([string]$Text)
  Add-Content -Path $reportPath -Value $Text
}

Write-Host "Running automated Pixel6 QA subset on device $DeviceId"

Write-Section "# Pixel6 Final QA Report"
Write-Section ""
Write-Section "- Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Section "- Device: $DeviceId"
Write-Section "- App ID: $AppId"
Write-Section "- Branch: $(git branch --show-current)"
Write-Section "- Commit: $(git rev-parse --short HEAD)"
Write-Section ""
Write-Section "## Automated Checks"

# 1) Cold Start Test
Write-Host "[1/3] Cold start test..."
try {
  & pwsh "$PSScriptRoot/cold_start_test.ps1" | Out-Null
  Write-Section "- [x] Cold start script executed"
} catch {
  Write-Section "- [ ] Cold start script failed: $($_.Exception.Message)"
}

# 2) Offline Test
Write-Host "[2/3] Offline load test..."
try {
  & pwsh "$PSScriptRoot/offline_test.ps1" | Out-Null
  Write-Section "- [x] Offline test script executed"
} catch {
  Write-Section "- [ ] Offline test script failed: $($_.Exception.Message)"
}

# 3) Back button test
Write-Host "[3/3] Back button test..."
try {
  $backResult = & pwsh "$PSScriptRoot/back_button_test.ps1" 2>&1
  $backText = ($backResult | Out-String)
  if ($backText -match "PASS") {
    Write-Section "- [x] Back button test passed"
  } else {
    Write-Section "- [ ] Back button test needs review"
  }
} catch {
  Write-Section "- [ ] Back button test failed: $($_.Exception.Message)"
}

Write-Section ""
Write-Section "## Log Files"
Write-Section "- cold_start_log.txt"
Write-Section "- offline_test_log.txt"
Write-Section ""
Write-Section "## Manual Follow-up (Runbook)"
Write-Section "- Billing flow"
Write-Section "- Restore purchases"
Write-Section "- Supabase login + favorites sync"
Write-Section "- Notifications settings"

Write-Host "Done. QA report: $reportPath"
