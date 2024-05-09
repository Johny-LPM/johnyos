#!/usr/bin/env bash
cd $(dirname $0)
./debiansetup.sh "gnomesetup.sh"


# Install minimal GNOME
sudo apt install gnome-core chromium gnome-shell-extension-manager gnome-shell-extension-dashtodock gnome-shell-extension-desktop-icons-ng gnome-shell-extension-bluetooth-quick-connect gnome-shell-extension-appindicator gnome-shell-extension-gsconnect gnome-shell-extension-gsconnect-browsers gnome-shell-extension-caffeine gnome-shell-extension-no-annoyance gnome-shell-extension-panel-osd gnome-shell-extension-tiling-assistant curl wget jq dconf-editor gnome-software gnome-software-plugin-flatpak -y


# Use ToasterUwU's tool to install a few more extensions not in the repos
sudo wget -N -q "https://raw.githubusercontent.com/ToasterUwU/install-gnome-extensions/master/install-gnome-extensions.sh" -O ./install-gnome-extensions.sh && chmod +x install-gnome-extensions.sh
./install-gnome-extensions.sh --enable --file extensions.txt
gnome-extensions enable dash-to-dock@$HOSTNAME
gnome-extensions enable removable-drive-menu@$HOSTNAME
gnome-extensions enable gtile@$HOSTNAME
gnome-extensions enable blur-my-shell@$HOSTNAME
gnome-extensions enable desktop-icons-ng-ding@$HOSTNAME
gnome-extensions enable gsconnect@$HOSTNAME
gnome-extensions enable noannoyance@$HOSTNAME
gnome-extensions enable bluetooth-quick-connect@$HOSTNAME
gnome-extensions enable appindicator-support@$HOSTNAME

# NVIDIA Check and Setup
./nvidiasetup.sh
sudo sed -i 's/DRIVER="nvidia",/#DRIVER="nvidia",/g' /usr/lib/udev/rules.d/61-gdm.rules

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
