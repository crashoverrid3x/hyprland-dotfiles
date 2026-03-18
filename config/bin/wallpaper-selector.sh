#!/usr/bin/env bash
set -euo pipefail

# Launch the GUI wallpaper selector from rofi run mode.
nohup waypaper >/dev/null 2>&1 &
