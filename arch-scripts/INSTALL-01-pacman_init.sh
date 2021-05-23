#!/bin/bash
echo "Setting basic repository..."
echo 'Server = http://mirrors.evowise.com/archlinux/$repo/os/$arch' >> /etc/pacman.d/mirrorlist
pacman-key --init
pacman-key --populate archlinux
yes "" | pacman -Syyu sed grep
#echo "$(curl --silent 'https://archlinux.org/mirrorlist/?country=all&protocol=https&ip_version=4&use_mirror_status=on' | sed -rne 's/Server = ([^#]+)/\1/p' | sed -rne 's/#//p' | grep -oE \(^[^$]+\))" >> /etc/pacman.d/mirrorlist
#echo "Refreshing pacman keys..."
echo "Uncommenting multilib..."
sed -r '/#\[multilib\]/,/^$/ s|#||' -i /etc/pacman.conf
echo "Adding kde-unstable repository..."
grep -qw '\[kde-unstable\]' /etc/pacman.conf ||
{
echo "
[kde-unstable]
Include = /etc/pacman.d/mirrorlist
" >> /etc/pacman.conf
}
echo "pacman -Syyu reflector"
yes "" | pacman -Syyu --noconfirm reflector
echo "Invoking reflector..."
reflector $ARCH_REFLECTORARGS
