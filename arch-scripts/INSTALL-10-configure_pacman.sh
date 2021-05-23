targetFile="/etc/pacman.conf"
color="s/#Color/Color/"
totalDownload="s/#TotalDownload/TotalDownload/"
verbosePkgLists="s/#VerbosePkgLists/VerbosePkgLists/"
seds=("$verbosePkgLists" "$totalDownload" "$color")
[[ -f "$targetFile" ]] || { echo "$targetFile doesn't exist!"; exit; }
echo "Configuring ${targetFile}..."
[[ ${#seds[@]} -eq 0 ]] && echo "No configurations set." || { printf "%s\n" "${seds[@]}" | while read line; do echo "Executing command: $line"; sed -r -e "$line" -i $targetFile; done; }
