#!/bin/bash
targetFile="make.test"
changeArch="s/-march=x86-64/-march=native/"
changeTune="s/-mtune=generic/-mtune=native/"
uncommentRust="s/#RUSTFLAGS/RUSTFLAGS/"
changeRust='s/RUSTFLAGS="(.*)"/RUSTFLAGS="\1 -C target-cpu=native"/'
uncommentMakef="s/#MAKEFLAGS/MAKEFLAGS/"
changeThreads="s/-j[0-9]+/-j$(nproc) -l$(nproc)/"
seds=("$changeArch" "$changeTune" "$uncommentRust" "$changeRust" "$uncommentMakef" "$changeThreads")
[[ -f "$targetFile" ]] || { echo "$targetFile doesn't exist!"; exit; }
echo "Configuring ${targetFile}..."
[[ ${#seds[@]} -eq 0 ]] && echo "No configurations set." || { printf "%s\n" "${seds[@]}" | while read line; do echo "Executing command: $line"; sed -r -e "$line" -i $targetFile; done; }
