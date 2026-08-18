#!/bin/bash
set -e

# First rebuild the application to ensure we run the latest code
./build.sh

# Open/Launch the compiled application bundle
echo "🚀 Launching Mastery Clock macOS App..."
open MasteryClock.app
echo "✅ Launched successfully! Look for the stopwatch icon in your macOS Menu Bar at the top."
