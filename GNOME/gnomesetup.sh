#!/usr/bin/env bash
cd $(dirname $0)
../UtilityScripts/debiansetup.sh "$(pwd)/gnomesetup.sh"
cd $(dirname $0)
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'


# Install minimal GNOME
sudo apt install gnome-core alacarte gnome-shell-extension-manager gnome-shell-extension-dashtodock gnome-shell-extension-desktop-icons-ng gnome-shell-extension-bluetooth-quick-connect gnome-shell-extension-appindicator gnome-shell-extension-gsconnect gnome-shell-extension-gsconnect-browsers gnome-shell-extension-caffeine gnome-shell-extension-no-annoyance gnome-shell-extension-panel-osd gnome-shell-extension-tiling-assistant curl wget jq dconf-editor gnome-software gnome-software-plugin-flatpak -y
sudo apt remove firefox-esr -y


# We have to reinstall TLP because GNOME prefers Power-Profiles-Daemon and deletes TLP
sudo apt install tlp tlp-rdw -y


# Use the extensions from the preselected gnome-extensions folder
gnome-extensions install gnome-extensions/blur-my-shell.zip
gnome-extensions install gnome-extensions/compiz.zip
gnome-extensions install gnome-extensions/custom-hot-corners.zip
gnome-extensions install gnome-extensions/drive-menu.zip
gnome-extensions install gnome-extensions/fix-tearing.zip
gnome-extensions install gnome-extensions/forge.zip
gnome-extensions install gnome-extensions/just-perfection.zip
gnome-extensions install gnome-extensions/unblank.zip
gnome-extensions install gnome-extensions/window-switcher.zip


# Enable the extensions considered more useful for a new user OOTB
echo -e "[Desktop Entry]\nName=ExtensionsEnable\nExec=$(pwd)/extensionsenable.sh\nType=Application\nTerminal=false" > $HOME/.config/autostart/extensionsenable.desktop
sudo chmod +x $HOME/.config/autostart/extensionsenable.desktop


# Enable a bunch of settings that make it a better OOTB experience
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.shell.app-switcher current-workspace-only true
gsettings set org.gnome.shell.window-switcher current-workspace-only true
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.shell favorite-apps "['floorp.desktop', 'org.gnome.Software.desktop', 'org.gnome.Nautilus.desktop', 'com.mattjakeman.ExtensionManager.desktop', 'org.gnome.tweaks.desktop', 'org.gnome.Settings.desktop']"
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'


# NVIDIA Check and Setup
../UtilityScripts/nvidiasetup.sh
# GDM Fix for allowing Wayland sessions on some NVIDIA devices
sudo mv /usr/lib/udev/rules.d/61-gdm.rules /usr/lib/udev/rules.d/61-gdm.rules.bak
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
