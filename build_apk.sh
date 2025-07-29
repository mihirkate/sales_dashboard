#!/bin/bash

echo "======================================"
echo "  Building Sales Dashboard APK"
echo "======================================"
echo

cd "/d/flutter/sales_dashboard_app"

echo "[1/4] Cleaning previous builds..."
flutter clean
if [ $? -ne 0 ]; then
    echo "ERROR: Flutter clean failed"
    exit 1
fi

echo "[2/4] Getting dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "ERROR: Flutter pub get failed"
    exit 1
fi

echo "[3/4] Checking Flutter setup..."
flutter doctor
echo

echo "[4/4] Building release APK..."
flutter build apk --release
if [ $? -ne 0 ]; then
    echo "ERROR: APK build failed"
    exit 1
fi

echo
echo "======================================"
echo "  BUILD COMPLETED SUCCESSFULLY!"
echo "======================================"
echo
echo "APK Location: build/app/outputs/flutter-apk/app-release.apk"
echo

# List the APK files
if [ -d "build/app/outputs/flutter-apk" ]; then
    echo "Generated APK files:"
    ls -la build/app/outputs/flutter-apk/*.apk
fi
