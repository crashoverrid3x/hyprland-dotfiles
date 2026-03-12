#!/bin/bash

# =============================================
# Script de instalación de Hyprland v0.40.0
# Probado en Parrot OS 7.1 / Debian Bookworm
# =============================================

set -e  # Salir si hay error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_step() {
    echo -e "${BLUE}==>${NC} ${GREEN}$1${NC}"
}

print_error() {
    echo -e "${RED}ERROR:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}ADVERTENCIA:${NC} $1"
}

# Verificar que se ejecuta como usuario normal (no root)
if [ "$EUID" -eq 0 ]; then 
    print_error "No ejecutes este script como root. Usa un usuario normal."
    exit 1
fi

# Actualizar sistema
print_step "Actualizando lista de paquetes..."
sudo apt update

# =============================================
# PASO 1: Instalar dependencias del sistema
# =============================================
print_step "Instalando dependencias base del sistema..."

# Paquetes esenciales de compilación
ESSENTIAL_PKGS="build-essential cmake meson ninja-build pkg-config git curl wget"
ESSENTIAL_PKGS="$ESSENTIAL_PKGS python3 python3-pip gettext gettext-base"

# Bibliotecas de desarrollo
DEV_PKGS="libffi-dev libxml2-dev libdrm-dev libpixman-1-dev libudev-dev"
DEV_PKGS="$DEV_PKGS libseat-dev seatd libxcb-dri3-dev libvulkan-dev"
DEV_PKGS="$DEV_PKGS libvulkan-volk-dev vulkan-utility-libraries-dev"
DEV_PKGS="$DEV_PKGS libvkfft-dev libgulkan-dev libegl-dev libglvnd-dev"
DEV_PKGS="$DEV_PKGS libgles2 libegl1-mesa-dev glslang-tools"

# Bibliotecas gráficas y Wayland
WAYLAND_PKGS="libwayland-dev wayland-protocols wayland-scanner++"
WAYLAND_PKGS="$WAYLAND_PKGS libwayland-egl-backend-dev libwayland-cursor0"
WAYLAND_PKGS="$WAYLAND_PKGS libwayland-client0 libwayland-server0"

# X11 y XWayland
X11_PKGS="libxkbcommon-dev libxkbcommon-x11-dev xwayland"
X11_PKGS="$X11_PKGS libxcb-composite0-dev libxcb-ewmh-dev libxcb-icccm4-dev"
X11_PKGS="$X11_PKGS libxcb-render-util0-dev libxcb-res0-dev libxcb-xinput-dev"
X11_PKGS="$X11_PKGS libxcb-errors-dev libxcursor-dev"

# Multimedia y utilidades
UTIL_PKGS="libavutil-dev libavcodec-dev libavformat-dev"
UTIL_PKGS="$UTIL_PKGS libinput-dev libdisplay-info-dev hwdata"
UTIL_PKGS="$UTIL_PKGS libliftoff-dev libpugixml-dev libre2-dev"
UTIL_PKGS="$UTIL_PKGS libmuparser-dev liblcms2-dev libtomlplusplus-dev"
UTIL_PKGS="$UTIL_PKGS libcairo2-dev libzip-dev librsvg2-dev libjpeg-dev"
UTIL_PKGS="$UTIL_PKGS libwebp-dev libmagic-dev libjxl-dev libjxl-cms-dev"

# Instalar todo
sudo apt install -y $ESSENTIAL_PKGS $DEV_PKGS $WAYLAND_PKGS $X11_PKGS $UTIL_PKGS

# =============================================
# PASO 2: Configurar backports (para versiones actualizadas)
# =============================================
print_step "Configurando backports de Debian para paquetes actualizados..."

# Agregar backports si no existe
if ! grep -q "bookworm-backports" /etc/apt/sources.list; then
    echo "deb http://deb.debian.org/debian bookworm-backports main" | sudo tee -a /etc/apt/sources.list
    sudo apt update
fi

# Instalar versiones actualizadas desde backports
sudo apt install -t bookworm-backports -y \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    wayland-protocols

