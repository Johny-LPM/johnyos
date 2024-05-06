#!/usr/bin/env bash

script="debianscript.sh"

# Change into the directory where the script is, to make sure everything is consistent
cd $(dirname $0)


# Initial authentication
echo "Superuser authentication check..."
sudo "Authenticated. Proceeding."
sleep 3
sudo apt update -y
sudo apt upgrade -y
sudo apt install figlet -y


# ZRAM Setup (sets ZRAM to use 8GB, a good value overrall)
# (PCs with )
sudo apt install zram-tools -y
sudo sed -i 's/#SIZE=256/SIZE=8192/g' /etc/default/zramswap
sudo sed -i 's/#ALGO=lz4/ALGO=lz4/g' /etc/default/zramswap
sudo systemctl restart zramswap


# Checks for updated kernel, if it isn't proceeds to install Zabbly's kernel
if [ "$(cat kstat)" == "updated" ]; then
    clear
    figlet "You have the updated kernel, $(uname -r), we can proceed!"
    sleep 5
    rm kstat
    sed '$d' $HOME/.bashrc
else
    figlet "I'll update your kernel now, be ready to login!"
    sleep 5
    sudo apt install lsb-release software-properties-common apt-transport-https ca-certificates curl -y

    sudo curl -fSsL https://pkgs.zabbly.com/key.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/linux-zabbly.gpg > /dev/null
    codename=$(lsb_release -sc 2>/dev/null) && sudo echo deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/linux-zabbly.gpg] https://pkgs.zabbly.com/kernel/stable $codename main | sudo tee /etc/apt/sources.list.d/linux-zabbly.list

    sudo apt update -y
    sudo apt install linux-zabbly -y

    echo "updated">kstat

    # Add this script to autostart
    echo "$(pwd)/$script" >> $HOME/.bashrc

    clear
    figlet "Time to reboot, get ready!"
    sleep 4
    sudo reboot
    exit 1
fi


# Policy Kit (required for some things, better keep)
sudo apt install policykit-1 policykit-1-gnome -y


# Pulseaudio/Pipewire stuff (a lot of the pipewire stuff comes with gnome-tweaks)
sudo apt install pipewire wireplumber pulseaudio-utils pavucontrol pamixer gnome-tweaks -y
# For some reason gnome-tweaks doesn't create a desktop file on its own, so we do it manually
sudo echo -e "[Desktop Entry]\nName=GNOME-Tweaks\nExec=gnome-tweaks\nType=Application\nTerminal=false\nIcon=tweaks-app" > /usr/share/applications/gnometweaks.desktop
chmod +x /usr/share/applications/gnometweaks.desktop


# Login Manager installation (SDDM)
sudo apt install --no-install-recommends sddm -y
sudo systemctl enable sddm.service


# Sway
sudo apt install sway swayidle swaylock xdg-desktop-portal-wlr wofi waybar dunst libnotify-bin libnotify-dev -y
rm $HOME/.config/sway/config
cp -r ./sway/* $HOME/.config/sway/


# Add User directories
xdg-user-dirs-update


# Good utils
sudo apt install dialog mtools dosfstools avahi-daemon acpi acpid gvfs-backends -y
sudo systemctl enable avahi-daemon
sudo systemctl enable acpid


# Utils for average use (some are included in other sections)
sudo apt install wlr-randr brightnessctl qt5ct qt6ct mesa-utils pciutils unrar unzip blueman synaptic timeshift kcalc tlp tlp-rdw tldr -y
sudo systemctl enable tlp


# Aesthetic
sudo apt install fonts-recommended fonts-ubuntu fonts-font-awesome fonts-terminus papirus-icon-theme -y
sudo wget https://github.com/lassekongo83/adw-gtk3/releases/download/v5.3/adw-gtk3v5.3.tar.xz
sudo tar xvf adw-gtk3v5.3.tar.xz
sudo rm adw-gtk3v5.3.tar.xz
sudo cp -r adw-gtk3-dark /usr/share/themes
gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'


# Fastfetch hehe
sudo wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.11.0/fastfetch-linux-amd64.deb
sudo apt install ./fastfetch-linux-amd64.deb -y
sudo rm fastfetch-linux-amd64.deb
echo "alias neofetch='fastfetch -c neofetch'" >> $HOME/.bashrc


# Flatpak setup + GNOME-Software as the store with Flatpak integration
sudo apt install flatpak gnome-software gnome-software-plugin-flatpak xdg-desktop-portal qt5-flatpak-platformtheme -y
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


# Flatpak utils
flatpak install com.github.tchx84.Flatseal -y
flatpak install io.github.flattool.Warehouse -y


# Install standard utilities for daily use
#sudo apt install vlc -y
sudo apt install celluloid -y
sudo apt install micro -y
#sudo apt install thunar fileroller -y
#flatpak install com.google.Chrome -y
flatpak install org.onlyoffice.desktopeditors -y
flatpak install com.github.d4nj1.tlpui -y


# Optional (my personal configuration)
sudo apt install mpv micro -y
sudo apt install dolphin ark -y
flatpak install com.brave.Browser -y
flatpak install com.valvesoftware.Steam -y
flatpak install net.lutris.Lutris -y
flatpak install com.heroicgameslauncher.hgl -y
flatpak install page.kramo.Cartridges -y


# Set a few environment variables
"export MOZ_ENABLE_WAYLAND=1" >> $HOME/.profile
"export QT_QPA_PLATFORM=wayland" >> $HOME/.profile
"export QT_QPA_PLATFORMTHEME=qt5ct" >> $HOME/.profile


# Final step
read -p "We're done! Ready to reboot to your new system? (Y/n): " yn
choice=$(echo "$yn" | tr '[:upper:]' '[:lower:]')

if [ "$choice" == "y" ] || [ "$choice" == "yes" ] || [ "$choice" == "" ]; then
    figlet "Alright, let's go then!"
    sleep 3
    sudo reboot
else
    figlet "No? Gotcha, I'll hand it back to you, do your thing."
    source $HOME/.bashrc
fi
