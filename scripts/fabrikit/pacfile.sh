# guard against empty array
# removed: 1 because of empty string in array


#!/usr/bin/env bash
set -euo pipefail


fkit_path="$HOME/.config/fabrikit"


init_pkgs() {
	if [[ ! -f "$fkit_path/pkgs.conf" ]]; then
		printf "config not found\n"
		return 1
	fi
	if [[ ! -f "$fkit_path/pkgs.lock" ]]; then
		touch "$fkit_path/pkgs.lock" 
	fi

	conf_pkgs=() # sorted
	mapfile -t conf_pkgs < <( \
		# ignore comments
		sed '/[[:space:]]*#.*/d' "$fkit_path/pkgs.conf" | \
		# put each package on a separate line
		sed 's/[[:space:]]\+/\n/g' | \
		# remove blank lines
		sed '/^$/d' | sort -u)


	prev_pkgs=() # sorted
	mapfile -t prev_pkgs < <(sort -u "$fkit_path/pkgs.lock")

	installed_pkgs=() # sorted
	mapfile -t installed_pkgs < <(pacman -Qq | sort)


	removed_pkgs=()
	mapfile -t removed_pkgs < <(comm -13 \
		<(printf "%s\n" "${conf_pkgs[@]}") \
		<(printf "%s\n" "${prev_pkgs[@]}"))

	added_pkgs=()
	mapfile -t added_pkgs < <(comm -23 \
		<(printf "%s\n" "${conf_pkgs[@]}") \
		<(printf "%s\n" "${prev_pkgs[@]}"))
}


lock_pkgs() {
	comm -12 \
		<(printf "%s\n" "${conf_pkgs[@]}") \
		<(printf "%s\n" "${installed_pkgs[@]}") \
		> "$fkit_path/pkgs.lock"

	printf "packages versioned\n"
}


modify_system() {
	if [[ "${#removed_pkgs[@]}" -eq 0 && "${#added_pkgs[@]}" -eq 0 ]]; then
		printf "no changes found\n"
		return 0
	fi

	# uninstall

	printf "removed: ${#removed_pkgs[@]}\n"
	printf "    %s\n" "${removed_pkgs[@]}"
	printf "added: ${#added_pkgs[@]}\n"
	printf "    %s\n" "${added_pkgs[@]}"
	read -rp "Proceed with changes? [y/n] " ans
	[[ $ans != [Yy] ]] && return 0

	if [[ "${#removed_pkgs[@]}" -ne 0 ]]; then
		# get removed_pkgs that are currently installed
		mapfile -t removed_pkgs < <(comm -12 \
			<(printf "%s\n" "${removed_pkgs[@]}") \
			<(printf "%s\n" "${installed_pkgs[@]}"))
		sudo pacman -Rns "${removed_pkgs[@]}"
	fi

	# update and install
	mapfile -t added_pkgs < <(comm -23 \
		<(printf "%s\n" "${added_pkgs[@]}") \
		<(printf "%s\n" "${installed_pkgs[@]}"))
	if [[ "${#added_pkgs[@]}" -ne 0 ]]; then
		#   only update if new packages were added
		sudo pacman -Syu "${added_pkgs[@]}"
	fi
}


init_pkgs
modify_system 
lock_pkgs
