alias links="nvim $HOME/.config/fabrikit/links.conf"
alias plugs="nvim $HOME/.config/fabrikit/plugins.conf"
alias pkgs="nvim $HOME/.config/fabrikit/pkgs.conf"


alias paci="sudo pacman -S"    # [i]nstall
alias pacu="sudo pacman -Syu"  # [u]pdate
alias pacr="sudo pacman -Rns"  # [r]emove
alias pacs="pacman -Sp --print-format %r/%n"     # [s]earch
alias pacsl="pacman -Q"                          # [s]earch [l]ocal
alias pacopt="pacman -Sp --print-format '%n : %O'" # [o]ptional dependencies


sh_path="$HOME/sync/config/scripts"

pf() {
	"$sh_path/pacfile.sh" $@
}

fkit() {
	if [[ "$1" == l ]]; then
		"$sh_path/clink.sh"
	elif [[ "$?" == g ]]; then
		"$sh_path/gitplug.sh"
	fi
}
