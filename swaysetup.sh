#!/usr/bin/env bash
cd $(dirname $0)
./debiansetup.sh "swaysetup.sh"



# For some reason gnome-tweaks doesn't create a desktop file on its own outside GNOME, so we do it manually
mkdir -p $HOME/.local/share/applications
sudo echo -e "[Desktop Entry]\nName=GNOME-Tweaks\nExec=gnome-tweaks\nType=Application\nTerminal=false\nIcon=tweaks-app" > $HOME/.local/share/applications/gnometweaks.desktop
chmod +x $HOME/.local/share/applications/gnometweaks.desktop


# Policy Kit (required for some things, better keep)
sudo apt install policykit-1 mate-polkit -y


# Login Manager installation (GDM3, because it has better integration with Sway)
sudo apt install --no-install-recommends gdm3 -y


# Sway
sudo apt install sway swayidle swaylock xdg-desktop-portal-wlr wofi waybar dunst grim slurp libnotify-bin libnotify-dev wlr-randr blueman gnome-software gnome-software-plugin-flatpak thunar file-roller -y
rm $HOME/.config/sway/config
mkdir -p $HOME/.config/sway
cp -r ./sway/* $HOME/.config/sway/
sudo apt remove foot -y
sudo apt install terminator -y


# Networking
sudo apt install wpasupplicant wpagui -y


## Sway just doesn't seem to work with NVIDIA, regardless of driver version and kernel, on Debian 12.
## Therefore, the NVIDIA check and installation script is skipped here. Nouveau is the only option.


# Final step
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
