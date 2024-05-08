#!/usr/bin/env bash
cd $(dirname $0)
./debiansetup.sh "gnomesetup.sh"


# Install minimal GNOME
sudo apt install gnome-core chromium gnome-shell-extension-manager gnome-shell-extension-dashtodock gnome-shell-extension-desktop-icons-ng gnome-shell-extension-bluetooth-quick-connect gnome-shell-extension-appindicator gnome-shell-extension-gsconnect gnome-shell-extension-gsconnect-browsers gnome-shell-extension-hide-activities gnome-shell-extension-caffeine gnome-shell-extension-no-annoyance gnome-shell-extension-panel-osd gnome-shell-extension-tiling-assistant curl wget jq gnome-extensions dconf-editor gnome-software gnome-software-plugin-flatpak -y


# Use ToasterUwU's tool to install a few more extensions not in the repos
sudo wget -N -q "https://raw.githubusercontent.com/ToasterUwU/install-gnome-extensions/master/install-gnome-extensions.sh" -O ./install-gnome-extensions.sh && chmod +x install-gnome-extensions.sh
./install-gnome-extensions.sh --enable --file extensions.txt


# NVIDIA Check and Setup
./nvidiasetup.sh


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
