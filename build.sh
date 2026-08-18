#!/bin/bash
set -e

echo "🔨 Building Mastery Clock macOS App..."

# Create app bundle directories
mkdir -p MasteryClock.app/Contents/MacOS

# Copy Info.plist
cp Sources/MasteryClock/Info.plist MasteryClock.app/Contents/Info.plist

# Compile the Swift files
swiftc -O -sdk $(xcrun --show-sdk-path --sdk macosx) \
  -o MasteryClock.app/Contents/MacOS/MasteryClock \
  Sources/MasteryClock/MasteryClockApp.swift \
  Sources/MasteryClock/ContentView.swift \
  Sources/MasteryClock/TimerEngine.swift

echo "✅ App built successfully! Run it with:"
echo "   open MasteryClock.app"
