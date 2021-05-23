#!/bin/bash
cd /tmp
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
chown -R ${ARCH_USERNAME} .
yes "" | sudo -u ${ARCH_USERNAME} makepkg -sri
#curl https://github.com/Morganamilo/paru/releases | grep -Po "<span class=\"pl-2 flex-auto min-width-0 text-bold\">(paru*?.tar.zst)"
#fresh=$(curl https://github.com/Morganamilo/paru/releases 2>/dev/null | grep -Po "<span class=\"pl-2 flex-auto min-width-0 text-bold\">(paru.*?-x86_64.tar.zst)" | head -n1 | sed -rne 's|<(.*)>(.*)|\2|p')
#major=$(echo $fresh | grep -Po -- "v[0-9.]+")
#wget https://github.com/Morganamilo/paru/releases/download/v1.6.1/paru-v1.6.1-x86_64.tar.zst
#link="https://github.com/Morganamilo/paru/releases/download/#$major/$fresh"
#wget $link

#git clone "${ARCH_PARU_GIT}"
#cd "${ARCH_PARU_DIR}"
#chown -R ${ARCH_USERNAME} .
#yes "" | sudo -u ${ARCH_USERNAME} makepkg -sri