# =============================================
# PASO 3: Instalar hyprutils (desde GitHub)
# =============================================
print_step "Instalando hyprutils desde GitHub..."
cd ~
if [ -d "hyprutils" ]; then
    rm -rf hyprutils
fi
git clone https://github.com/hyprwm/hyprutils.git
cd hyprutils
git checkout v0.11.0  # Versión estable
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -S . -B ./build
cmake --build ./build --config Release -j $(nproc)
sudo cmake --install build

# =============================================
# PASO 4: Instalar hyprlang (desde GitHub)
# =============================================
print_step "Instalando hyprlang desde GitHub..."
cd ~
if [ -d "hyprlang" ]; then
    rm -rf hyprlang
fi
git clone https://github.com/hyprwm/hyprlang.git
cd hyprlang
git checkout v0.6.8  # Versión estable
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -S . -B ./build
cmake --build ./build --config Release -j $(nproc)
sudo cmake --install build

# =============================================
# PASO 5: Instalar hyprcursor (desde GitHub)
# =============================================
print_step "Instalando hyprcursor desde GitHub..."
cd ~
if [ -d "hyprcursor" ]; then
    rm -rf hyprcursor
fi
git clone https://github.com/hyprwm/hyprcursor.git
cd hyprcursor
git checkout v0.1.13  # Versión estable
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -S . -B ./build
cmake --build ./build --config Release -j $(nproc)
sudo cmake --install build

# =============================================
# PASO 6: Instalar hyprgraphics (desde GitHub)
# =============================================
print_step "Instalando hyprgraphics desde GitHub..."
cd ~
if [ -d "hyprgraphics" ]; then
    rm -rf hyprgraphics
fi
git clone https://github.com/hyprwm/hyprgraphics.git
cd hyprgraphics
git checkout v0.5.0  # Versión estable
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -S . -B ./build
cmake --build ./build --config Release -j $(nproc)
sudo cmake --install build

# =============================================
# PASO 7: Instalar aquamarine (desde GitHub)
# =============================================
print_step "Instalando aquamarine desde GitHub..."
cd ~
if [ -d "aquamarine" ]; then
    rm -rf aquamarine
fi
git clone https://github.com/hyprwm/aquamarine.git
cd aquamarine
git checkout v0.10.0  # Versión estable
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -S . -B ./build
cmake --build ./build --config Release -j $(nproc)
sudo cmake --install build

# =============================================
# PASO 8: Instalar hyprwire (versión específica)
# =============================================
print_step "Instalando hyprwire desde GitHub..."
cd ~
if [ -d "hyprwire" ]; then
    rm -rf hyprwire
fi
git clone https://github.com/hyprwm/hyprwire.git
cd hyprwire
git checkout v0.2.1  # Versión estable sin problemas de C++23

# Aplicar parche para compatibilidad con GCC 14
print_step "Aplicando parche para hyprwire..."
sed -i 's/append_range/insert(end(),/g' $(find . -type f -name "*.cpp" -o -name "*.hpp")

cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_CXX_STANDARD=20 -S . -B ./build
cmake --build ./build --config Release -j $(nproc)
sudo cmake --install build

# =============================================
# PASO 9: Configurar PKG_CONFIG_PATH
# =============================================
print_step "Configurando PKG_CONFIG_PATH..."
echo 'export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:$PKG_CONFIG_PATH' >> ~/.bashrc
echo 'export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:$PKG_CONFIG_PATH' >> ~/.zshrc 2>/dev/null || true
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:$PKG_CONFIG_PATH

# =============================================
# PASO 10: Instalar Hyprland (versión v0.40.0)
# =============================================
print_step "Clonando Hyprland versión v0.40.0..."
cd ~
if [ -d "Hyprland" ]; then
    mv Hyprland Hyprland.backup.$(date +%s)
fi
git clone https://github.com/hyprwm/Hyprland.git
cd Hyprland
git checkout v0.40.0

print_step "Inicializando submódulos..."
git submodule update --init --recursive --force

