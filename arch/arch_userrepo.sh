#curl https://wiki.archlinux.org/title/Unofficial_user_repositories | (echo "Server: $(sed -rne '/<h3><span class="mw-headline"/,/<\/pre>/ s/^Server = (.*)/(\1)/gp')");
#mirrorText=$(echo $(curl https://wiki.archlinux.org/title/Unofficial_user_repositories | sed -rne '/<h3><span class="mw-headline"/,/<\/pre>/ s/(.*)/&/gp'))
count=0
#arrayMirror=($(echo $mirrorText | grep -ohw --color -E 'Server = (https[^ ]*)' | awk '{print $3}' | while read line; do echo $line; done))
#echo $mirrorText | grep -Pi --color -o 'Key-ID:</b>(.+?)</li>'
#arrayName=($(echo $mirrorText | grep -Pio --color '<h3><span class="mw-headline" id="(.+?)"' | sed -rne 's/(.*)id="(.*)"/\2/gp'))
mirrorText=$(echo $(curl https://wiki.archlinux.org/title/Unofficial_user_repositories | sed -rne '/<h3><span class="mw-headline"/,/<\/pre>/ s/(.*)/&/gp'))
mirrorText=$(echo $mirrorText | grep -P --color -o '<h3><span class="mw-headline"(.*?)</pre>')

function aurMirrors() {
echo "$mirrorText" | while read line; do
{
count=$(("${count}" + 1 ));
#echo $line;
mirror=($(echo $line | grep -ohw --color -P 'Server = ([^ ]*)' | awk '{print $3}'));
name=($(echo $line | grep -Pio --color '<h3><span class="mw-headline" id="(.+?)"' | sed -rne 's/(.*)id="(.*)"/\2/gp'));
arrayMirror[count]=$mirror;
arrayName[count]=$name;
#echo "ARRAYMIRROR: ${arrayMirror[count]}; ARRAYNAME: ${arrayName[count]}; COUNT: $count";
echo -e "${arrayName[count]}\t${arrayMirror[count]}"
}; done
}
