targetFile="/usr/bin/kwriteconfig5"
plasmaLocale="plasma-localerc"
keymapSwitch="grp:alt_shift_toggle"
kxkbrcFile="/home/${ARCH_USERNAME}/.config/kxkbrc"
kxkbrc="[\$Version]
update_info=kxkb_variants.upd:split-variants
[Layout]
DisplayNames=,
LayoutList=${ARCH_DE_KEYMAPS}
LayoutLoopCount=-1
Model=pc86
Options=${keymapSwitch}
ResetOldOptions=true
ShowFlag=false
ShowLabel=true
ShowLayoutIndicator=true
ShowSingle=false
SwitchMode=Global
Use=true
VariantList=,"
ls "${targetFile}" 2>&1 1>/dev/null && { echo "${targetFile} is installed... Applying localization."; sudo -u $ARCH_USERNAME kwriteconfig5 --group Formats --key LANG --file ${plasmaLocale} ${ARCH_LANG}; }
ls "${targetFile}" 2>&1 1>/dev/null && { echo "$kxkbrc" | sudo -u $ARCH_USERNAME tee $kxkbrcFile; }
pacman -Qi sddm 1>/dev/null 2>/dev/null && { echo "SDDM is installed."; echo "Applying localization settings to SDDM."; mkdir -p /usr/share/sddm/scripts; echo "setxkbmap -model pc104 -layout ${ARCH_DE_KEYMAPS} -option ${keymapSwitch}" >> /usr/share/sddm/scripts/Xsetup; };
