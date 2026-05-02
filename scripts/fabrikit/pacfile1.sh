#!/usr/bin/env bash
set -euo pipefail


fkit_path="$HOME/.config/fabrikit"

conf_pkgs=()
# packages are only added to the lock file if installed
lock_pkgs=()

warn_pkgs=()
installed_pkgs=()


added_pkgs=()
removed_pkgs=()


print_pkgs()
{
	printf "%s\n" "$@" | sed '/^$/d'
}


debug_print()
{
	local -n _arr=$1
	local i
	for i in "${!_arr[@]}"; do
		printf "[%s] %s\n" "$i" "${_arr[$i]}"
	done
}


pacf_remove()
{
	local pkg
	for pkg in "$@"; do
		pacman -Si "$pkg" &> /dev/null || {
			printf "\e[31m%s\e[0m\n" "* '$pkg' is invalid"
			return 1
		}

		grep -qxF "$pkg" "$fkit_path/pkgs.lock" || {
			(printf "\e[31m%s\e[0m\n" "* '$pkg' not found"
			return 1)
		}

		sed -i "/^$pkg$/d" "$fkit_path/pkgs.lock"
		printf "removed '%s'\n" "$pkg"
	done
}


pacf_exit()
{

	if [[ "${#warn_pkgs[@]}" -gt 0 ]]; then
		printf "\e[33m%s\e[0m\n" "# warning: package(s) resolved"

		local warn_fix=()
		mapfile -t warn_fix < <(print_pkgs "${warn_pkgs[@]}" \
			| xargs pacman -Spdd --print-format "%n" | sort -u)

		local i
		for i in "${!warn_pkgs[@]}"; do
			printf "%s => %s\n" "${warn_pkgs[$i]}" "${warn_fix[$i]}"
		done
		printf "\n"
	fi

	if [[ "${#added_pkgs[@]}" -lt 1 && "${#removed_pkgs[@]}" -lt 1 ]]; then
		printf "\e[36m%s\e[0m\n" "# no changes found"
	fi

}


display_changes()
{
	if [[ "${#added_pkgs[@]}" -eq 0 && "${#removed_pkgs[@]}" -eq 0 ]]; then
		return 0
	fi

	printf "\e[36m%s\e[0m\n" "# changes found..."
	if [[ "${#removed_pkgs[@]}" -ne 0 ]]; then
		printf -- "- removed: %s\n" "${#removed_pkgs[@]}"
		printf "\t%s\n" "${removed_pkgs[@]}" | column
	fi
	if [[ "${#added_pkgs[@]}" -ne 0 ]]; then
		printf -- "- added: %s\n" "${#added_pkgs[@]}"
		printf "\t%s\n" "${added_pkgs[@]}" | column
	fi
	printf "\n"
}


display_versioned()
{
	local included_pkgs=()
	mapfile -t included_pkgs < <(comm -12    \
		<(print_pkgs "${added_pkgs[@]}") \
		<(print_pkgs "${installed_pkgs[@]}"))
	mapfile -t included_pkgs < <(comm -23       \
		<(print_pkgs "${included_pkgs[@]}") \
		<(print_pkgs "${lock_pkgs[@]}"))

	local dropped_pkgs=()
	mapfile -t dropped_pkgs < <(comm -23    \
		<(print_pkgs "${lock_pkgs[@]}") \
		<(print_pkgs "${installed_pkgs[@]}"))

	if [[ "${#dropped_pkgs[@]}" -lt 1 && "${#included_pkgs[@]}" -lt 1 ]]; then
		return 0
	fi

	printf "\e[36m%s\e[0m\n" "# now tracking..."
	if [[ "${#dropped_pkgs[@]}" -gt 0 ]]; then
		# lock = lock - dropped
		printf -- "- dropped: %s\n" "${#dropped_pkgs[@]}"
		printf "\t%s\n" "${dropped_pkgs[@]}" | column
	fi
	if [[ "${#included_pkgs[@]}" -gt 0 ]]; then
		# lock = lock + included
		printf -- "- included: %s\n" "${#included_pkgs[@]}"
		printf "    %s\n" "${included_pkgs[@]}" | column
	fi
	printf "\n"
}


