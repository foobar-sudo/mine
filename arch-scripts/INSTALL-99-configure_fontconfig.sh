#!/bin/bash
fontsHinting="hintfull"
FONTS_DEFAULT="Noto Sans"
FONTS_BINDING_SERIF=("Libertinus Serif" "Noto Serif" "Noto Color Emoji" "IPAPMincho" "HanaMinA" "Droid Serif")
FONTS_BINDING_MONO=("DM Mono" "Space Mono" "Inconsolatazi4" "IPAGothic" "Droid Sans Mono")
FONTS_BINDING_SANSSERIF=("Tex Gyre Heros" "Droid Sans")
archFontsSansSerif=("Noto Sans" "Noto Color Emoji" "Noto Emoji" "Open Sans" "Droid Sans" "Ubuntu" "Roboto" "NotoSansCJK" "Source Han Sans JP" "IPAPGothic" "VL PGothic" "Koruri")
archFontsSerif=("Noto Serif" "Noto Color Emoji" "Noto Emoji" "Droid Serif" "Roboto Slab" "IPAPMincho")
archFontsMono=("Noto Sans Mono" "Hack" "Noto Color Emoji" "Noto Emoji" "Inconsolatazi4" "Ubuntu Mono" "Droid Sans Mono" "Roboto Mono" "IPAGothic")
FONTS_BINDING_TEXT="        <edit name=\"family\" mode=\"append\" binding=\"same\">
            <string>%s</string>
        </edit>\n"
FONTS_TEXT="<match target=\"pattern\">\
    <test qual=\"any\" name=\"family\">
    <string>%s</string>
    </test>"
FONTS_MONO_TEXT="
    <match target=\"pattern\">
        <test qual=\"any\" name=\"family\">
            <string>monospace</string>
        </test>
        <edit name=\"family\" mode=\"prepend\" binding=\"same\">
            <string>${archFontsMono[0]}</string>
        </edit>
$(printf "${FONTS_BINDING_TEXT}" "${FONTS_BINDING_MONO[@]}")
    </match>"

FONTS_SANSSERIF_TEXT="
    <match target=\"pattern\">
        <test qual=\"any\" name=\"family\">
            <string>sans-serif</string>
        </test>
        <edit name=\"family\" mode=\"prepend\" binding=\"same\">
            <string>${archFontsSansSerif[0]}</string>
        </edit>
$(printf "${FONTS_BINDING_TEXT}" "${FONTS_BINDING_SANSSERIF[@]}")
    </match>"


FONTS_SERIF_TEXT="
    <match target=\"pattern\">
        <test qual=\"any\" name=\"family\">
            <string>serif</string>
        </test>
        <edit name=\"family\" mode=\"prepend\" binding=\"same\">
            <string>${archFontsSerif[0]}</string>
        </edit>
$(printf "${FONTS_BINDING_TEXT}" "${FONTS_BINDING_SERIF[@]}")
    </match>"

function hinter() {
echo "	<match target=\"font\">
        <edit name=\"antialias\" mode=\"assign\">
            <bool>true</bool>
        </edit>
		<edit name=\"autohint\" mode=\"assign\">
			<bool>true</bool>
        </edit>
        <edit name=\"embeddedbitmap\" mode=\"assign\">
            <bool>false</bool>
        </edit>
        <edit name=\"hinting\" mode=\"assign\">
            <bool>true</bool>
        </edit>
        <edit mode=\"assign\" name=\"hintstyle\">
            <const>hintfull</const>
        </edit>
        <edit mode=\"assign\" name=\"lcdfilter\">
            <const>lcddefault</const>
        </edit>
        <edit name=\"rgba\" mode=\"assign\">
            <const>rgb</const>
        </edit>
        <test name=\"weight\" compare=\"more\">
            <const>medium</const>
        </test>
        <edit name=\"autohint\" mode=\"assign\">
            <bool>false</bool>
        </edit>
    </match>"
}
function defaultFont() {
echo "    <match>
        <edit mode=\"prepend\" name=\"family\">
            <string>$FONTS_DEFAULT</string>
        </edit>
    </match>"
}
function chromeOs() {
echo "	<match>
		<test name=\"family\">
			<string>Arial</string>
		</test>
		<edit name=\"family\" mode=\"assign\" binding=\"strong\">
			<string>Arimo</string>
		</edit>
	</match>
	<match>
		<test name=\"family\">
			<string>Helvetica</string>
		</test>
		<edit name=\"family\" mode=\"assign\" binding=\"strong\">
			<string>Arimo</string>
		</edit>
	</match>
	<match>
		<test name=\"family\">
			<string>Verdana</string>
		</test>
		<edit name=\"family\" mode=\"assign\" binding=\"strong\">
			<string>Arimo</string>
		</edit>
	</match>
	<match>
		<test name=\"family\">
			<string>Tahoma</string>
		</test>
		<edit name=\"family\" mode=\"assign\" binding=\"strong\">
			<string>Arimo</string>
		</edit>
	</match>
	<match>
		<test name=\"family\">
			<string>Times New Roman</string>
		</test>
		<edit name=\"family\" mode=\"assign\" binding=\"strong\">
			<string>Tinos</string>
		</edit>
	</match>
	<match>
		<test name=\"family\">
			<string>Times</string>
		</test>
		<edit name=\"family\" mode=\"assign\" binding=\"strong\">
			<string>Tinos</string>
		</edit>
	</match>
	<match>
		<test name=\"family\">
			<string>Consolas</string>
		</test>
		<edit name=\"family\" mode=\"assign\" binding=\"strong\">
			<string>Cousine</string>
		</edit>
	</match>
	<match>
		<test name=\"family\">
			<string>Courier New</string>
		</test>
		<edit name=\"family\" mode=\"assign\" binding=\"strong\">
			<string>Cousine</string>
		</edit>
	</match>
	<match>
		<test name=\"family\">
			<string>Calibri</string>
		</test>
		<edit name=\"family\" mode=\"assign\" binding=\"strong\">
			<string>Carlito</string>
		</edit>
	</match>
	<match>
		<test name=\"family\">
			<string>Cambria</string>
		</test>
		<edit name=\"family\" mode=\"assign\" binding=\"strong\">
			<string>Caladea</string>
		</edit>
	</match>"
}

