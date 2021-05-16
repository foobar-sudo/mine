#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u \W]\$ '
alias ls='ls --color=auto'
alias mdl="youtube-dl -x -f bestaudio -o \"$XDG_MUSIC_DIR/%(title)s.%(ext)s\""