version_pkgs()
{
	mapfile -t installed_pkgs < <(pacman -Qq | sort)

	# check if any pkgs in lock are not installed and remove them
	local arr=()
	mapfile -t arr < <(comm -23             \
		<(print_pkgs "${lock_pkgs[@]}") \
		<(print_pkgs "${installed_pkgs[@]}"))
	if [[ "${#arr[@]}" -gt 0 ]]; then
		local pkg
		for pkg in "${arr[@]}"; do
			pacf_remove "$pkg"
		done
	fi

	local conf_and_installed=()
	mapfile -t conf_and_installed < <(comm -12 \
		<(print_pkgs "${conf_pkgs[@]}")    \
		<(print_pkgs "${installed_pkgs[@]}"))

	# removed_pkgs are still tracked unless uninstalled
	local lock_and_installed=()
	mapfile -t lock_and_installed < <(comm -12 \
		<(print_pkgs "${lock_pkgs[@]}")    \
		<(print_pkgs "${installed_pkgs[@]}"))

	print_pkgs "${conf_and_installed[@]}" "${lock_and_installed[@]}"\
		| sort -u > "$fkit_path/pkgs.lock"

	display_versioned
}


# example : pacman resolves glfw-wayland to glfw, but comm doesn't match the
# 	differing names so it never gets added to pkgs.lock
# pacman resolves package names before adding to conf_pkgs
get_conf_pkgs()
{
	mapfile -t pre_conf_pkgs < <(
		sed -e 's/[[:space:]]*#.*//g' "$fkit_path/pkgs.conf" \
		| tr -s '[:space:]' '\n'                             \
		| sed '/^$/d'                                        \
		| sort -u)

	mapfile -t conf_pkgs < <(
		print_pkgs "${pre_conf_pkgs[@]}"         \
		| xargs pacman -Spdd --print-format "%n" \
		| sort -u)

	mapfile -t warn_pkgs < <(comm -23           \
		<(print_pkgs "${pre_conf_pkgs[@]}") \
		<(print_pkgs "${conf_pkgs[@]}"))
}


init_pkgs()
{
	# read from pkgs.conf and pkgs.lock to check for
	# current pacfile state and user changes
	get_conf_pkgs
	mapfile -t lock_pkgs < <(sort -u "$fkit_path/pkgs.lock")

	mapfile -t added_pkgs < <(comm -23      \
		<(print_pkgs "${conf_pkgs[@]}") \
		<(print_pkgs "${lock_pkgs[@]}"))
	mapfile -t removed_pkgs < <(comm -13    \
		<(print_pkgs "${conf_pkgs[@]}") \
		<(print_pkgs "${lock_pkgs[@]}"))

	# update pkgs.lock to reflect discrepencies in system state before making changes
	#   relevant if packages were installed or uninstalled outside of the script
	version_pkgs

	# re-read from pkgs.lock after updates
	mapfile -t lock_pkgs < <(sort -u "$fkit_path/pkgs.lock")

	mapfile -t added_pkgs < <(comm -23      \
		<(print_pkgs "${conf_pkgs[@]}") \
		<(print_pkgs "${lock_pkgs[@]}"))
	mapfile -t removed_pkgs < <(comm -13    \
		<(print_pkgs "${conf_pkgs[@]}") \
		<(print_pkgs "${lock_pkgs[@]}"))
}


modify_system()
{
	# remove
	if [[ "${#removed_pkgs[@]}" -ne 0 ]]; then
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
		printf "\n"
	fi
}


pacf_update()
{
	init_pkgs

	display_changes

	modify_system

	version_pkgs

	pacf_exit
}


pacf_checks()
{
	if command -v pacman > /dev/null; then
		printf "\e[31m%s\e[0m\n" "* pacman not found"
		return 1
	fi

	if [[ ! -d "$fkit_path" ]]; then
		printf "\e[31m%s\e[0m\n" "* fkit_path not found: $fkit_path"
		return 1
	fi
	# check if files exist
	if [[ ! -f "$fkit_path/pkgs.conf" ]]; then
		printf "\e[31m%s\e[0m\n" "* config not found"
		return 1
	fi
	if [[ ! -f "$fkit_path/pkgs.lock" ]]; then
		printf "\e[36m%s\e[0m\n" "# creating lock file..."
		touch "$fkit_path/pkgs.lock"
	fi
}


main()
{
	pacf_checks

	if [[ "$#" -eq 0 ]]; then
		pacf_update
		return
	fi

	if [[ "$1" == r ]]; then
		pacf_remove "${@:2}"
	else
		printf "\e[31m%s\e[0m\n" "* unknown command '$1'" >&2
		printf -- "usage: pf [r <pkg>]\n" >&2
		exit 1
	fi
}

main "$@"
