#!/usr/bin/env bash
cd $(dirname $0)
../UtilityScripts/debiansetup.sh "$(pwd)/swaysetup.sh"
cd $(dirname $0)
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'


# For some reason gnome-tweaks doesn't create a desktop file on its own outside GNOME, so we do it manually
mkdir -p $HOME/.local/share/applications
sudo echo -e "[Desktop Entry]\nName=GNOME-Tweaks\nExec=gnome-tweaks\nType=Application\nTerminal=false\nIcon=tweaks-app" > $HOME/.local/share/applications/gnometweaks.desktop
chmod +x $HOME/.local/share/applications/gnometweaks.desktop


# Policy Kit (required for some things, better keep)
sudo apt install policykit-1 mate-polkit -y


# Login Manager installation (GDM3, because it has better integration with Sway)
sudo apt install --no-install-recommends gdm3 -y


# Sway
nix-env -iA nixpkgs.sway
nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl && nix-channel --update
nix-env -iA nixgl.auto.nixGLDefault


# Sway addons
sudo apt install swayidle swaylock xdg-desktop-portal-wlr wofi waybar dunst grim slurp libnotify-bin libnotify-dev terminator wlr-randr blueman gnome-software gnome-software-plugin-flatpak adwaita-qt thunar file-roller -y
rm $HOME/.config/sway/config
mkdir -p $HOME/.config/sway
cp -r ./configs/* $HOME/.config/sway/


# NVIDIA Check and Setup
../UtilityScripts/nvidiasetup.sh
sudo update-grub2


# Networking
sudo apt install network-manager nm-tray -y


## Sway just doesn't seem to work with NVIDIA, regardless of driver version and kernel, on Debian 12.
## Flickering on external monitors always occurs.
## Therefore, the NVIDIA check and installation script is skipped here. Nouveau is the only option.
## For any single monitor setups, NVIDIA drivers can be installed manually later.


echo "export QT_QPA_PLATFORM=wayland" >> $HOME/.profile
echo "export QT_QPA_PLATFORMTHEME=qt5ct" >> $HOME/.profile


# Final step
sudo apt autoremove -y
clear
figlet -tc "WE'RE DONE! READY TO REBOOT TO YOU NEW SYSTEM?"
read -p "(Y/n): " yn
choice=$(echo "$yn" | tr '[:upper:]' '[:lower:]')

if [ "$choice" == "y" ] || [ "$choice" == "yes" ] || [ "$choice" == "" ]; then
    clear
    figlet -tc "ALRIGHT, LET'S GO THEN!"
    sleep 3
    sudo reboot
else
    clear
    figlet -tc "NO? GOTCHA, I'LL HAND IT BACK TO YOU, DO YOUR THING."
    source $HOME/.bashrc
fi
