#!/usr/bin/env bash
cd $(dirname $0)
../UtilityScripts/debiansetup.sh "$(pwd)/kdesetup.sh"
cd $(dirname $0)


# Install minimal KDE
sudo apt install kde-plasma-desktop plasma-discover-backend-flatpak plasma-nm -y
sudo apt remove gnome-tweaks -y


# NVIDIA Check and Setup
../UtilityScripts/nvidiasetup.sh
sudo update-grub2


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
