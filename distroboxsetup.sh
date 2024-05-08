#!/usr/bin/env bash

# Distrobox + BoxBuddy
sudo nala install podman distrobox -y
flatpak install io.github.dvlv.boxbuddyrs -y

distrobox-create archlinux --image docker.io/library/archlinux:latest --nvidia
