# -=======+=======- #
# [c]onfig [link]er #
# -=======+=======- #

# Move or delete existing configuration files and automatically
# create symlinks in their place, pointing to a specified target directory.

# .../target_path/target_name <-- .../link_path
# +/target_path
# config {target:link_path}
set -euo pipefail


fkit_path="$HOME/.config/fabrikit"

link_configs() {
	[[ ! -e $fkit_path/links.conf ]] && echo \
		"error: missing links.conf file" && return 1

	while IFS=' ' read -r target_name link_path; do
		# skip blank lines and comments
		[[ -z "$target_name" || "$target_name" == \#* ]] && continue
		# assign source_path and skip line
		if [[ "$target_name" == +* ]]; then
			local target_path=""
			target_path=$(envsubst <<< "${target_name#'+'}")
			continue
		fi

		[[ -z "$target_path" ]] && \
			echo "error: target_path must be defined before links" && \
			return 1
		[[ "$target_path" == */ ]] && \
			echo "error: target_path must not end with a '/'" && \
			return 1
		link_curr_config "$target_name" "$target_path" "${link_path:-$HOME/.config/$target_name}"
	done < "$fkit_path/links.conf"
}

link_curr_config() {
	local target_name="$1"
	local target_path="$2/$1"
	local link_path="$3"

	echo "$target_name"

	# if symlink
	if [[ -L $link_path ]]; then 
		curr_target=$(realpath "$link_path")
		# exit if valid
		if [[ "$curr_target" == "$target_path" ]]; then
			echo "    link exists"
			return 0
		fi

		# relink if invalid
		echo "    invalid link"
		test_sudo "$(dirname "$link_path")" \
			ln -sf "$target_path" "$link_path"
		echo "    relinked"
		return 0
	fi

	# if file/dir
	if [[ -e $link_path ]]; then
		prompt_del "$target_path" "$link_path" && return 0
		prompt_move "$target_path" "$link_path" && return 0

		echo "    warning: cannot create link, file exists"
		return 0
	fi

	# no file or directory, good to create new symlink
	test_sudo "$(dirname "$link_path")" \
		ln -sf "$target_path" "$link_path"
	echo "    linked"
}

prompt_del() {
	local target_path="$1"
	local link_path="$2"

	echo "    file or directory already exists: $link_path" 
	read -p "    delete the config on the link_path? [y/n] " ans < /dev/tty
	if [[ "$ans" == y ]]; then
		if [[ -z "$link_path" || "$link_path" == "/" ]]; then
			echo "error: unsafe link_path"
			return 1
		fi

		test_sudo "$(dirname "$link_path")" \
			rm -rf "$link_path"
		echo "    deleted"
		test_sudo "$(dirname "$link_path")" \
			ln -sf "$target_path" "$link_path"
		echo "    linked"
		return 0
	fi
	return 1
}

prompt_move() {
	local target_path="$1"
	local link_path="$2"

	read -p "    move the config to the target_path? [y/n] " ans < /dev/tty
	if [[ "$ans" == y ]]; then
		test_sudo "$(dirname "$link_path")" \
			mv "$link_path" "$target_path"
		echo "    moved"
		test_sudo "$(dirname "$link_path")" \
			ln -sf "$target_path" "$link_path"
		echo "    linked"
		return 0
	fi
	return 1
}

test_sudo() {
    local dir="$1"
    shift
    if [[ ! -w "$dir" ]]; then
        sudo "$@"
    else
        "$@"
    fi
}

link_configs
