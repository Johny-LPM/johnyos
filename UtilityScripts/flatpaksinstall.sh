#!/usr/bin/env bash

echo "I'll be installing some convenience programs in the background for you! Just authenticate this and then you can minimize it and let it run in the background."
sudo echo ""

# Flatpak utils
sudo flatpak install com.github.tchx84.Flatseal -y
sudo flatpak install io.github.flattool.Warehouse -y
# And for AppImage
sudo flatpak install it.mijorus.gearlever -y

#flatpak install com.google.Chrome -y
sudo flatpak install org.onlyoffice.desktopeditors -y
sudo flatpak install com.github.d4nj1.tlpui -y

# Optional (my personal configuration)
sudo flatpak install com.valvesoftware.Steam -y
sudo flatpak install net.lutris.Lutris -y
sudo flatpak install com.heroicgameslauncher.hgl -y
sudo flatpak install page.kramo.Cartridges -y

rm $HOME/.config/autostart/flatpaksinstall.desktop
