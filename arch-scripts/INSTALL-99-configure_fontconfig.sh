#!/bin/bash
FONTS_DEFAULT="Noto Sans"
FONTS_BINDING_SERIF=("Libertinus Serif" "Noto Serif" "Noto Color Emoji" "IPAPMincho" "HanaMinA")
FONTS_BINDING_MONO=("DM Mono" "Space Mono" "Inconsolatazi4" "IPAGothic")
FONTS_BINDING_SANSSERIF=("Tex Gyre Heros")
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
            <string>${ARCH_FONTS_MONO[0]}</string>
        </edit>
$(printf "${FONTS_BINDING_TEXT}" "${FONTS_BINDING_MONO[@]}")
    </match>"

FONTS_SANSSERIF_TEXT="
    <match target=\"pattern\">
        <test qual=\"any\" name=\"family\">
            <string>sans-serif</string>
        </test>
        <edit name=\"family\" mode=\"prepend\" binding=\"same\">
            <string>${ARCH_FONTS_SANSSERIF[0]}</string>
        </edit>
$(printf "${FONTS_BINDING_TEXT}" "${FONTS_BINDING_SANSSERIF[@]}")
    </match>"


FONTS_SERIF_TEXT="
    <match target=\"pattern\">
        <test qual=\"any\" name=\"family\">
            <string>serif</string>
        </test>
        <edit name=\"family\" mode=\"prepend\" binding=\"same\">
            <string>${ARCH_FONTS_SERIF[0]}</string>
        </edit>
$(printf "${FONTS_BINDING_TEXT}" "${FONTS_BINDING_SERIF[@]}")
    </match>"


echo "Configuring fonts..."

echo "<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
	<match target=\"font\">
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
    </match>
	<match>
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
	</match>
    <!-- Default font (no fc-match pattern) -->
    <match>
        <edit mode=\"prepend\" name=\"family\">
            <string>$FONTS_DEFAULT</string>
        </edit>
    </match>
  <!-- Default sans-serif font -->
$(printf "$FONTS_SANSSERIF_TEXT" "${ARCH_FONTS_SANSSERIF[0]}")
  <!-- Default serif fonts -->
$(printf "$FONTS_SERIF_TEXT" "${ARCH_FONTS_SERIF[0]}")
  <!-- Default monospace fonts -->
$(printf "$FONTS_MONO_TEXT" "${ARCH_FONTS_MONO[0]}")

    <alias>
        <family>sans-serif</family>
        <prefer>
$(printf "      <family>%s</family>\n" "${ARCH_FONTS_SANSSERIF[@]}")
        </prefer>
    </alias>
    <alias>
        <family>serif</family>
        <prefer>
$(printf "      <family>%s</family>\n" "${ARCH_FONTS_SERIF[@]}")
        </prefer>
    </alias>
    <alias>
        <family>monospace</family>
        <prefer>
$(printf "      <family>%s</family>\n" "${ARCH_FONTS_MONO[@]}")
        </prefer>
    </alias>
</fontconfig>" >> /etc/fonts/local.conf
#>> /etc/fonts/local.conf

echo "Choosing infinity interpreter..."
echo "export FREETYPE_PROPERTIES=\"truetype:interpreter-version=38\"" >> /etc/profile.d/freetype2.sh
