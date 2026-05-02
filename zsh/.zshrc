
export GROFF_NO_SGR=1
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;33;44m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;1;32m'
export LESS_TERMCAP_mr=$'\e[7m'
export LESS_TERMCAP_mh=$'\e[2m'
export LESS_TERMCAP_ZN=$'\e[74m'
export LESS_TERMCAP_ZV=$'\e[75m'
export LESS_TERMCAP_ZO=$'\e[73m'
export LESS_TERMCAP_ZW=$'\e[75m'
export MANPAGER='less'


# ======= #
# Options #
# ======= #

export EDITOR=nvim
export VISUAL=nvim
export GTK_THEME=Adwaita:dark
export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,hl:#ea9a97
	--color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
	--color=border:#44415a,header:#3e8fb0,gutter:#232136
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

unalias run-help 2>/dev/null
autoload -Uz run-help
autoload -Uz run-help-git  # optional helpers for subcommands


# ======= #
# Visuals #
# ======= #

#   n  | name of the user
#   m  | host name
#   1~ | cwd, tilde is displayed for /home/<user>
PS1="[%F{#ebbcba}%B%n%b%f %1~] "


# ======= #
# History #
# ======= #

HISTSIZE=16384
SAVEHIST=16384
HISTFILE=~/.cache/zsh/history/


# ======== #
# Keybinds #
# ======== #

function clear-screen-scrollback() {
    printf '\033[2J\033[3J\033[H'
    zle reset-prompt
}
zle -N clear-screen-scrollback
bindkey '^L' clear-screen-scrollback


if [[ $- == *i* ]] && [[ -z "$ZELLIJ" ]] && \
   [[ -n "$WAYLAND_DISPLAY" || -n "$DISPLAY" ]]; then
	zellij
fi

# copy
bindkey "^[[3~" delete-char

function yank() {
	zle vi-yank vi-yank
	echo -n "$CUTBUFFER" | wl-copy
}
zle -N yank
bindkey -M vicmd 'y' yank

# paste after
function paste_after() {
	CUTBUFFER=$(wl-paste)
	zle vi-put-after
}
zle -N paste_after
bindkey -M vicmd 'p' paste_after

# paste before
function paste_before() {
	CUTBUFFER=$(wl-paste)
	zle vi-put-after
}
zle -N paste_before
bindkey -M vicmd 'p' paste_before


# ===== #
#  Vim  #
# ===== #

bindkey -v
export KEYTIMEOUT=1

#   change cursor shape for different modes
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


# ====== #
# Source #
# ====== #

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

source $HOME/sync/config/zsh/fabrikit.zsh
source $HOME/sync/config/zsh/aliases.zsh
source $HOME/sync/config/zsh/nvim.zsh

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


