#!/usr/bin/env bash
set -euo pipefail

# Limpia configuraciones de Hyprland/Waybar y componentes relacionados.
# No desinstala paquetes.

TARGETS=(
  "$HOME/.config/hypr"
  "$HOME/.config/waybar"
  "$HOME/.config/waypaper"
  "$HOME/.config/wlogout"
  "$HOME/.config/rofi"
)

# Archivos/scripts sueltos relacionados que suelen quedar fuera de esas carpetas.
EXTRA_FILES=(
  "$HOME/.config/bin/wallpaper-selector.sh"
  "$HOME/.config/bin/wallpaper-restore.sh"
  "$HOME/.config/bin/img"
)

echo "==============================================="
echo " Limpieza de configuracion Hyprland/Waybar"
echo "==============================================="
echo
echo "Se eliminaran estas rutas (si existen):"
for p in "${TARGETS[@]}"; do
  echo "  - $p"
done
for p in "${EXTRA_FILES[@]}"; do
  echo "  - $p"
done
echo
echo "Esto NO desinstala paquetes. Solo borra configuracion."
echo

read -r -p "Escribe DELETE para continuar: " confirm
if [[ "$confirm" != "DELETE" ]]; then
  echo "Cancelado. No se realizo ningun cambio."
  exit 0
fi

for p in "${TARGETS[@]}"; do
  if [[ -e "$p" ]]; then
    rm -rf -- "$p"
    echo "Eliminado: $p"
  else
    echo "No existe: $p"
  fi
done

for p in "${EXTRA_FILES[@]}"; do
  if [[ -e "$p" ]]; then
    rm -f -- "$p"
    echo "Eliminado: $p"
  else
    echo "No existe: $p"
  fi
done

echo
echo "Limpieza completada."
