#!/usr/bin/env bash

# Superuser authentication
echo "Initial authentication required!"
sudo echo "Thank you!"
sudo apt update -y
sudo apt upgrade -y


# ZRAM Setup (sets ZRAM to use 8GB, a good value overrall)
# (PCs with )
sudo apt install zram-tools -y
sudo sed -i 's/#SIZE=256/SIZE=8192/g' /etc/default/zramswap
sudo sed -i 's/#ALGO=lz4/ALGO=lz4/g' /etc/default/zramswap
sudo systemctl restart zramswap


# Checks for updated kernel, if it isn't proceeds to install Zabbly's kernel
if [ "$(cat $0.kstat)" == "updated" ]; then
    echo "Great! Seems like you already have the updated kernel, $(uname -r), we can proceed!"
    sleep 5
    rm $0.kstat
    sed '$d' $HOME/.bashrc

else
    echo "Stay with me a sec, I'll update your kernel and then reboot and continue, be ready to login when we get back!"
    sleep 5
    sudo apt install lsb-release software-properties-common apt-transport-https ca-certificates curl -y

    sudo curl -fSsL https://pkgs.zabbly.com/key.asc | gpg --dearmor | sudo tee /usr/share/keyrings/linux-zabbly.gpg > /dev/null
    codename=$(lsb_release -sc 2>/dev/null) && echo deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/linux-zabbly.gpg] https://pkgs.zabbly.com/kernel/stable $codename main | sudo tee /etc/apt/sources.list.d/linux-zabbly.list

    sudo apt update -y
    sudo apt install linux-zabbly -y

    echo "updated">$0.kstat

    # Add this script to autostart
    echo "$0" >> $HOME/.bashrc

    clear
    echo "I'll reboot it now, be ready to login when I come back!"
    sleep 4
    sudo reboot
    exit 1
fi


# If an NVIDIA GPU is detected, sets up the NVIDIA Driver
if lspci | grep -i nvidia > /dev/null; then
    if nvidia-smi; then
        echo "You've got the NVIDIA drivers, alrighty!"
        sleep 4
    else
        echo "It appears you have an NVIDIA GPU. I'll be taking some extra steps for your convenience!"
        sleep 4

        sudo apt install software-properties-common -y
        sudo add-apt-repository contrib non-free-firmware
        sudo apt install dirmngr ca-certificates apt-transport-https dkms curl -y

        sudo curl -fSsL https://developer.download.nvidia.com/compute/cuda/repos/debian"$(lsb_release -sr 2>/dev/null)"/x86_64/3bf863cc.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/nvidia-drivers.gpg > /dev/null 2>&1

        echo "deb [signed-by=/usr/share/keyrings/nvidia-drivers.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian$(lsb_release -sr 2>/dev/null)/x86_64/ /" | sudo tee /etc/apt/sources.list.d/nvidia-drivers.list

        sudo apt update -y
        sudo apt install nvidia-driver nvidia-smi nvidia-settings -y

        sudo mkdir -p /usr/share/wayland-sessions
        sudo echo -e "[Desktop Entry]\nName=Sway (NVIDIA)\nExec=sway --unsupported-gpu\nType=Application" > /usr/share/wayland-sessions/swaynvidia.desktop
        chmod +x /usr/share/wayland-sessions/swaynvidia.desktop

else
    echo "It seems you don't have an NVIDIA GPU. Good for you!"
    sleep 5
fi


# Remove from autostart
rm /etc/xdg/autostart/debiansetup.desktop


# Policy Kit (required for some things, better keep)
sudo apt install policykit-1 policykit-1-gnome -y


# Login Manager installation (SDDM)
sudo apt install --no-install-recommends sddm -y
sudo systemctl enable sddm.service -f


# Good utils
sudo apt install dialog mtools dosfstools avahi-daemon acpi acpid gvfs-backends -y
sudo systemctl enable avahi-daemon
sudo systemctl enable acpid


# Fastfetch hehe
wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.11.0/fastfetch-linux-amd64.deb
sudo apt install ./fastfetch-linux-amd64.deb -y
sudo rm fastfetch-linux-amd64.deb
echo "alias neofetch='fastfetch -c neofetch'" >> $HOME/.bashrc


# Pulseaudio/Pipewire stuff (a lot of the pipewire stuff comes with gnome-tweaks)
sudo apt install pipewire wireplumber pulseaudio-utils pavucontrol pamixer gnome-tweaks -y


# Sway
mkdir -p $HOME/.config/sway
cp $(dirname $0)/sway/*  $HOME/.config/sway/*
sudo apt install sway swayidle swaylock xdg-desktop-portal-wlr wofi waybar dunst libnotify-bin libnotify-dev -y


# Add User directories
xdg-user-dirs-update

# Utils for average use (some are included in other sections)
sudo apt install wlr-randr brightnessctl qt5ct qt6ct mesa-utils pciutils unrar unzip blueman synaptic timeshift kcalc tlp tlp-rdw tldr -y
sudo systemctl enable tlp


# Aesthetic
sudo apt install fonts-recommended fonts-ubuntu fonts-font-awesome fonts-terminus papirus-icon-theme -y


# Flatpak setup + GNOME-Software as the store with Flatpak integration
sudo apt install flatpak gnome-software gnome-software-plugin-flatpak xdg-desktop-portal qt5-flatpak-platformtheme -y
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


#Flatpak utils
flatpak install com.github.tchx84.Flatseal -y
flatpak install io.github.flattool.Warehouse -y


# Distrobox + BoxBuddy
#sudo apt install podman distrobox -y
#flatpak install io.github.dvlv.boxbuddyrs -y


# Ptyxis as the container-focused terminal + arch image setup
#flatpak install --user --from https://nightly.gnome.org/repo/appstream/org.gnome.Ptyxis.Devel.flatpakref -y
#distrobox-create archlinux --image docker.io/library/archlinux:latest


# Install standard utilities for daily use
#sudo apt install vlc -y
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


# Set zoxide as the change directory command
#curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
#echo "alias cd='z'" >> $HOME/.bashrc
#echo "alias cdi='z'" >> $HOME/.bashrc
#echo "" >> $HOME/.bashrc
#echo 'eval "$(zoxide init bash)"' >> $HOME/.bashrc


# Set GTK Dark Theme
mkdir -p $HOME/.config/gtk-3.0
mkdir -p $HOME/.config/gtk-4.0
echo "gtk-application-prefer-dark-theme=true" > $HOME/.config/gtk-3.0/settings.ini
echo "gtk-application-prefer-dark-theme=true" > $HOME/.config/gtk-4.0/settings.ini


# Set a few environment variables
"export MOZ_ENABLE_WAYLAND=1" >> $HOME/.profile
"export QT_QPA_PLATFORM=wayland" >> $HOME/.profile
"export QT_QPA_PLATFORMTHEME=qt5ct" >> $HOME/.profile

sudo apt install connman connman-gtk wpagui wpasupplicant

# Final step
read -p "We're done! Ready to reboot to your new system? (Y/n): " yn
choice=$(echo "$yn" | tr '[:upper:]' '[:lower:]')

if [ "$choice" == "y" ] || [ "$choice" == "yes" ] || [ "$choice" == "" ]; then
    echo "Alright, let's go then!"
    sleep 3
    sudo reboot
else
    echo "No? Gotcha, I'll hand it back to you, do your thing."
    source $HOME/.bashrc
fi
