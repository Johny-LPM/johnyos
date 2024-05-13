#!/usr/bin/env bash

# Distrobox + BoxBuddy
sudo nala install podman distrobox -y
flatpak install io.github.dvlv.boxbuddyrs -y

# Ptyxis as the container-focused terminal
flatpak install --user --from https://nightly.gnome.org/repo/appstream/org.gnome.Ptyxis.Devel.flatpakref -y

distrobox-create archlinux --image docker.io/library/archlinux:latest --nvidia
