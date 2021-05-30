#
# ~/.bash_profile
#
[[ -f ~/.bashrc ]] && . ~/.bashrc
_lang="ru_RU.UTF-8"
_exec="sway"
_layout="us,ru"
_options="grp:win_space_toggle,grp_led:scroll"
export LANG=${_lang}
export LANGUAGE=${_lang}
export LC_CTYPE=${_lang}
export LC_NUMERIC=${_lang}
export LC_TIME=${_lang}
export LC_COLLATE=${_lang}
export LC_MONETARY=${_lang}
export LC_MESSAGES=${_lang}
export LC_PAPER=${_lang}
export LC_NAME=${_lang}
export LC_ADDRESS=${_lang}
export LC_TELEPHONE=${_lang}
export LC_MEASUREMENT=${_lang}
export LC_IDENTIFICATION=${_lang}
export XDG_DESKTOP_DIR="$HOME/Рабочий стол"
export XDG_DOCUMENTS_DIR="$HOME/Документы"
export XDG_DOWNLOAD_DIR="$HOME/Загрузки"
export XDG_MUSIC_DIR="$HOME/Музыка"
export XDG_PICTURES_DIR="$HOME/Изображения"
export XDG_PUBLICSHARE_DIR="$HOME/Общедоступные"
export XDG_TEMPLATES_DIR="$HOME/Шаблоны"
export XDG_VIDEOS_DIR="$HOME/Видео"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

if [[ -z $DISPLAY ]] && [[ "$(tty)" = "/dev/tty1" ]] && [[ $exec = "sway" ]]; then
  export SDL_VIDEODRIVER=wayland
  export CLUTTER_BACKEND=wayland
  export QT_QPA_PLATFORMTHEME=qt5ct
  export QT_QPA_PLATFORM=wayland
  if ! [[ -z $_layout ]]; then export XKB_DEFAULT_LAYOUT="$_layout"; fi
  if ! [[ -z $_options ]]; then export XKB_DEFAULT_OPTIONS="$_options"; fi
  exec sway
fi
