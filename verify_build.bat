@echo off
cd /d "F:\Levi\flutter_projekts\Marx\marx_app"
echo Running flutter pub get...
call flutter pub get
if %ERRORLEVEL% EQU 0 (
    echo.
    echo Running dart analyze...
    call dart analyze lib/core/utils/image_loader.dart
) else (
    echo Failed to run pub get
    exit /b 1
)
