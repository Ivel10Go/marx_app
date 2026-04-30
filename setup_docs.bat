@echo off
REM Create lib\docs directory
mkdir lib\docs 2>nul

REM Move documentation files
if exist FIREBASE_SETUP.md move FIREBASE_SETUP.md lib\docs\
if exist REVENUECAT_SETUP.md move REVENUECAT_SETUP.md lib\docs\
if exist ADMOB_SETUP.md move ADMOB_SETUP.md lib\docs\
if exist AFFILIATE_SETUP.md move AFFILIATE_SETUP.md lib\docs\

REM List the files
echo.
echo Files in lib\docs:
dir lib\docs\*.md

echo.
echo Setup complete!
