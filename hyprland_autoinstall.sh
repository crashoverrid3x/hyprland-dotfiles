#!/bin/bash

echo -e "\nClonando los repositorios de los dotfiles: \n\n"

git clone https://github.com/v3ctorsh4de/hyprland-dotfiles.git

echo -e "\n\nInstalamos herramientas necesarias\n\n"

sudo pacman -S paru yay hyprland waybar kitty git curl wget zsh hyprpaper rofi python3 golang cmake make ruby perl

rofi-theme-selector

echo -e "\n\n\nAhora vamos a agregar la configuracion a los archivos correspondientes\n\n"

cp -r hyprland-dotfiles/config/hypr /home/$(whoami)/.config/
cp -r hyprland-dotfiles/config/waybar /home/$(whoami)/.config/
cp -r hyprland-dotfiles/config/waypaper /home/$(whoami)/.config/
cp -r hyprland-dotfiles/config/kitty /home/$(whoami)/.config/
cp -r hyprland-dotfiles/config/nvim /home/$(whoami)/.config/
cp -r hyprland-dotfiles/config/rofi /home/$(whoami)/.config/
cp -r hyprland-dotfiles/wallpapers /home/$(whoami)/

echo -e "\n\n Hora de configurar zsh y agregar la configuracion:\n\n"

cp hyprland-dotfiles/.zshrc .

echo -e "Configurando el fondo de pantalla: "
paru -S waypaper

echo -e "\n\nRecuerda editar la configuracion que hay en /home/usuario/.config/hypr/hyprland.conf para cambiar las resoluciones y el escalado de su pantalla para una mejor experiencia.\n"
