#!/usr/bin/env bash

script="$1"

# Change into the directory where the script is, to make sure everything is consistent
cd $(dirname $0)


# Initial authentication
clear
echo "Superuser authentication check..."
sudo echo "Authenticated. Proceeding."
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
    figlet -tc "YOU HAVE UPDATED THE SYSTEM, NOW WITH KERNEL $(uname -r), WE CAN PROCEED!"
    sleep 5
    rm kstat
    sed -i '$d' $HOME/.bashrc

else
    clear
    figlet -tc "I'LL UPDATE YOUR SYSTEM NOW, AFTERWARDS A REBOOT WILL BE NEEDED!"
    sleep 5
    #sudo sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
    #sudo apt update -y
    #sudo apt upgrade -y
    sudo apt install lsb-release software-properties-common apt-transport-https ca-certificates curl -y
    sudo add-apt-repository contrib non-free-firmware non-free -y

    sudo curl -fSsL https://pkgs.zabbly.com/key.asc | gpg --dearmor | sudo tee /usr/share/keyrings/linux-zabbly.gpg > /dev/null
    codename=$(lsb_release -sc 2>/dev/null) && echo deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/linux-zabbly.gpg] https://pkgs.zabbly.com/kernel/stable $codename main | sudo tee /etc/apt/sources.list.d/linux-zabbly.list

    sudo apt update -y
    sudo apt install linux-zabbly -y

    echo "updated">kstat

    # Add the script that launched this one to autostart
    echo "$script" >> $HOME/.bashrc

    figlet -tc "I WILL NOW ALSO INSTALL NIXPKGS SUPPORT"
    curl -L https://nixos.org/nix/install | sh

    clear
    figlet -tc "TIME TO REBOOT, WHENEVER YOU'RE READY JUST PRESS ENTER!"
    read nothing
    sudo reboot
    exit 1
fi


# Pulseaudio/Pipewire stuff (a lot of the pipewire stuff comes with gnome-tweaks)
sudo apt install pipewire wireplumber pulseaudio-utils pavucontrol pamixer gnome-tweaks -y


# Add User directories
xdg-user-dirs-update


# Good utils
sudo apt install dialog mtools dosfstools avahi-daemon acpi acpid gvfs-backends -y
sudo systemctl enable avahi-daemon
sudo systemctl enable acpid


# Utils for average use (some are included in other sections)
sudo apt install brightnessctl qt5ct qt6ct mesa-utils pciutils unrar unzip synaptic timeshift tlp tlp-rdw tldr -y
sudo systemctl enable tlp


# Aesthetic (set Papirus and Adw-Gtk3 for the GTK theme to look like GTK4)
sudo apt install fonts-recommended fonts-ubuntu fonts-font-awesome fonts-terminus papirus-icon-theme -y
sudo wget https://github.com/lassekongo83/adw-gtk3/releases/download/v5.3/adw-gtk3v5.3.tar.xz
sudo tar xvf adw-gtk3v5.3.tar.xz
sudo rm adw-gtk3v5.3.tar.xz
sudo mkdir -p $HOME/.themes
sudo cp -r adw-gtk* $HOME/.themes
sudo rm -r adw-gtk*


# Fastfetch hehe
sudo wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.11.5/fastfetch-linux-amd64.deb
sudo apt install ./fastfetch-linux-amd64.deb -y
sudo rm fastfetch-linux-amd64.deb
echo "alias neofetch='fastfetch -c neofetch'" >> $HOME/.bashrc


# Flatpak setup
sudo apt install flatpak xdg-desktop-portal qt5-flatpak-platformtheme -y
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
mkdir -p $HOME/.config/autostart
echo -e "[Desktop Entry]\nName=FlatpaksInstall\nExec=$(pwd)/flatpaksinstall.sh\nType=Application\nTerminal=true" > $HOME/.config/autostart/flatpaksinstall.desktop
chmod +x $HOME/.config/autostart/flatpaksinstall.desktop


# Aesthetic for Flatpaks
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=/usr/share/icons
sudo flatpak override --env=GTK_THEME=adw-gtk3-dark
sudo flatpak override --env=ICON_THEME=Papirus-Dark


# Install standard utilities for daily use
# Floorp as the default browser
sudo curl -fsSL https://ppa.ablaze.one/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
sudo curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.ablaze.one/Floorp.list'
sudo apt update -y
sudo apt install floorp -y

sudo apt install celluloid -y
sudo apt install micro -y

sudo apt remove zutty -y
sudo apt autoremove -y


# Set a few environment variables
echo "export MOZ_ENABLE_WAYLAND=1" >> $HOME/.profile
