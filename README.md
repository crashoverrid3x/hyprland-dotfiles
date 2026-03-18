# Hyprland Dotfiles + AutoInstall

> Watermark / Autor: Juan Alberto R. Santana (aka crashoverride)

Script principal: [hyprland-autoinstall.sh](hyprland-autoinstall.sh)

Este proyecto permite:
- Instalar un entorno Hyprland completo en Arch Linux desde cero.
- Clonar este repo automaticamente.
- Copiar configuraciones de dotfiles al nuevo sistema.
- Exportar tus dotfiles actuales en estructura jerarquica para subirlos a GitHub.
- Verificar comandos usados en `hyprland.conf` y `waybar` e instalar dependencias faltantes.
- Usar selector grafico de fondos y restaurar wallpaper persistente al iniciar sesion.

## Que instala

El instalador instala:
- Paquetes base: `git`, `curl`, `wget`, `cmake`, `make`, `gcc`, `clang`, `ruby`, `nano`, `neovim`, `vim`, `zsh`, `base-devel`, etc.
- Entorno: `hyprland`, `waybar`, `kitty`, `rofi`, `waypaper`, `swaybg`, `hyprpaper`, `flameshot`, `signal-desktop`, `networkmanager`, `bluez`.
- AUR helpers: `yay` y `paru`.
- AUR package: `visual-studio-code-bin`.
- Opcional: repositorio BlackArch (pregunta interactiva, se procesa antes de instalar helpers AUR).
- Oh My Zsh (si no esta instalado).
- Dependencias de runtime usadas por `config/hypr/hyprland.conf` y `config/waybar/config`.

Comando de referencia para VS Code:
`yay -S visual-studio-code-bin`

## Dotfiles que gestiona

Se copian/aplican estos directorios desde `config/`:
- `bin` (incluye `up.sh`)
- `kitty`
- `nvim`
- `rofi`
- `hypr`
- `waybar`
- `waypaper`
- `flameshot`
- `Signal`

Tambien gestiona:
- `.zshrc`
- `wallpapers/`

## Selector de fondos y persistencia

- Selector GUI: `waypaper` (lo puedes abrir desde rofi: `waypaper` o `wallpaper-selector.sh`).
- Restauracion persistente al iniciar Hyprland: `~/.config/bin/wallpaper-restore.sh`.
- El wallpaper actual se toma desde `~/.config/waypaper/config.ini`.

## Visor de imagenes desde terminal

- Comando rapido: `img <ruta_imagen>`
- Usa `imv` si esta disponible (fallback a `kitty +kitten icat`).

Waypaper en este repo queda configurado para:
- Carpeta de fondos en `~/wallpapers`
- Backend `swaybg`

## Uso rapido

1. Dar permisos de ejecucion:

```bash
chmod +x hyprland-autoinstall.sh
```

2. Ejecutar:

```bash
./hyprland-autoinstall.sh
```

3. Elegir una opcion del menu interactivo:
- `1`: Instalar todo en un Arch nuevo.
- `2`: Exportar dotfiles actuales.
- `3`: Instalar y luego exportar.
- `4`: Salir.

## Flujo recomendado para PC nueva

1. Instalar Arch base con internet funcionando.
2. Clonar este repo.
3. Ejecutar `./hyprland-autoinstall.sh`.
4. Elegir opcion `1`.
5. Reiniciar sesion al finalizar.

## Exportacion para subir a GitHub

Con la opcion `2` o `3`, el script genera:

- `dotfiles-export/config/...`
- `dotfiles-export/.zshrc`

Con esto puedes revisar, versionar y subir tus configuraciones sin tocar tu sistema actual.

## Notas

- El script esta pensado para Arch Linux.
- Si una config no existe en tu sistema o en el repo, se muestra advertencia y continua.
- Antes de sobrescribir `~/.zshrc`, crea backup automatico en `~/.zshrc.bak.TIMESTAMP`.