# Aplicar parche para OutputManagement.cpp
print_step "Aplicando parche para OutputManagement.cpp..."
cat > outputmanagement.patch << 'EOF'
--- a/src/protocols/OutputManagement.cpp
+++ b/src/protocols/OutputManagement.cpp
@@ -166,7 +166,7 @@
 
 void COutputHead::sendAllData() {
     for (auto const& m : modes) {
-                resource->sendCurrentMode(m->resource);
+                resource->sendCurrentMode(m->resource.get());
     }
 
     for (auto const& [name, value] : customProperties) {
@@ -197,7 +197,7 @@
     if (state->mode) {
         for (auto const& m : modes) {
             if (m->resource->resource() == state->mode) {
-                resource->sendCurrentMode(m->resource);
+                resource->sendCurrentMode(m->resource.get());
                 break;
             }
         }
EOF

# Aplicar el parche
patch -p1 < outputmanagement.patch 2>/dev/null || print_warning "El parche ya estaba aplicado"

# Compilar Hyprland
print_step "Compilando Hyprland (esto tomará varios minutos)..."
make clear 2>/dev/null || true
make all -j $(nproc)

print_step "Instalando Hyprland..."
sudo make install

# =============================================
# PASO 11: Crear archivos de sesión
# =============================================
print_step "Creando archivo de sesión para gestores de display..."
sudo tee /usr/share/wayland-sessions/hyprland.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF

# =============================================
# PASO 12: Configuración básica
# =============================================
print_step "Creando configuración básica de Hyprland..."
mkdir -p ~/.config/hypr

if [ ! -f ~/.config/hypr/hyprland.conf ]; then
    cat > ~/.config/hypr/hyprland.conf << 'EOF'
# Configuración básica de Hyprland
monitor=,preferred,auto,1

exec-once = waybar & dunst

input {
    kb_layout = es,us
    kb_variant =
    kb_model =
    kb_options = grp:alt_shift_toggle
    follow_mouse = 1
    
    touchpad {
        natural_scroll = no
    }
}

general {
    gaps_in = 5
    gaps_out = 20
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
    layout = dwindle
}

decoration {
    rounding = 10
    blur {
        enabled = true
        size = 3
        passes = 1
    }
}

animations {
    enabled = true
}

$mainMod = SUPER

bind = $mainMod, Q, exec, kitty
bind = $mainMod, C, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, thunar
bind = $mainMod, V, togglefloating,
bind = $mainMod, R, exec, rofi -show drun
bind = $mainMod, P, pseudo,
bind = $mainMod, J, togglesplit,

bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

bind = $mainMod SHIFT, left, movewindow, l
bind = $mainMod SHIFT, right, movewindow, r
bind = $mainMod SHIFT, up, movewindow, u
bind = $mainMod SHIFT, down, movewindow, d

bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1
EOF
fi

# =============================================
# PASO 13: Instalar aplicaciones recomendadas
# =============================================
print_step "Instalando aplicaciones recomendadas..."
sudo apt install -y \
    kitty \
    thunar \
    rofi \
    waybar \
    dunst \
    swaylock \
    swayidle \
    wlogout \
    pavucontrol \
    brightnessctl \
    playerctl \
    pamixer \
    network-manager-gnome \
    grim \
    slurp \
    wl-clipboard

# =============================================
# FINAL: Verificación
# =============================================
print_step "Verificando instalación..."
if command -v Hyprland &> /dev/null; then
    echo -e "${GREEN}¡Hyprland se instaló correctamente!${NC}"
    Hyprland --version
    echo ""
    echo -e "${GREEN}Para iniciar Hyprland:${NC}"
    echo "  - Desde la terminal: Hyprland"
    echo "  - Desde el gestor de sesiones: Selecciona 'Hyprland' en la pantalla de login"
    echo ""
    echo -e "${GREEN}Configuración:${NC} ~/.config/hypr/hyprland.conf"
    echo -e "${GREEN}Binarios instalados:${NC} Hyprland, hyprctl, hyprpm"
else
    print_error "Algo salió mal. Hyprland no se encuentra en el PATH."
fi

print_step "¡Instalación completada! Puede que necesites reiniciar la sesión."
