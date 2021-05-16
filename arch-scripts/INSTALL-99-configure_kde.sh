#!/bin/bash
targetFile="/usr/bin/kwriteconfig5"
ls "${targetFile}" 2>&1 1>/dev/null && { echo "Enabling KDE systemd boot..."; kwriteconfig5 --file startkderc --group General --key systemdBoot true; }
pacman -Qi sddm 1>/dev/null 2>/dev/null && { echo "SDDM is installed."; pacman -Qi plymouth 1>/dev/null 2>/dev/null && { echo "Plymouth detected. Enabling sddm-plymouth..."; systemctl enable sddm-plymouth;  }  || systemctl enable sddm; };
pacman -Qi sddm 1>/dev/null 2>/dev/null && { echo "Baloo is installed. Disabling baloo."; balooctl disable; }
