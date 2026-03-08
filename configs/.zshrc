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

# Portage
alias nflag="sudo -E nvim /etc/portage/package.use/flags"
alias nmask="sudo -E nvim /etc/portage/package.accept_keywords/accept_words"
alias nlicense="sudo -E nvim /etc/portage/package.license"


# NixOS
alias nixc="sudo -E nvim /etc/nixos/configuration.nix"
alias cnix="nvim $HOME/.config/nix/nix.conf"
alias nixs="nix search nixpkgs"
alias nr="sudo nixos-rebuild switch"
alias nru="sudo nixos-rebuild switch --upgrade"
alias usr-pkgs="nixos-option users.users.autumn.packages | grep"
alias sys-pkgs="nixos-option environment.systemPackages | grep"


# Sysytem
alias sleep="systemctl suspend"
alias restart="systemctl reboot"
alias sfonts="fc-list : family | grep"
alias lfonts="fc-list : family"


# git
#   git add .
#   git commit -m "<msg>"
#   git push
#
#   ssh-keygen -t ed25519 -C "your_email@example.com"
#   git remote set-url origin <repo_link>
alias cdconf="cd ~/sync/linux_config/"


# Programs
alias snvim="sudo -E nvim"
alias grep="grep --color --ignore-case"
alias mpv90="mpv --vf=rotate=90"
alias ff="fastfetch"

# Configs
alias keydc="sudo -E nvim /etc/keyd/default.conf"
alias zshc="nvim $HOME/.zshrc"

alias footc="nvim $HOME/.config/foot/foot.ini"
alias ghostc="nvim $HOME/.config/ghostty/config"
alias nvimc="nvim $HOME/.config/nvim/init.lua"
alias zellijc="nvim $HOME/.config/zellij/config.kdl"

alias hyprc="nvim $HOME/.config/hypr/hyprland.conf"
alias waybarc="nvim $HOME/.config/waybar/config.jsonc"
alias rofic="nvim $HOME/.config/rofi/config.rasi"

# Scripts
alias nsh="nvim ~/sync/linux_config/scripts/"
alias cdsh="cd ~/sync/linux_config/scripts/"
#   copies all config files to a central location and pushes to github
alias syncc="~/sync/linux_config/scripts/sync.sh"
#   download files from github using curl
alias clonec="~/sync/linux_config/scripts/clone.sh"


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


# Vim Keybinds
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
