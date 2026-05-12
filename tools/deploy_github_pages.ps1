# Copy privacy policy to docs/ and push to GitHub (for GitHub Pages)
# Usage: run in project root (PowerShell)
# Requires: git configured with push access to origin/main (or change branch)

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
# project root is the parent of the script's parent (tools folder)
$projectRoot = Resolve-Path (Join-Path $scriptPath '..')
$src = "${projectRoot}\assets\branding\privacy_policy.html"
$dstDir = "${projectRoot}\docs"
$dst = "${dstDir}\privacy_policy.html"

if (-not (Test-Path $src)) { Write-Error "Source not found: $src"; exit 1 }
if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory -Path $dstDir | Out-Null }
Copy-Item -Path $src -Destination $dst -Force

Write-Host "Copied privacy policy to $dst"

# Git commit & push
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Write-Host 'git not found in PATH — please install/configure git and run the commit manually.'; exit 0 }

Set-Location $projectRoot
git add docs/privacy_policy.html
$commitMsg = 'Add privacy policy for Play Store (GitHub Pages)'
$st = git status --porcelain
if ($st -eq '') { Write-Host 'No changes to commit.'; exit 0 }

git commit -m $commitMsg
if ($LASTEXITCODE -ne 0) { Write-Error 'git commit failed'; exit 1 }

Write-Host 'Pushing to origin main...'
git push origin main
if ($LASTEXITCODE -ne 0) { Write-Error 'git push failed. Ensure you have push rights and the remote branch exists.'; exit 1 }

Write-Host 'Push complete. Enable GitHub Pages in the repo Settings → Pages: set source to branch `main` / folder `docs`.'
