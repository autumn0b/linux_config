# Gentoo
alias nflag="sudo -E nvim /etc/portage/package.use/flags"
alias nmask="sudo -E nvim /etc/portage/package.accept_keywords/accept_words"
alias nlicense="sudo -E nvim /etc/portage/package.license"


# System
alias sleep="systemctl suspend"
alias sys="systemctl -v"
alias sysu="systemctl -v --user"
alias restart="systemctl reboot"

mkbin() {
	sudo cp "$1" /usr/local/bin/
}


# CLI
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --git --group-directories-first"
alias lt="eza --tree --level=2 --icons"
alias wm="wikiman"
alias help="run-help"

alias cd="z"

# Programs
alias grep="grep --color --ignore-case"
alias mpv90="mpv --vf=rotate=90"
alias ff="fastfetch"
alias snv="sudo -E nvim"
alias vi="nvim"
alias bc="bc -q"

#   [s]way [nc]
#     [c]onfig
alias sncc="nvim $HOME/.config/swaync"
#     [r]eload
alias sncr="swaync-client --reload-config --reload-css"

# Hyprland
alias hyprq="hyprctl dispatch exit"
alias hypr="start-hyprland"


# Directories
alias notepad="nvim $HOME/sync/text/notepad.txt"
alias code="nvim $HOME/sync/code/"
alias configs="nvim $HOME/.config/fabrikit/links.conf"


# Configs
alias keydc="sudo -E nvim /etc/keyd/default.conf"
alias wpac="sudo -E nvim /etc/wpa_supplicant/wpa_supplicant.conf"

alias footc="nvim $HOME/.config/foot/foot.ini"
alias ghostc="nvim $HOME/.config/ghostty/config"
alias alac="nvim $HOME/.config/alacritty"
alias nvimc="nvim $HOME/.config/nvim/init.lua"
alias zellijc="nvim $HOME/.config/zellij"

alias hyprc="nvim $HOME/.config/hypr/hyprland.conf"
alias idlec="nvim $HOME/.config/hypr/hypridle.conf"
alias bgc="nvim $HOME/.config/hypr/hyprpaper.conf"
alias waybarc="nvim $HOME/.config/waybar/style.css"
alias rofic="nvim $HOME/.config/rofi/config.rasi"
alias yazic="nvim $HOME/.config/yazi/yazi.toml"


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
		nvim $HOME/sync/config/zsh/fabrikit.zsh
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
