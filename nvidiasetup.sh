#!/usr/bin/env bash

# If an NVIDIA GPU is detected, sets up the NVIDIA Driver
if lspci | grep -i nvidia > /dev/null; then
    if nvidia-smi; then
        clear
        echo "You've got the NVIDIA drivers, alrighty!"
        sleep 4
    else
        clear
        echo "It appears you have an NVIDIA GPU. I'll be taking some extra steps for your convenience!"
        sleep 4

        sudo apt install software-properties-common -y
        sudo add-apt-repository contrib non-free-firmware non-free -y
        sudo apt install dirmngr ca-certificates apt-transport-https dkms curl -y

        sudo curl -fSsL https://developer.download.nvidia.com/compute/cuda/repos/debian"$(lsb_release -sr 2>/dev/null)"/x86_64/3bf863cc.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/nvidia-drivers.gpg > /dev/null 2>&1

        echo "deb [signed-by=/usr/share/keyrings/nvidia-drivers.gpg] https://developer.download.nvidia.com/compute/cuda/repos/debian$(lsb_release -sr 2>/dev/null)/x86_64/ /" | sudo tee /etc/apt/sources.list.d/nvidia-drivers.list

        sudo apt update -y
        sudo apt install nvidia-driver nvidia-smi nvidia-settings xwayland libxcb1 libnvidia-egl-wayland1 -y
        gsettings set org.gnome.mutter experimental-features [\"kms-modifiers\"]

        #sudo echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1' | sudo tee /etc/modprobe.d/nvidia-power-management.conf

        sudo sed -i 's/quiet/quiet rd.driver.blacklist=nouveau nvidia-drm.modeset=1/g' /etc/default/grub
        # GDM Fix for Wayland sessions with NVIDIA
        #sudo ln -s /dev/null /etc/udev/rules.d/61-gdm.rules
        sudo update-grub
    fi
else
    clear
    echo "It seems you don't have an NVIDIA GPU. Good for you!"
    sleep 5
fi
