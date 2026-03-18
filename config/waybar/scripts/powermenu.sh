#!/usr/bin/env bash
set -euo pipefail

ROFI_THEME="$HOME/.config/rofi/themes/powermenu-waybar.rasi"

options=$(cat <<'EOF'
  Bloquear sesion
󰍃  Cerrar sesion
󰤄  Suspender
󰒲  Hibernar
󰑐  Reiniciar
󰐥  Apagar
EOF
)

choice=$(printf "%s\n" "$options" | rofi \
  -dmenu \
  -i \
  -no-custom \
  -p "Power" \
  -location 3 \
  -xoffset -18 \
  -yoffset 56 \
  -theme "$ROFI_THEME") || exit 0

case "$choice" in
  "  Bloquear sesion")
    loginctl lock-session
    ;;
  "󰍃  Cerrar sesion")
    hyprctl dispatch exit
    ;;
  "󰤄  Suspender")
    systemctl suspend
    ;;
  "󰒲  Hibernar")
    systemctl hibernate
    ;;
  "󰑐  Reiniciar")
    systemctl reboot
    ;;
  "󰐥  Apagar")
    systemctl poweroff
    ;;
  *)
    exit 0
    ;;
esac
