#!/bin/bash
echo "Mounting directories needed for chroot..."
sudo mount -t proc /proc "${ARCH_DOWNLOADDIR}/proc"
sudo mount --make-rslave --rbind /sys "${ARCH_DOWNLOADDIR}/sys"
sudo mount --make-rslave --rbind /dev "${ARCH_DOWNLOADDIR}/dev"
sudo mount --make-rslave --rbind /run "${ARCH_DOWNLOADDIR}/run"
