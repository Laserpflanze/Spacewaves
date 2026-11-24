#!/usr/bin/env bash
# Space Waves - local server helper
cd "$(dirname "$0")"
echo "Open http://localhost:8777 in your browser (Ctrl+C to stop)."
python3 -m http.server 8777
