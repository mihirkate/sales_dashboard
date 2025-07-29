@echo off
echo ======================================
echo  Building Sales Dashboard APK
echo ======================================
echo.

cd /d "d:\flutter\sales_dashboard_app"

echo [1/4] Cleaning previous builds...
call flutter clean
if %errorlevel% neq 0 (
    echo ERROR: Flutter clean failed
    pause
    exit /b 1
)

echo [2/4] Getting dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Flutter pub get failed
    pause
    exit /b 1
)

echo [3/4] Checking Flutter doctor...
call flutter doctor --android-licenses
echo.

echo [4/4] Building release APK...
call flutter build apk --release
if %errorlevel% neq 0 (
    echo ERROR: APK build failed
    pause
    exit /b 1
)

echo.
echo ======================================
echo  BUILD COMPLETED SUCCESSFULLY!
echo ======================================
echo.
echo APK Location: build\app\outputs\flutter-apk\app-release.apk
echo.
echo Opening build directory...
explorer build\app\outputs\flutter-apk\
echo.
pause
