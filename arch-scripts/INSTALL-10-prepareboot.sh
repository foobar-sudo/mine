#!/bin/bash
archKernelArgs="${archKernelArgs}rd.shell rw rd.vconsole.keymap=${ARCH_CONSOLE_KEYMAP} rd.vconsole.font=${ARCH_CFONT} rd.locale.LANG=$ARCH_LANG rd.locale.LC_ALL=$ARCH_LANG "
archKernelArgs="${archKernelArgs}root=LABEL=$ARCH_ROOT_PART rootflags=subvol=/,${ARCH_MOUNT_BTRFS} "
archKernelArgs="${archKernelArgs}quiet splash vt.global_cursor_default=0 "
function dracut() {
pacman -Qi dracut 1>/dev/null 2>/dev/null || { echo "Dracut is not installed. Quitting."; exit; }
echo "Configuring dracut..."
mkdir -p /etc/dracut.conf.d
cat << A > /etc/dracut.conf.d/foo.conf
hostonly=yes
hostonly_cmdline=no
use_fstab=yes
compress=zstd
show_modules=yes
uefi=yes
early_microcode=yes
uefi_splash_image=/usr/share/systemd/bootctl/splash-arch.bmp
uefi_stub=/usr/lib/systemd/boot/efi/linuxx64.efi.stub
add_dracutmodules+=" crypt "
CMDLINE=(
$(printf "%s\n" $archKernelArgs)
)
kernel_cmdline="\${CMDLINE[*]}"
unset CMDLINE
A


echo "Creating dracut scripts..."

cat << B > /usr/local/bin/dracut-install-uki.sh
#!/usr/bin/env bash
ESP_MOUNTPOINT="${ARCH_ESP}"
[[ ! -e "\${ESP_MOUNTPOINT}/EFI/Linux" ]] && mkdir -p -- "\${ESP_MOUNTPOINT}/EFI/Linux"
while read -r package_file_path_line; do
	if [[ "\$package_file_path_line" == 'usr/lib/modules/'+([^/])'/pkgbase' ]]; then
		read -r pkgbase < "/\${package_file_path_line}"
		kver="\${package_file_path_line#'usr/lib/modules/'}"
		kver="\${kver%'/pkgbase'}"

		dracut --force --uefi --uefi-stub /usr/lib/systemd/boot/efi/linuxx64.efi.stub "\${ESP_MOUNTPOINT}/EFI/Linux/Arch-\${pkgbase}.efi" --kver "\$kver" 2>/dev/null
	fi
done
B
cat << C > /usr/local/bin/dracut-remove-uki.sh
#!/usr/bin/env bash
ESP_MOUNTPOINT="${ARCH_ESP}"
while read -r line; do
	if [[ "\$line" == 'usr/lib/modules/'+([^/])'/pkgbase' ]]; then
        read -r pkgbase < "/\${line}"
		rm -f "\${ESP_MOUNTPOINT}/EFI/Linux/Arch-\${pkgbase}.efi"
	fi
done
done
C


echo "Creating pacman hooks directory..."
mkdir /etc/pacman.d/hooks -p
echo "Creating dracut hooks..."
cat << "D" > /etc/pacman.d/hooks/90-dracut-install-uki.hook
[Trigger]
Type = Path
Operation = Install
Operation = Upgrade
Target = usr/lib/modules/*/pkgbase

[Action]
Description = Generating unified kernel images (with dracut!)...
When = PostTransaction
Exec = /usr/local/bin/dracut-install-uki.sh
NeedsTargets
D
cat << "E" > /etc/pacman.d/hooks/90-dracut-remove-uki.hook
[Trigger]
Type = Path
Operation = Remove
Target = usr/lib/modules/*/pkgbase

[Action]
Description = Removing linux unified kernel images...
When = PreTransaction
Exec = /usr/local/bin/dracut-remove-uki.sh
NeedsTargets
E


echo "Removing mkinitcpio hooks..."
ln -sf /dev/null /etc/pacman.d/hooks/90-mkinitcpio-install.hook
ln -sf /dev/null /etc/pacman.d/hooks/60-mkinitcpio-remove.hook
echo "Making dracut scripts executable..."
chmod +x /usr/local/bin/dracut-remove-uki.sh
chmod +x /usr/local/bin/dracut-install-uki.sh
}
dracut

echo "Installing bootloader..."
bootctl install

echo "Configuring crypttab..."
echo "$ARCH_SYSTEM_PART UUID=$(cryptsetup luksUUID /dev/disk/by-partlabel/$ARCH_SYSTEM_EPART)" | tee -a /etc/crypttab
