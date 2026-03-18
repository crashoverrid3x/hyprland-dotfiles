#!/usr/bin/env bash
# Watermark / Autor: Juan Alberto R. Santana (aka crashoverride)
set -euo pipefail

REPO_URL="https://github.com/crashoverrid3x/hyprland-dotfiles.git"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_CLONE_DIR="$HOME/hyprland-dotfiles"
EXPORT_DIR="$SCRIPT_DIR/dotfiles-export"

CFG_ITEMS=(
	"bin"
	"kitty"
	"nvim"
	"rofi"
	"hypr"
	"waybar"
	"waypaper"
	"wlogout"
	"flameshot"
	"Signal"
)

PACMAN_PACKAGES=(
	base-devel
	git
	curl
	wget
	unzip
	cmake
	make
	gcc
	clang
	ruby
	nano
	neovim
	vim
	zsh
	hyprland
	waybar
	kitty
	rofi
	swww
	imv
	swaybg
	hyprpaper
	flameshot
	signal-desktop
	pipewire
	pipewire-pulse
	wireplumber
	bluez
	bluez-utils
	networkmanager
)

AUR_PACKAGES=(
	visual-studio-code-bin
	light
	wlogout
	waypaper
)

# Dependencias detectadas por uso en config/hypr/hyprland.conf y config/waybar/config
CONFIG_PACMAN_DEPENDENCIES=(
	dbus
	xdg-desktop-portal
	xdg-desktop-portal-hyprland
	dolphin
	firefox
	keepassxc
	brightnessctl
	playerctl
	wl-clipboard
	hyprshot
	pipewire
	pipewire-pulse
	wireplumber
	libpulse
	swww
	imv
	blueman
	gnome-control-center
	alacritty
	pacman-contrib
	libnotify
	psmisc
)

CONFIG_AUR_DEPENDENCIES=(
	hyprlauncher
	burpsuite
)

CONFIG_COMMANDS_TO_VERIFY=(
	waybar
	hyprctl
	waypaper
	swww
	swaybg
	imv
	kitty
	dolphin
	firefox
	burpsuite
	caido
	keepassxc
	rofi
	hyprlauncher
	hyprshot
	brightnessctl
	wpctl
	playerctl
	pactl
	gtk-launch
	nm-connection-editor
	blueman-manager
	gnome-control-center
	light
	wlogout
	checkupdates
	alacritty
	notify-send
)

say() {
	printf "\n[+] %s\n" "$*"
}

warn() {
	printf "\n[!] %s\n" "$*"
}

ask_yes_no() {
	local prompt="$1"
	local default="${2:-y}"
	local answer

	if [[ "$default" == "y" ]]; then
		read -r -p "$prompt [Y/n]: " answer || true
		answer="${answer:-Y}"
	else
		read -r -p "$prompt [y/N]: " answer || true
		answer="${answer:-N}"
	fi

	[[ "$answer" =~ ^[Yy]$ ]]
}

require_sudo() {
	say "Solicitando permisos sudo..."
	sudo -v
}

ensure_pacman_pkg() {
	local pkg="$1"
	if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
		sudo pacman -S --needed --noconfirm "$pkg"
	fi
}

install_core_packages() {
	say "Instalando paquetes base con pacman..."
	sudo pacman -Syu --noconfirm
	sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
}

install_yay() {
	if command -v yay >/dev/null 2>&1; then
		say "yay ya esta instalado."
		return
	fi

	say "Instalando yay desde AUR..."
	ensure_pacman_pkg base-devel
	ensure_pacman_pkg git

	local tmp_dir
	tmp_dir="$(mktemp -d)"
	git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"
	(
		cd "$tmp_dir/yay"
		makepkg -si --noconfirm
	)
	rm -rf "$tmp_dir"
}

install_paru() {
	if command -v paru >/dev/null 2>&1; then
		say "paru ya esta instalado."
		return
	fi

	say "Instalando paru desde AUR..."
	ensure_pacman_pkg base-devel
	ensure_pacman_pkg git

	local tmp_dir
	tmp_dir="$(mktemp -d)"
	git clone https://aur.archlinux.org/paru.git "$tmp_dir/paru"
	(
		cd "$tmp_dir/paru"
		makepkg -si --noconfirm
	)
	rm -rf "$tmp_dir"
}

