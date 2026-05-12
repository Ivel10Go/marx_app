param(
    [switch]$Force
)

$files = @(
    "INTERNAL_TRACK_UPLOAD_RUNBOOK.md",
    "LAUNCH_CHECKLIST.md",
    "LAUNCH_OVERVIEW_GROB.md",
    "LAUNCH_READINESS_REPORT.md",
    "PHASE_4_DEPLOYMENT_GUIDE.md",
    "PHASE_4_PLAYSTORE_PREP.md",
    "PHASE_4_SUMMARY.md",
    "REVENUECAT_SETUP.md",
    "SCREENSHOTS_CAPTURE_GUIDE.md",
    "SESSION_10_05_SUMMARY.md",
    "SESSION_COMPLETION_SUMMARY.md",
    "SUPABASE_INTEGRATION_CHECKLIST.md",
    "SUPABASE_SETUP.md",
    "TEST_RUNBOOK_PAYMENT_FLOW.md",
    "TEST_RUNBOOK_PIXEL6_FINAL_QA.md",
    "ZITATE_DATENBANK_UPDATE.md"
)

Write-Host "Folgende Dateien werden enttrackt (aus dem Git-Index entfernt, lokal erhalten):"
$files | ForEach-Object { Write-Host " - $_" }

if (-not $Force) {
    $ans = Read-Host "Fortfahren und Änderungen committen + pushen? (J/N)"
    if ($ans.ToUpper() -ne 'J' -and $ans.ToUpper() -ne 'Y') {
        Write-Host "Abgebrochen by user. Keine Änderungen vorgenommen."
        exit 0
    }
}

try {
    $branch = (& git rev-parse --abbrev-ref HEAD).Trim()
    foreach ($f in $files) {
        Write-Host "git rm --cached --ignore-unmatch $f"
        & git rm --cached --ignore-unmatch $f
    }

    Write-Host "Staging .gitignore"
    & git add .gitignore

    $msg = "Untrack top-level summary/test/runbook MD files"
    & git commit -m $msg

    Write-Host "Pushing to origin/$branch"
    & git push origin $branch

    Write-Host "Fertig. Prüfen Sie GitHub auf Änderungen."
} catch {
    Write-Host "Fehler während Ausführung: $_"
    exit 1
}
