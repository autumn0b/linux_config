# Arch
alias paci="sudo pacman -S"    # [i]nstall
alias pacu="sudo pacman -Syu"  # [u]pdate
alias pacr="sudo pacman -Rns"  # [r]emove
alias pacs="pacman -Sp --print-format %r/%n"     # [s]earch
alias pacsl="pacman -Q"                          # [s]earch [l]ocal
alias paco="pacman -Sp --print-format '%n : %O'" # [o]ptional dependencies


# Gentoo
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


# System
alias sleep="systemctl suspend"
alias sys="systemctl -v"
alias sysu="systemctl -v --user"
alias restart="systemctl reboot"

# CLI
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons'

alias cd="z"

# Programs
alias grep="grep --color --ignore-case"
alias mpv90="mpv --vf=rotate=90"
alias ff="fastfetch"
alias snv='sudo -E nvim'
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
alias pkgs="nvim $HOME/sync/config/fabrikit/pkgs.conf"
alias configs="nvim $HOME/.config/fabrikit/links.conf"


# Configs
alias keydc="sudo -E nvim /etc/keyd/default.conf"
alias wpac="sudo -E nvim /etc/wpa_supplicant/wpa_supplicant.conf"
alias fishc="nvim $HOME/sync/config/fish/"

alias footc="nvim $HOME/.config/foot/foot.ini"
alias ghostc="nvim $HOME/.config/ghostty/config"
alias nvimc="nvim $HOME/.config/nvim/init.lua"
alias zellijc="nvim $HOME/.config/zellij"

alias hyprc="nvim $HOME/.config/hypr/hyprland.conf"
alias idlec="nvim $HOME/.config/hypr/hypridle.conf"
alias bgc="nvim $HOME/.config/hypr/hyprpaper.conf"
alias waybarc="nvim $HOME/.config/waybar/style.css"
alias rofic="nvim $HOME/.config/rofi/config.rasi"

