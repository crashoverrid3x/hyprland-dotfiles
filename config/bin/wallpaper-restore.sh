#!/usr/bin/env bash
set -euo pipefail

CFG="$HOME/.config/waypaper/config.ini"

if [[ ! -f "$CFG" ]]; then
  exit 0
fi

wallpaper=$(awk -F' = ' '/^wallpaper = / {print $2}' "$CFG" | tail -n1)
if [[ -z "$wallpaper" ]]; then
  exit 0
fi

wallpaper="${wallpaper/#\~/$HOME}"
if [[ ! -f "$wallpaper" ]]; then
  exit 0
fi

# Ensure only one wallpaper process and restore last selected wallpaper.
pkill -x swaybg >/dev/null 2>&1 || true
nohup swaybg -i "$wallpaper" -m fill >/dev/null 2>&1 &