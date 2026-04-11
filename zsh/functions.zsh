# @yazi
y() {
	if [[ "$1" = "c" ]]; then
		yazi $HOME/.config/
	elif [[ "$1" = "s" ]]; then
		yazi $HOME/sync/
	elif [[ "$1" = "sc" ]]; then
		yazi $HOME/sync/config/
	else
		yazi $1
	fi
}


# @search
#   [s]earch, action , (optional) base search path
s() {
	if [[ -z "$2" ]]; then
		2="$HOME"
	elif [[ "$2" = c ]]; then
		2="$HOME/.config/"
	fi

	DIR="$(fd . $2 | fzf)"
	if [[ -n $DIR ]]; then
		$1 $DIR
	fi
}


notes() {
	if [[ -z "$1" ]]; then
		nvim $HOME/sync/text/
	elif [[ "$1" = l ]]; then
		nvim $HOME/sync/text/notes/linux.txt
	fi
}


zshc() {
	if [[ -z "$1" ]]; then
		nvim $HOME/sync/config/zsh/
	elif [[ "$1" == a ]]; then
		nvim $HOME/sync/config/zsh/aliases.zsh
	elif [[ "$1" == f ]]; then
		nvim $HOME/sync/config/zsh/functions.zsh
	elif [[ "$1" == n ]]; then
		nvim $HOME/sync/config/zsh/nvim.zsh
	fi
}

font() {
	if [[ "$1" == l ]]; then
		fc-list : family | sed 's/,.*//' | sort -u
	elif [[ "$1" == s ]]; then
		fc-list : family | grep "$2"
	fi
}


fkit() {
	if [[ "$1" == p ]]; then
		"$HOME/sync/config/scripts/fabrikit/pacfile.sh"
	elif [[ "$1" == l ]]; then
		$HOME/sync/config/scripts/fabrikit/clink.sh
	fi
}
