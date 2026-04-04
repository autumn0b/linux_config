# -=======+=======- #
# [C]onfig [Link]er #
# -=======+=======- #

# Clean up existing configuration files or directories and create symlinks
# in their place, pointing to a central source/git directory.

# Create $HOME/.config/clink/configs.txt to bootstrap the process
#   - Specify a source direcotry before any configs
#   - A config is formated like "<src_dir>:<dest_dir>", similar to how
#     symlinks are created using the `ln -s` command
#   - If <dest_dir> is ommitted, it will default to $HOME/.config/

clink() {
	# reads in from configs.txt and assigns to array
	while IFS=: read -r config dest; do
		# ignores lines starting with '#' and blank lines
		[[ -z "$config" || "$config" == \#* ]] && continue 
		if [[ "$config" == \+* ]]; then
			local src_path=$(envsubst <<< "${config#'+'}")
			[[ ! -e "$src_path/clink" ]] && mv "$HOME/.config/clink" "$src_path/clink"
			ln -s "$src_path/clink" "$HOME/.config/clink"
			continue
		fi

		[[ -z "$src_path" ]] && printf "ERROR: src_path must be defined\n" && return 1
		link_config "$config" "${dest:-$HOME/.config/$config}" "$src_path"
	done < "$HOME/.config/clink/configs.txt"
}

link_config() {
	local config="$1"
	local dest="$2"
	local src_path="$3"

	if [[ -z "$config" ]]; then
		printf "WARNING. invalid package name\n"
		return 1
	fi

	local src="$src_path/$config"

	printf "%s:\n" "$config"

	# stop function if src doesn't exist
	#   prevents invalid symlink from getting created
	if [[ ! -e "$src" ]]; then
		printf "    ERROR. source does not exist\n"
		return 1
	fi

	# if symlink, check if valid
	if [[ -L "$dest" ]]; then
		target=$(readlink -f "$dest")
		if [[ "$target" == "$src" ]]; then
			printf "    exists\n"
		else
			printf "    invalid symlink... \n"
			if [[ ! -w "$(dirname "$dest")" ]]; then
				sudo ln -sf "$src" "$dest" && printf "    relinked\n"
			else
				ln -sf "$src" "$dest" && printf "    relinked\n"
			fi
		fi
	else
		# clean up existing file/dir before creating symlink
		if [[ -e "$dest" ]]; then
			rm -rf "$dest" && printf "    removed\n"
		fi

		if [[ ! -w "$(dirname "$dest")" ]]; then
			sudo ln -s "$src" "$dest" && printf "    created\n"
		else 
			ln -s "$src" "$dest" && printf "    created\n"
		fi
	fi
}
