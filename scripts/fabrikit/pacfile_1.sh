#!/usr/bin/env bash
set -euo pipefail


pkgs_path="$HOME/.config/fabrikit"

pkgs_conf=()
pkgs_lock=()
added_pkgs=()
removed_pkgs=()


# add_pkgs(<array>, <file>)
#   add packages to <array> from <file>
add_pkgs() {
	local -n arr=$1
	while read -r line; do
		line="${line%%#*}"
		[[ -z "${line}" ]] && continue
		read -ra pkgs <<< "$line"
		arr+=("${pkgs[@]}")
	done < "$2"
}

lock_pkgs() {
	local installed_pkgs
	mapfile -t installed_pkgs < <(pacman -Qq | sort)

	# write intersection of pkgs_conf and actually-installed packages
	comm -12 <(printf "%s\n" "${pkgs_conf[@]}" | sort) \
	         <(printf "%s\n" "${installed_pkgs[@]}") \
	         > "$pkgs_path/pkgs.lock"

	printf "Packages versioned\n"
}


setup() {
	if [[ ! -f "$pkgs_path/pkgs.conf" ]]; then
		printf "Error: pkgs.conf not found.\n"
		return 1
	fi
	if [[ ! -f "$pkgs_path/pkgs.lock" ]]; then
		printf "Generating lock file...\n"
		touch "$pkgs_path/pkgs.lock"
	fi

	add_pkgs pkgs_conf "$pkgs_path/pkgs.conf"
	# #   de-duplicate packages
	mapfile -t pkgs_conf < <(printf "%s\n" "${pkgs_conf[@]}" | sort -u)
	add_pkgs pkgs_lock "$pkgs_path/pkgs.lock"

	add_pkgs added_pkgs <(comm -23 <(printf "%s\n" "${pkgs_conf[@]}") \
		                       <(printf "%s\n" "${pkgs_lock[@]}"))
	add_pkgs removed_pkgs <(comm -13 <(printf "%s\n" "${pkgs_conf[@]}") \
		                         <(printf "%s\n" "${pkgs_lock[@]}"))
}

main() {
	setup

	if [[ "${#added_pkgs[@]}" -eq 0 && "${#removed_pkgs[@]}" -eq 0 ]]; then
		printf "No changes found\n"
		return 0
	fi

	printf "Added:\n"
	printf "    %s\n" "${#added_pkgs[@]}"
	printf "    %s\n" "${added_pkgs[@]}"

	printf "Removed:\n"
	printf "    %s\n" "${#removed_pkgs[@]}"
	printf "    %s\n" "${removed_pkgs[@]}"

	read -rp "Proceed with changes? [y/n] " ans
	[[ $ans != [Yy] ]] && return 0

	# remove
	if [[ "${#removed_pkgs[@]}" -ne 0 ]]; then
		printf "Removing...\n"
		sudo pacman -Rns "${removed_pkgs[@]}"
	fi

	if [[ "${#added_pkgs[@]}" -ne 0 ]]; then
		printf "Updating...\n"
		sudo pacman -Syu || return 1
		printf "Installing...\n"
		sudo pacman -S --needed "${added_pkgs[@]}"
	fi

	lock_pkgs
}

main
