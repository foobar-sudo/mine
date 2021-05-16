#!/bin/bash
fileLocale="/etc/locale.conf"
fileLocaleGen="/etc/locale.gen"
fileConsole="/etc/vconsole.conf"

targetFile="${fileLocaleGen}"
defaultLocale='s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/'
[[ -z $ARCH_LANG ]] && customLocale="$defaultLocale" || customLocale="s/#${ARCH_LANG}/${ARCH_LANG}/"
seds=("defaultLocale" "customLocale")
[[ -f "$targetFile" ]] || { echo "$targetFile doesn't exist!"; exit; }
echo "Configuring ${targetFile}..."
[[ ${#seds[@]} -eq 0 ]] && echo "No configurations set." || { printf "%s\n" "${seds[@]}" | while read line; do echo "Executing command: $line"; sed -r -e "$line" -i $targetFile; done; }
sed -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' -i /etc/locale.gen
sed -e "s/#${ARCH_LANG}/${ARCH_LANG}/" -i /etc/locale.gen
echo "FONT=${ARCH_CFONT}
KEYMAP=${ARCH_CKEYMAP}" >> "${fileConsole}"
for src in {LANG,LANGUAGE,LC_ADDRESS,LC_COLLATE,LC_CTYPE,LC_IDENTIFICATION,LC_MEASUREMENT,LC_MESSAGES,LC_MONETARY,LC_NAME,LC_NUMERIC,LC_PAPER,LC_TELEPHONE,LC_TIME}; do echo "$src=${ARCH_LANG}" >> "${fileLocale}"; done
echo "locale-gen"
locale-gen
