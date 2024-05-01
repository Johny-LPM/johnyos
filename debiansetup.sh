#!/usr/bin/env bash

# Superuser authentication
echo "Initial authentication required!"
sudo echo "Thank you!"


# Initial update
sudo apt update -y
sudo apt upgrade -y


# ZRAM Setup (sets ZRAM to use 8GB, a good value overrall)
# (PCs with )
sudo apt install zram-tools -y
sudo sed -i 's/#SIZE=256/SIZE=8192/g' /etc/default/zramswap
sudo set -i 's/#ALGO=lz4/ALGO=lz4/g' /etc/default/zramswap
sudo systemctl restart zramswap


# Policy Kit (required for some things, better keep)
sudo apt install policykit-1-gnome -y


# Login Manager installation (SDDM)
sudo apt install --no-install-recommends sddm -y


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
cp -r ./sway/ $HOME/.config/
sudo apt install sway swayidle swaylock xdg-desktop-portal-wlr wofi waybar dunst libnotify-dev -y


# Utils for average use (some are included in other sections)
sudo apt install wlr-randr brightnessctl qt5ct qt6ct mesa-utils pciutils unrar unzip blueman synaptic timeshift kcalc connman-gtk -y


# Aesthetic
sudo apt install fonts-recommended fonts-ubuntu fonts-font-awesome fonts-terminus papirus-icon-theme -y


# Flatpak setup + GNOME-Software as the store with Flatpak integration
sudo apt install flatpak gnome-software-plugin-flatpak xdg-desktop-portal qt5-flatpak-platformtheme libportal-* -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


#Flatpak utils
flatpak install com.github.tchx84.Flatseal -y
flatpak install io.github.flattool.Warehouse -y


# Distrobox + BoxBuddy
sudo apt install podman distrobox -y
flatpak install io.github.dvlv.boxbuddyrs -y


# Ptyxis as the container-focused terminal + arch image setup
flatpak install --user --from https://nightly.gnome.org/repo/appstream/org.gnome.Ptyxis.Devel.flatpakref -y
distrobox-create archlinux --image docker.io/library/archlinux:latest


# Install standard utilities for daily use
#sudo apt install vlc -y
#sudo apt install thunar fileroller -y
#flatpak install com.google.Chrome -y
flatpak install org.onlyoffice.desktopeditors -y


# Optional (my personal configuration)
sudo apt install mpv micro -y
sudo apt install dolphin ark -y
flatpak install one.ablaze.floorp -y
flatpak install com.valvesoftware.Steam -y
flatpak install net.lutris.Lutris -y
flatpak install com.heroicgameslauncher.hgl -y
flatpak install page.kramo.Cartridges -y


# Set zoxide as the change directory command
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
echo "alias cd='z'" >> $HOME/.bashrc
echo "alias cdi='z'" >> $HOME/.bashrc
echo "" >> $HOME/.bashrc
echo 'eval "$(zoxide init bash)"' >> $HOME/.bashrc


# If an NVIDIA GPU is detected, sets up the NVIDIA Driver
if lspci | grep -i nvidia > /dev/null; then

    echo "It appears you have an NVIDIA GPU. I'll be taking some extra steps for your convenience! If you know what you're doing, you can cancel this step with Ctrl+C and reboot on your own, there's nothing else left to do."

    sudo apt install software-properties-common -y
    sudo add-apt-repository contrib non-free-firmware
    sudo apt install dirmngr ca-certificates apt-transport-https dkms curl -y

    curl -fSsL https://developer.download.nvidia.com/compute/cuda/repos/debian"$(lsb_release -sr 2>/dev/null)"/x86_64/3bf863cc.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/nvidia-drivers.gpg > /dev/null 2>&1

    echo "deb [signed-by=/usr/share/keyrings/nvidia-drivers.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian$(lsb_release -sr 2>/dev/null)/x86_64/ /" | sudo tee /etc/apt/sources.list.d/nvidia-drivers.list

    sudo apt update -y
    sudo apt install nvidia-driver nvidia-smi nvidia-settings -y

    sudo sed -i 's/Name=Sway/Name=Sway (NVIDIA)/g' /usr/share/wayland-sessions/sway.desktop
    sudo sed -i 's/Exec=sway/Exec=sway --unsupported-gpu/g' /usr/share/wayland-sessions/sway.desktop

else
    echo "It seems you don't have an NVIDIA GPU. Good for you!"
fi


# Final step
read -p "We're done! Ready to reboot to your new system? (Y/n): " choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

if [ "$choice" == "y" || "$choice" == "yes" || "$choice" == "" ]; then
    echo "Alright, let's go then!"
    sleep 2
    sudo reboot
else
    echo "No? Gotcha, I'll hand it back to you, do your thing."
    source $HOME/.bashrc
fi
