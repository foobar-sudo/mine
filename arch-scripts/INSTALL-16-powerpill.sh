#!/bin/bash
#cd /tmp
#git clone https://aur.archlinux.org/powerpill.git
#cd powerpill
#chown -R ${ARCH_USERNAME} .
#sudo -u ${ARCH_USERNAME} makepkg -sri
#sudo -u ${ARCH_USERNAME} paru -S powerpill
sudo -u ${ARCH_USERNAME} paru -S powerpill --mflags "--skipinteg"
