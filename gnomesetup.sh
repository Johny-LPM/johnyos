#!/usr/bin/env bash
cd $(dirname $0)
./debiansetup.sh "gnomesetup.sh"


# Install minimal GNOME
sudo apt install gnome-core alacarte firefox-esr gnome-shell-extension-manager gnome-shell-extension-dashtodock gnome-shell-extension-desktop-icons-ng gnome-shell-extension-bluetooth-quick-connect gnome-shell-extension-appindicator gnome-shell-extension-gsconnect gnome-shell-extension-gsconnect-browsers gnome-shell-extension-caffeine gnome-shell-extension-no-annoyance gnome-shell-extension-panel-osd gnome-shell-extension-tiling-assistant curl wget jq dconf-editor gnome-software gnome-software-plugin-flatpak -y
sudo apt remove firefox-esr


# Use ToasterUwU's tool to install a few more extensions not in the repos
sudo wget -N -q "https://raw.githubusercontent.com/ToasterUwU/install-gnome-extensions/master/install-gnome-extensions.sh" -O ./install-gnome-extensions.sh && chmod +x install-gnome-extensions.sh
./install-gnome-extensions.sh --enable --file extensions.txt
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gnome-extensions enable drive-menu@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable tiling-assistant@leleat-on-github
gnome-extensions enable launch-new-instance@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable ding@rastersoft.com
gnome-extensions enable gsconnect@andyholmes.github.io
gnome-extensions enable noannoyance@daase.net
gnome-extensions enable bluetooth-quick-connect@bjarosze.gmail.com
gnome-extensions enable ubuntu-appindicators@ubuntu.com
gnome-extensions enable workspace-indicator@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable window-app-switcher-on-active-monitor@NiKnights.com
gnome-extensions enable blur-my-shell@aunetx
gnome-extensions enable unblank@sun.wxg@gmail.com

gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.shell.app-switcher current-workspace-only true
gsettings set org.gnome.shell.window-switcher current-workspace-only true
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.shell favorite-apps "['floorp.desktop', 'org.gnome.Software.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.tweaks.desktop', 'org.gnome.Settings.desktop', 'org.gnome.Terminal.desktop']"
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'

# NVIDIA Check and Setup
./nvidiasetup.sh
sudo mv /usr/lib/udev/rules.d/61-gdm.rules /usr/lib/udev/rules.d/61-gdm.rules.bak
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
