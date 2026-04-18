# todo - show "updated packages:" instead of "no changes found" when
#        new packages are added/removed to the file that are already installed
# todo - add colors to "# header" printf messages


#!/usr/bin/env bash
set -euo pipefail


fkit_path="$HOME/.config/fabrikit"


conf_pkgs=()
# only add a package to the lock file if it is installed
lock_pkgs=()

# pkgs added to the config, not in the lock file
added_pkgs=()
# pkgs removed from the config, but still in the lock file
removed_pkgs=()

installed_pkgs=()


print_pkgs() {
	printf "%s\n" "$@" | sed '/^$/d'
}


init_pkgs() {
	# init package arrays
	mapfile -t conf_pkgs < <(             \
		sed -e 's/[[:space:]]*#.*//g' \
		-e 's/[[:space:]]\+/\n/g'     \
		-e '/^$/d' "$fkit_path/pkgs.conf" | sort -u)

	mapfile -t lock_pkgs < <(sort -u "$fkit_path/pkgs.lock")

	mapfile -t removed_pkgs < <(comm -13    \
		<(print_pkgs "${conf_pkgs[@]}") \
		<(print_pkgs "${lock_pkgs[@]}"))

	mapfile -t added_pkgs < <(comm -23      \
		<(print_pkgs "${conf_pkgs[@]}") \
		<(print_pkgs "${lock_pkgs[@]}"))

	mapfile -t installed_pkgs < <(pacman -Qq | sort)
}


modify_system() {
	# remove
	if [[ "${#removed_pkgs[@]}" -ne 0 ]]; then
		# sudo pacman -Rns <pkgs>
		printf "\e[36m%s\e[0m\n" "# removing..."
		sudo pacman -Rns "${removed_pkgs[@]}"
	fi

	# update and install
	if [[ "${#added_pkgs[@]}" -ne 0 ]]; then
		# separate update and install steps to distinguish
		# script-managed packages from update dependencies
		printf "\e[36m%s\e[0m\n" "# updating..."
		sudo pacman -Syu
		printf "\n"

		printf "\e[36m%s\e[0m\n" "# installing..."
		# let pacman handle invalid package names
		sudo pacman -S --needed "${added_pkgs[@]}"
	fi
}


version_pkgs() {
	local conf_and_installed=()
	mapfile -t conf_and_installed < <(comm -12 \
		<(print_pkgs "${conf_pkgs[@]}")    \
		<(print_pkgs "${installed_pkgs[@]}"))

	# removed_pkgs are still tracked unless uninstalled
	local lock_and_installed=()
	mapfile -t lock_and_installed < <(comm -12 \
		<(print_pkgs "${lock_pkgs[@]}")    \
		<(print_pkgs "${installed_pkgs[@]}"))

	print_pkgs "${conf_and_installed[@]}" "${lock_and_installed[@]}" | \
		sort -u > "$fkit_path/pkgs.lock"

	printf "\e[36m%s\e[0m\n" "# packages versioned"
	printf "\n"
}


main() {
	# check if files exist
	if [[ ! -f "$fkit_path/pkgs.conf" ]]; then
		printf "config not found\n"
		return 1
	fi

	if [[ ! -f "$fkit_path/pkgs.lock" ]]; then
		printf "\e[36m%s\e[0m\n" "# creating lock file..."
		touch "$fkit_path/pkgs.lock"
	fi

	# read from pkgs.conf and pkgs.lock to check for current pacfile state and user changes
	init_pkgs

	# update pkgs.lock to reflect discrepencies in system state before making changes
	#   relevant if packages were installed or uninstalled outside of the script
	version_pkgs

	# re-read from pkgs.conf and pkgs.lock after updates
	init_pkgs

	# display detected changes
	if [[ "${#removed_pkgs[@]}" -eq 0 && "${#added_pkgs[@]}" -eq 0 ]]; then
		printf "no changes found\n"
		return 0
	fi

	printf "\e[36m%s\e[0m\n" "# changes found"
	printf -- "- removed: %s\n" "${#removed_pkgs[@]}"
	printf "    %s\n" "${removed_pkgs[@]}" | column
	printf -- "- added: %s\n" "${#added_pkgs[@]}"
	printf "    %s\n" "${added_pkgs[@]}" | column
	printf "\n"

	modify_system

	version_pkgs
}


main
