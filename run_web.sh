#!/bin/bash

echo "=============================================="
echo "  Launching Yamifood Restaurant Web App"
echo "=============================================="

# Check if Chrome is available
if command -v google-chrome >/dev/null 2>&1 || command -v chrome >/dev/null 2>&1; then
    echo "Using Chrome browser for development..."
    flutter run -d chrome --web-renderer canvaskit --web-port 8080
# Check if Firefox is available
elif command -v firefox >/dev/null 2>&1; then
    echo "Using Firefox browser for development..."
    flutter run -d web-server --web-renderer canvaskit --web-port 8080
    # Open Firefox manually
    firefox http://localhost:8080
else
    echo "No specific browser detected. Using default web server..."
    flutter run -d web-server --web-renderer canvaskit --web-port 8080
    echo "Please open http://localhost:8080 in your browser"
fi

# Make the script executable if it isn't already
# chmod +x run_web.sh
