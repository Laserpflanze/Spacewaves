@echo off
title Space Waves - local server
cd /d "%~dp0"
echo Starting local server for Space Waves...
echo.
echo Open http://localhost:8777 in your browser (Ctrl+C here to stop).
echo.
py -m http.server 8777 2>nul || python -m http.server 8777 2>nul || python3 -m http.server 8777
pause
