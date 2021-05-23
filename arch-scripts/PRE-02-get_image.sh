#!/bin/bash
cd "${ARCH_DOWNLOADDIR}"
echo "Downloading Arch ISO..."
_archMirror=$(curl --silent 'https://archlinux.org/mirrorlist/?country=all&protocol=https&ip_version=4&use_mirror_status=on' | sed -rne 's/Server = ([^#]+)/\1/p' | sed -rne 's/#//p' | shuf -n1 | grep -oE \([^$]+\) | head -1)
_archImage=$(curl --silent "${_archMirror}iso/latest/" | grep -Eo archlinux-bootstrap-[0-9]+.[0-9]+.[0-9]+-x86_64.tar.gz | uniq)
sudo curl "${_archMirror}iso/latest/${_archImage}" --output "${_archImage}"
sudo curl "${_archMirror}iso/latest/${_archImage}.sig" --output "${_archImage}.sig"
echo "Checking Arch image's signature..."
sudo gpg --keyserver-options auto-key-retrieve --verify "${_archImage}.sig" 1> /dev/null 2> /dev/null && echo "Signature is OK." || read -p "GPG returned error while checking the signature! "
echo "Extracting Arch image..."
sudo tar xzf "./${_archImage}"
echo "Copying Arch image to root directory..."
sudo cp -R "${ARCH_CHROOT_ARCHIVE_DIR}"/* .
sudo rm -r "${ARCH_CHROOT_ARCHIVE_DIR}"
sudo rm -r ${_archImage} ${_archImage}.sig

echo "Copying resolv.conf..."
sudo cp /etc/resolv.conf "${ARCH_DOWNLOADDIR}/etc"
