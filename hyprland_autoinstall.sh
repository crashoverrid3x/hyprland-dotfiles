#!/bin/bash

echo -e "\nClonando los repositorios de los dotfiles: \n\n"

git clone https://github.com/v3ctorsh4de/hyprland-dotfiles.git

echo -e "\n\nInstalamos herramientas necesarias\n\n"

sudo pacman -S paru yay hyprland waybar kitty git curl wget zsh

echo -e "\n\n\nAhora vamos a agregar la configuracion a los archivos correspondientes\n\n"

cp -r hyprland-dotfiles/config/ /home/$(whoami)/
cp -r hyprland-dotfiles/wallpapers

echo -e "\n\n Hora de configurar zsh y agregar la configuracion:\n\n"

cp hyprland-dotfiles/.zshrc .

echo -e "\n\nRecuerda editar la configuracion que hay en /home/usuario/.config/hypr/hyprland.conf para cambiar las resoluciones y el escalado de su pantalla para una mejor experiencia.\n"
