# todo -> add support for AUR packages

#!/usr/bin/env bash
set -euo pipefail

declare -r RED='\e[31m'
declare -r YELLOW='\e[33m'
declare -r CYAN='\e[36m'
declare -r RESET='\e[0m'

declare -r fkit_path="$HOME/.config/fabrikit"

conf_pkgs=()
# packages are only added to the lock file if installed
lock_pkgs=()

installed_pkgs=()


added_pkgs=()
removed_pkgs=()


print_pkgs()
{
	printf "%s\n" "$@" | sed '/^$/d'
}


pacf_remove()
{
	local pkg
	for pkg in "$@"; do
		pacman -Si "$pkg" &> /dev/null || {
			printf "${RED}%s${RESET}\n" "* '$pkg' is invalid" >&2
			return 1
		}

		grep -qxF "$pkg" "$fkit_path/pkgs.lock" || {
			printf "${RED}%s${RESET}\n" "* '$pkg' not found" >&2
			return 1
		}

		sed -i "/^$pkg$/d" "$fkit_path/pkgs.lock"
		printf "removed '%s'\n" "$pkg"
	done
}


display_changes()
{
	if [[ "${#added_pkgs[@]}" -eq 0 && "${#removed_pkgs[@]}" -eq 0 ]]; then
		return 0
	fi

	printf "${CYAN}%s${RESET}\n" "# changes found..."
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

	if [[ "${#dropped_pkgs[@]}" -eq 0 && "${#included_pkgs[@]}" -eq 0 ]]; then
		return 0
	fi

	printf "${CYAN}%s${RESET}\n" "# now tracking..."
	if [[ "${#dropped_pkgs[@]}" -gt 0 ]]; then
		# lock = lock - dropped
		printf -- "- dropped: %s\n" "${#dropped_pkgs[@]}"
		printf "\t%s\n" "${dropped_pkgs[@]}" | column
	fi
	if [[ "${#included_pkgs[@]}" -gt 0 ]]; then
		# lock = lock + included
		printf -- "- included: %s\n" "${#included_pkgs[@]}"
		printf "\t%s\n" "${included_pkgs[@]}" | column
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
			sed -i "/^$pkg$/d" "$fkit_path/pkgs.lock"
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

	local temp
	temp=$(mktemp)
	print_pkgs "${conf_and_installed[@]}" "${lock_and_installed[@]}"\
		| sort -u > "$temp" && mv "$temp" "$fkit_path/pkgs.lock"

	display_versioned
}


init_pkgs()
{
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
		printf "${CYAN}%s${RESET}\n" "# removing..."
		sudo pacman -Rns "${removed_pkgs[@]}"
	fi

	# update and install
	if [[ "${#added_pkgs[@]}" -ne 0 ]]; then
		# separate update and install steps to distinguish
		# script-managed packages from update dependencies
		printf "${CYAN}%s${RESET}\n" "# updating..."
		sudo pacman -Syu
		printf "\n"

		printf "${CYAN}%s${RESET}\n" "# installing..."
		# let pacman handle invalid package names
		sudo pacman -S --needed "${added_pkgs[@]}"
		printf "\n"
	fi
}


validate_pkgs()
{
	declare -A db
	while IFS= read -r pkg; do
		db["$pkg"]=1
	done < <(pacman -Sql)

	for pkg in "${added_pkgs[@]}"; do
		[[ -v db["$pkg"] ]] || {
			printf "${RED}%s${RESET}\n" "* '$pkg' is invalid" >&2
			return 1
		}
	done

}


pacf_update()
{
	# read from pkgs.conf and pkgs.lock to check for
	# current pacfile state and user changes
	mapfile -t conf_pkgs < <(
		sed -e 's/[[:space:]]*#.*//g' "$fkit_path/pkgs.conf" \
		| tr -s '[:space:]' '\n'                             \
		| sed '/^$/d'                                        \
		| sort -u)
	
	init_pkgs

	if [[ "${#added_pkgs[@]}" -eq 0 && "${#removed_pkgs[@]}" -eq 0 ]]; then
		printf "${CYAN}%s${RESET}\n" "# no changes found"
	fi

	if [[ "${#added_pkgs[@]}" -gt 0 ]]; then
		validate_pkgs
	fi

	# update pkgs.lock to reflect discrepencies in system state before making changes
	#   relevant if packages were installed or uninstalled outside of the script
	version_pkgs

	# re-read from pkgs.lock after updates
	init_pkgs

	display_changes

	modify_system

	version_pkgs
}


pacf_checks()
{
	if ! command -v pacman > /dev/null; then
		printf "${RED}%s${RESET}\n" "* pacman not found" >&2
	 	return 1
	fi
	if ! command -v sudo > /dev/null; then
		printf "${RED}%s${RESET}\n" "* sudo not found" >&2
		return 1
	fi

	if [[ ! -d "$fkit_path" ]]; then
		printf "${RED}%s${RESET}\n" "* fkit_path not found: $fkit_path" >&2
		return 1
	fi
	# check if files exist
	if [[ ! -f "$fkit_path/pkgs.conf" ]]; then
		printf "${RED}%s${RESET}\n" "* config not found" >&2
		return 1
	fi
	if [[ ! -f "$fkit_path/pkgs.lock" ]]; then
		printf "${CYAN}%s${RESET}\n" "# creating lock file..."
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
		printf "${RED}%s${RESET}\n" "* unknown command '$1'" >&2
		printf -- "usage: pf [r <pkg>]\n" >&2
		exit 1
	fi
}

main "$@"
