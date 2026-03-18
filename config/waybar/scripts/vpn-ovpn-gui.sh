#!/usr/bin/env bash
set -euo pipefail

if command -v nm-connection-editor >/dev/null 2>&1; then
  exec nm-connection-editor
fi

if command -v gtk-launch >/dev/null 2>&1; then
  exec gtk-launch nm-connection-editor.desktop
fi

if command -v gnome-control-center >/dev/null 2>&1; then
  exec gnome-control-center network
fi

notify-send "VPN" "No se encontro NetworkManager editor (nm-connection-editor)."
exit 1
