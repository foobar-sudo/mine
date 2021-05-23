#!/bin/bash
targetFile="/usr/bin/kwriteconfig5"
ls "${targetFile}" 2>&1 1>/dev/null && {
echo "Enabling KDE systemd boot...";
sudo -u $ARCH_USERNAME kwriteconfig5 --file startkderc --group General --key systemdBoot true;
kwriteconfig5 --file startkderc --group General --key systemdBoot true;
echo "Disabling single-click behaviour..."
sudo -u $ARCH_USERNAME kwriteconfig5 --file kdeglobals --group KDE --key SingleClick --type bool false
echo "Configuring mouse..."
sudo -u $ARCH_USERNAME kwriteconfig5 --file kcminputrc --group KDE --key XLbInptAccelProfileFlat --type bool true
sudo -u $ARCH_USERNAME kwriteconfig5 --file kcminputrc --group KDE --key XLbInptPointerAcceleration -- '-0.6'
#echo "XLbInptPointerAcceleration=-0.6" | sudo -u $ARCH_USERNAME tee /home/$ARCH_USERNAME/.config/kcminputrc
sudo -u $ARCH_USERNAME kwriteconfig5 --file kcminputrc --group "Libinput" --group 6392 --group 3993 --group "USB OPTICAL MOUSE " --key PointerAcceleration -- "-0.4"
sudo -u $ARCH_USERNAME kwriteconfig5 --file kcminputrc --group "Libinput" --group 6392 --group 3993 --group "USB OPTICAL MOUSE " --key PointerAccelerationProfile -- 1
}
pacman -Qi sddm 1>/dev/null 2>/dev/null && { echo "SDDM is installed."; pacman -Qi plymouth 1>/dev/null 2>/dev/null && { echo "Plymouth detected. Enabling sddm-plymouth..."; systemctl enable sddm-plymouth;  }  || systemctl enable sddm; };
pacman -Qi sddm 1>/dev/null 2>/dev/null && { echo "Baloo is installed. Disabling baloo."; balooctl disable; sudo -u ${ARCH_USERNAME} balooctl disable; }
