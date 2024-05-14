#!/usr/bin/env bash
cd $(dirname $0)
./debiansetup.sh "swaysetup.sh"
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


# Login Manager installation (lightdm)
sudo apt install lightdm lightdm-gtk-greeter -y
sudo systemctl enable lightdm.service


# Sway
sudo apt install i3-wm terminator feh i3lock i3status scrot dmenu rofi dunst libnotify-bin libnotify-dev arandr blueman gnome-software gnome-software-plugin-flatpak thunar file-roller -y
rm $HOME/.config/i3/config
mkdir -p $HOME/.config/i3
cp -r ./configs/* $HOME/.config/i3/


# Networking
sudo apt install wpasupplicant wpagui -y


# NVIDIA Check and Setup
./nvidiasetup.sh
sudo update-grub2


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
