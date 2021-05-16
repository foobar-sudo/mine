#!/bin/bash
echo "Generating fstab..."
genfstab -L -p / | grep -v -e "zram" -e "/run/" | tee -a /etc/fstab
