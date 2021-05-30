#!/usr/bin/env bash
ESP_MOUNTPOINT="/efi"
while read -r line; do
	if [[ "$line" == 'usr/lib/modules/'+([^/])'/pkgbase' ]]; then
        read -r pkgbase < "/${line}"
		rm -f "${ESP_MOUNTPOINT}/EFI/Linux/Arch-${pkgbase}.efi"
	fi
done
