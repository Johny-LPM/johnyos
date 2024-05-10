#!/usr/bin/env bash

echo "I'll be installing some convenience programs in the background for you! Just press ENTER and then you can minimize this and let it run in the background."

# Flatpak utils
flatpak install com.github.tchx84.Flatseal -y
flatpak install io.github.flattool.Warehouse -y
# And for AppImage
flatpak install it.mijorus.gearlever -y

#flatpak install com.google.Chrome -y
flatpak install org.onlyoffice.desktopeditors -y
flatpak install com.github.d4nj1.tlpui -y

# Optional (my personal configuration)
flatpak install com.valvesoftware.Steam -y
flatpak install net.lutris.Lutris -y
flatpak install com.heroicgameslauncher.hgl -y
flatpak install page.kramo.Cartridges -y

rm $HOME/.config/autostart/flatpaksinstall.desktop