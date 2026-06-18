#!/bin/bash
# dms-niri.sh - Automated system setup for Arch Linux

if [ "$EUID" -eq 0 ]; then
  echo "Please run as a normal user with sudo privileges, not root."
  exit 1
fi

echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing base, build tools, Intel performance stack, and apps..."
# Added haruna; removed zsh
sudo pacman -S --needed --noconfirm base-devel git curl wget fish starship \
  mesa vulkan-intel intel-media-driver libva-utils intel-ucode \
  thermald intel-undervolt \
  wl-clipboard haruna zed neovim \
  noto-fonts noto-fonts-cjk adw-gtk-theme nautilus loupe evince

# Enable performance daemons
sudo systemctl enable --now thermald

echo "Installing Paru (Source build)..."
if ! command -v paru &> /dev/null; then
  git clone https://aur.archlinux.org/paru.git /tmp/paru
  cd /tmp/paru || exit
  makepkg -si --noconfirm
  cd ~ || rm -rf /tmp/paru
fi

echo "Installing AUR packages..."
# Added stremio-service-bin
paru -S --needed --noconfirm capitaine-cursors keyd stremio-service-bin

echo "Configuring Fish shell..."
mkdir -p ~/.config/fish
cp fish-config.fish ~/.config/fish/config.fish
chsh -s /usr/bin/fish

echo "Configuring Starship..."
mkdir -p ~/.config
starship preset pastel-powerline -o ~/.config/starship.toml
echo "starship init fish | source" >> ~/.config/fish/config.fish

echo "Configuring Niri Binds & Layout..."
mkdir -p ~/.config/niri
# Assumes binds.kdl is in current dir
cp binds.kdl ~/.config/niri/dms

echo "Configuring Keyd..."
sudo mkdir -p /etc/keyd
sudo tee /etc/keyd/default.conf > /dev/null << 'EOF'
[ids]
*

[main]
leftshift = 102nd
102nd = leftshift
EOF
sudo systemctl enable --now keyd

echo "Configuring GTK settings..."
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk-theme"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

echo "Setting default file openers..."
# M3U -> Haruna
xdg-mime default haruna.desktop audio/x-mpegurl
xdg-mime default haruna.desktop application/vnd.apple.mpegurl

# Images -> Loupe
xdg-mime default org.gnome.Loupe.desktop image/jpeg image/png image/webp

# PDF -> Evince
xdg-mime default org.gnome.Evince.desktop application/pdf

# Videos -> Showtime (or Haruna if preferred)
xdg-mime default org.gnome.Showtime.desktop video/mp4 video/x-matroska

echo "System setup complete! Please log out and back in for shell changes to take effect."
