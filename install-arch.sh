#!/bin/bash
set -e

error() {
  printf '\E[31m'; echo "$@"; printf '\E[0m'
}

if [[ $EUID -eq 0 ]]; then
    error "This script cannot be ran as root."
    exit 1
fi

PACKAGES=("git" "alacritty" "bspwm" "sddm" "xorg" "xorg-xinit"
    "micro" "sxhkd" "zsh" "firefox" "stow" "base-devel"
    "networkmanager" "bluez" "bluez-utils" "alsa-utils" "pipewire"
    "pipewire-pulse" "ttf-font-awesome" "bat" "bpytop" "telegram-desktop"
    "discord" "fasd" "xclip" "flameshot" "gnome-keyring" "jq"
    "feh" "neofetch" "npm" "nodejs" "ttf-roboto" "ttf-liberation" "unzip" "zip")
# Install packages using pacman
for PACKAGE in "${PACKAGES[@]}"; do
    printf "\nInstalling $PACKAGE...\n"
    sudo pacman -S --noconfirm --needed $PACKAGE
done

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

yay -S --noconfirm ulauncher cava ttf-iosevka ttf-meslo visual-studio-code-bin polybar picom-ibhagwan-git

chsh -s /bin/zsh

git clone --recursive https://github.com/changs/slimzsh.git ~/.slimzsh

source .zshrc

stow --adopt -vt ~ */

sudo systemctl enable bluetooth
sudo systemctl enable sddm
sudo systemctl enable NetworkManager

reboot
