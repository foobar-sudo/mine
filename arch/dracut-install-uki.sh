#!/usr/bin/env bash
ESP_MOUNTPOINT="/efi"
[[ ! -e "${ESP_MOUNTPOINT}/EFI/Linux" ]] && mkdir -p -- "${ESP_MOUNTPOINT}/EFI/Linux"
while read -r package_file_path_line; do
	if [[ "$package_file_path_line" == 'usr/lib/modules/'+([^/])'/pkgbase' ]]; then
		read -r pkgbase < "/${package_file_path_line}"
		kver="${package_file_path_line#'usr/lib/modules/'}"
		kver="${kver%'/pkgbase'}"

		dracut --force --uefi --uefi-stub /usr/lib/systemd/boot/efi/linuxx64.efi.stub "${ESP_MOUNTPOINT}/EFI/Linux/Arch-${pkgbase}.efi" --kver "$kver" 2>/dev/null
	fi
done
