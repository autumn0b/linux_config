# ====== #

source ~/sync/config/zsh/functions.zsh
source ~/sync/config/zsh/aliases.zsh
source ~/sync/config/zsh/conf.zsh
source ~/sync/config/zsh/nvim.zsh


# ======= #
# Options #
# ======= #

export EDITOR=nvim
export VISUAL=nvim


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

HISTSIZE=1024
SAVEHIST=1024
HISTFILE=~/.cache/zsh/history/


# ======== #
# Keybinds #
# ======== #

bindkey "^[[3~" delete-char


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