function defaultFonts()
{
echo "$(printf "$FONTS_SANSSERIF_TEXT" "${archFontsSansSerif[0]}")
$(printf "$FONTS_SERIF_TEXT" "${archFontsSerif[0]}")
$(printf "$FONTS_MONO_TEXT" "${archFontsMono[0]}")"
}

function preferedFonts()
{
echo "  <alias>
        <family>sans-serif</family>
        <prefer>
$(printf "          <family>%s</family>\n" "${archFontsSansSerif[@]}")
        </prefer>
    </alias>
    <alias>
        <family>serif</family>
        <prefer>
$(printf "          <family>%s</family>\n" "${archFontsSerif[@]}")
        </prefer>
    </alias>
    <alias>
        <family>monospace</family>
        <prefer>
$(printf "          <family>%s</family>\n" "${archFontsMono[@]}")
        </prefer>
    </alias>"
}
echo "Deleting previous configuration..."
#find /etc/fonts/conf.d/ -type l -delete
echo "Configuring fonts..."

echo "<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
$(hinter)
$(chromeOs)
$(defaultFont)
$(defaultFonts)
$(preferedFonts)
</fontconfig>" | { sudo -u ${ARCH_USERNAME} mkdir -p /home/${ARCH_USERNAME}/.config/fontconfig/; sudo -u ${ARCH_USERNAME} tee /home/${ARCH_USERNAME}/.config/fontconfig/fonts.conf; }
#>> /etc/fonts/local.conf

echo "Choosing infinity interpreter..."
echo "export FREETYPE_PROPERTIES=\"truetype:interpreter-version=38\"
export FT2_SUBPIXEL_HINTING=1" >> /etc/profile.d/freetype2.sh


targetFile="/usr/bin/kwriteconfig5"
plasmaFile="kdeglobals"
ls "${targetFile}" 2>&1 1>/dev/null &&
{
echo "Configuring KDE...";
sudo -u $ARCH_USERNAME kwriteconfig5 --group General --key XftAntialias --file $plasmaFile --type bool true;
sudo -u $ARCH_USERNAME kwriteconfig5 --group General --key XftHintStyle --file $plasmaFile "${fontsHinting}";
sudo -u $ARCH_USERNAME kwriteconfig5 --group General --key XftSubPixel --file $plasmaFile "rgb";
sudo -u $ARCH_USERNAME kwriteconfig5 --group General --key font --file $plasmaFile "${archFontsSansSerif[0]},10,-1,5,50,0,0,0,0,0";
sudo -u $ARCH_USERNAME kwriteconfig5 --group General --key fixed --file $plasmaFile "${archFontsMono[0]},10,-1,5,50,0,0,0,0,0";
sudo -u $ARCH_USERNAME kwriteconfig5 --group General --key menuFont --file $plasmaFile "${archFontsSansSerif[0]},10,-1,5,50,0,0,0,0,0";
sudo -u $ARCH_USERNAME kwriteconfig5 --group General --key smallestReadableFont --file $plasmaFile "${archFontsSansSerif[0]},8,-1,5,50,0,0,0,0,0";
sudo -u $ARCH_USERNAME kwriteconfig5 --group General --key toolBarFont --file $plasmaFile "${archFontsSansSerif[0]},10,-1,5,50,0,0,0,0,0";
sudo -u $ARCH_USERNAME kwriteconfig5 --group WM --key activeFont --file $plasmaFile "${archFontsSansSerif[0]},10,-1,5,50,0,0,0,0,0";
}
