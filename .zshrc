# n | name of the user
# m | host name
# 1~ | cwd, tilde is displayed for /home/<user>
#	Red name
PS1="[%F{#f0a6cc}%B%n%b%f %1~] "
PS1="[%F{#ebbcba}%B%n%b%f %1~] "
#PS1="[%F{#d84f76}%B%n%b%f %1~] "


# ====================
# Aliases and Keybinds
# ====================

#temp
alias wpa="sudo wpa_supplicant -iwlp8s0 -c /etc/wpa_supplicant/wpa_supplicant-wlp8s0.conf -B"


# Portage
alias nflag="sudo -E nvim /etc/portage/package.use/flags"
alias nmask="sudo -E nvim /etc/portage/package.accept_keywords/accept_words"
alias nlicense="sudo -E nvim /etc/portage/package.license"
# Sysytem
alias sleep="loginctl suspend"
alias restart="loginctl reboot"
	#alias dim1="wlsunset SIGUSR1 -T 5500 -g 0.95"
	#alias dim2="wlsunset SIGUSR1 -T 5000 -g 0.95"
	#alias dim3="wlsunset SIGUSR1 -T 4500 -g 0.95"

#   Program
alias snvim="sudo -E nvim"
alias grep="grep --color"
alias mpv90="mpv --vf=rotate=90"
alias nroot="sudo -E nvim /"
alias ff="fastfetch"

# Configs
alias yconf="yazi $HOME/.config/"

alias nvimc="nvim +'Telescope find_files cwd=$HOME/.config/nvim/'"
alias keydc="sudo -E nvim /etc/keyd/default.conf"

alias swayc="nvim $HOME/.config/sway/"
alias hyprc="nvim $HOME/.config/hypr/hyprland.conf"
alias waybarc="nvim $HOME/.config/waybar/config.jsonc"

alias footc="nvim $HOME/.config/foot/foot.ini"
alias ghostc="nvim $HOME/.config/ghostty/config"
alias zshc="nvim $HOME/.zshrc"
alias zellijc="nvim $HOME/.config/zellij/config.kdl"
alias rofic="nvim $HOME/.config/rofi/config.rasi"


# =========

export EDITOR=nvim
export VISUAL=nvim

# Keybinds
bindkey "^[[3~" delete-char


# History in cache dir:
HISTSIZE=4096
SAVEHIST=4096
HISTFILE=~/.cache/zsh/history/


# Basic tab completion:
# autoload -U compinit
# zstyle ":completion:*" menu select
# zmodload zsh/complist
# compinit
# #	Include hidden files.
# _comp_options+=(globdots)


# Vim Motions
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different modes
function zle-keymap-select
{
	if [[ ${KEYMAP} == vicmd ]] ||
	   [[ $1 = "block" ]]; then
		echo -ne "\e[1 q"
	elif [[ ${KEYMAP} == main ]] ||
	     [[ ${KEYMAP} == viins ]] ||
	     [[ ${KEYMAP} == '' ]] ||
	     [[ $1 = "beam" ]]; then
		echo -ne "\e[5 q"
	fi
}

zle -N zle-keymap-select
zle-line-init()
{
	# Initiate `vi insert` as keymap.
	# (can be removed if `bindkey -V` has been set elsewhere)
	zle -K viins
	echo -ne "\e[5 q"
}

zle -N zle-line-init
# Use beam cursor on startup.
echo -ne "\e[5 q"
# Use beam cursor for each new prompt.
preexec() { echo -ne "\e[5 q" ;}