install_blackarch_repo() {
	if ! ask_yes_no "Quieres instalar el repo de BlackArch?" "n"; then
		say "Saltando BlackArch."
		return
	fi

	say "Instalando BlackArch repository..."
	local tmp_dir
	tmp_dir="$(mktemp -d)"
	(
		cd "$tmp_dir"
		curl -fsSLO https://blackarch.org/strap.sh
		chmod +x strap.sh
		sudo ./strap.sh
	)
	rm -rf "$tmp_dir"
}

install_aur_packages() {
	say "Instalando paquetes AUR con yay..."
	yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"
}

install_config_dependencies() {
	say "Verificando dependencias usadas por hyprland.conf y waybar..."

	local missing_pacman=()
	local pkg
	for pkg in "${CONFIG_PACMAN_DEPENDENCIES[@]}"; do
		if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
			missing_pacman+=("$pkg")
		fi
	done

	if ((${#missing_pacman[@]} > 0)); then
		say "Instalando faltantes (pacman): ${missing_pacman[*]}"
		sudo pacman -S --needed --noconfirm "${missing_pacman[@]}"
	else
		say "Dependencias pacman de config: OK"
	fi

	local missing_aur=()
	for pkg in "${CONFIG_AUR_DEPENDENCIES[@]}"; do
		if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
			missing_aur+=("$pkg")
		fi
	done

	if ((${#missing_aur[@]} > 0)); then
		say "Instalando faltantes (AUR): ${missing_aur[*]}"
		yay -S --needed --noconfirm "${missing_aur[@]}" || warn "Algunos paquetes AUR de config no se pudieron instalar automaticamente."
	else
		say "Dependencias AUR de config: OK"
	fi
}

verify_config_commands() {
	say "Comprobando comandos usados por configuracion..."

	local cmd
	local missing=0
	for cmd in "${CONFIG_COMMANDS_TO_VERIFY[@]}"; do
		if ! command -v "$cmd" >/dev/null 2>&1; then
			warn "Comando no encontrado: $cmd"
			missing=1
		fi
	done

	if [[ "$missing" -eq 0 ]]; then
		say "Comandos de configuracion: OK"
	else
		warn "Hay comandos faltantes en runtime. Revisa los warnings (ejemplo: caido puede ser instalacion manual)."
	fi
}

install_oh_my_zsh() {
	if [[ -d "$HOME/.oh-my-zsh" ]]; then
		say "oh-my-zsh ya esta instalado."
		return
	fi

	say "Instalando oh-my-zsh..."
	RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

clone_repo() {
	local clone_dir="$1"

	if [[ -d "$clone_dir/.git" ]]; then
		say "Repositorio ya existe en $clone_dir. Haciendo pull..."
		git -C "$clone_dir" pull --ff-only
		return
	fi

	say "Clonando repo en $clone_dir..."
	mkdir -p "$(dirname "$clone_dir")"
	git clone "$REPO_URL" "$clone_dir"
}

copy_if_exists() {
	local src="$1"
	local dst="$2"

	if [[ -e "$src" ]]; then
		mkdir -p "$(dirname "$dst")"
		cp -a "$src" "$dst"
		return
	fi

	warn "No se encontro: $src"
}

deploy_dotfiles() {
	local repo_dir="$1"

	say "Copiando configuraciones a ~/.config ..."
	mkdir -p "$HOME/.config"

	for item in "${CFG_ITEMS[@]}"; do
		if [[ -d "$repo_dir/config/$item" ]]; then
			rm -rf "$HOME/.config/$item"
			cp -a "$repo_dir/config/$item" "$HOME/.config/$item"
			say "Aplicado: config/$item"
		else
			warn "No existe en el repo: config/$item"
		fi
	done

	if [[ -f "$repo_dir/.zshrc" ]]; then
		if [[ -f "$HOME/.zshrc" ]]; then
			cp -a "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%Y%m%d%H%M%S)"
		fi
		cp -a "$repo_dir/.zshrc" "$HOME/.zshrc"
		say "Aplicado: .zshrc"
	else
		warn "No existe .zshrc en el repo"
	fi

	if [[ -d "$repo_dir/wallpapers" ]]; then
		mkdir -p "$HOME/wallpapers"
		cp -a "$repo_dir/wallpapers/." "$HOME/wallpapers/"
		say "Copiado: wallpapers"
	fi

	if [[ -f "$HOME/.config/bin/up.sh" ]]; then
		chmod +x "$HOME/.config/bin/up.sh"
		say "Permisos aplicados: ~/.config/bin/up.sh"
	fi
}

export_current_dotfiles() {
	say "Exportando dotfiles locales con estructura jerarquica..."
	rm -rf "$EXPORT_DIR"
	mkdir -p "$EXPORT_DIR/config"

	for item in "${CFG_ITEMS[@]}"; do
		if [[ -d "$HOME/.config/$item" ]]; then
			cp -a "$HOME/.config/$item" "$EXPORT_DIR/config/$item"
			say "Exportado: ~/.config/$item"
		else
			warn "No existe en tu sistema: ~/.config/$item"
		fi
	done

	if [[ -f "$HOME/.zshrc" ]]; then
		cp -a "$HOME/.zshrc" "$EXPORT_DIR/.zshrc"
		say "Exportado: ~/.zshrc"
	fi

	say "Dotfiles exportados en: $EXPORT_DIR"
}

sync_repo_from_current() {
	say "Sincronizando cambios de ~/.config al repo local..."
	mkdir -p "$SCRIPT_DIR/config"

	local item
	for item in "${CFG_ITEMS[@]}"; do
		if [[ -d "$HOME/.config/$item" ]]; then
			rm -rf "$SCRIPT_DIR/config/$item"
			cp -a "$HOME/.config/$item" "$SCRIPT_DIR/config/$item"
			say "Sincronizado: config/$item"
		else
			warn "No existe en tu sistema: ~/.config/$item"
		fi
	done

	if [[ -f "$HOME/.zshrc" ]]; then
		cp -a "$HOME/.zshrc" "$SCRIPT_DIR/.zshrc"
		say "Sincronizado: .zshrc"
	fi

	if [[ -f "$SCRIPT_DIR/config/bin/up.sh" ]]; then
		chmod +x "$SCRIPT_DIR/config/bin/up.sh"
		say "Permisos aplicados: config/bin/up.sh"
	fi

	say "Repo actualizado con tus ultimos cambios."
}

run_install_flow() {
	local clone_target
	read -r -p "Ruta destino para clonar dotfiles [$DEFAULT_CLONE_DIR]: " clone_target || true
	clone_target="${clone_target:-$DEFAULT_CLONE_DIR}"

	require_sudo
	install_core_packages
	install_blackarch_repo
	install_yay
	install_paru
	install_aur_packages
	install_config_dependencies
	verify_config_commands
	install_oh_my_zsh
	clone_repo "$clone_target"
	deploy_dotfiles "$clone_target"

	say "Instalacion completada."
	say "Recomendado: reiniciar sesion para aplicar zsh y servicios."
}

show_menu() {
	cat <<'EOF'

=== Hyprland Dotfiles AutoInstall ===
1) Instalar todo en un Arch nuevo
2) Exportar tus dotfiles actuales a carpeta jerarquica
3) Instalar y luego exportar
4) Sincronizar cambios actuales al repo
5) Salir
EOF
}

main() {
	say "Instalador interactivo para Hyprland dotfiles"
	show_menu

	local choice
	read -r -p "Elige una opcion [1-5]: " choice

	case "$choice" in
	1)
		run_install_flow
		;;
	2)
		export_current_dotfiles
		;;
	3)
		run_install_flow
		export_current_dotfiles
		;;
	4)
		sync_repo_from_current
		;;
	5)
		say "Saliendo sin cambios."
		;;
	*)
		warn "Opcion invalida."
		exit 1
		;;
	esac
}

main "$@"
