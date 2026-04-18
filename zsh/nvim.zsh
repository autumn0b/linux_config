alias nvplugs="nvim $HOME/.local/share/nvim/site/pack/all/"
alias snv="sudo -E nvim" # [s]udo [nv]im


nv() {
	if [[ -z "$1" ]]; then
		nvim "$(fd . $HOME | fzf)"
	else
		nvim $1
	fi
}

# ~/.local/share/nvim/site/pack
#     -> ./plugins   # any name I choose
#         -> ./start # loaded on startup
#         -> ./opt   # loaded with `:packadd`
#
# [i]nstall plugins
nvimi() {
	local pack_path="$HOME/.local/share/nvim/site/pack/all"
	rm -rf "$HOME/.local/share/nvim/site/pack/all/start/"
	mkdir -p "$pack_path/start"

	# auto pairs
	git clone \
		https://github.com/windwp/nvim-autopairs \
		$pack_path/start/auto_pairs

	# auto save
	git clone \
		https://github.com/Pocco81/auto-save.nvim \
		$pack_path/start/auto_save

	# cmp
	git clone -b v1 \
		https://github.com/Saghen/blink.cmp \
		$pack_path/start/blink_cmp
	cargo build --release --manifest-path $pack_path/start/blink_cmp/Cargo.toml

	# lsp
	git clone \
		https://github.com/neovim/nvim-lspconfig \
		$pack_path/start/nvim_lspconfig

	# mini

	#   ai
	git clone \
		https://github.com/nvim-mini/mini.ai \
		$pack_path/start/mini_ai

	#   surround
	git clone \
		https://github.com/nvim-mini/mini.surround \
		$pack_path/start/mini_surround

	#   tabline
	git clone \
		https://github.com/nvim-mini/mini.tabline \
		$pack_path/start/mini_tabline

	#   files
	git clone \
		https://github.com/nvim-mini/mini.files \
		$pack_path/start/mini_files

	#   move
	git clone \
		https://github.com/nvim-mini/mini.move \
		$pack_path/start/mini_move

	#   statusline
	git clone \
		https://github.com/nvim-mini/mini.statusline \
		$pack_path/start/mini_statusline

	# color schemes
	git clone \
		https://github.com/EdenEast/nightfox.nvim \
		$pack_path/start/nightfox

	git clone \
		https://github.com/rose-pine/neovim \
		$pack_path/start/rose_pine
}


nvima() {
	local pack_path="$HOME/.local/share/nvim/site/pack/all"

	# auto pairs
	git clone \
		https://github.com/windwp/nvim-autopairs \
		$pack_path/start/auto_pairs

	# auto save
	git clone \
		https://github.com/Pocco81/auto-save.nvim \
		$pack_path/start/auto_save

	# cmp
	git clone -b v1 \
		https://github.com/Saghen/blink.cmp \
		$pack_path/start/blink_cmp
	cargo build --release --manifest-path $pack_path/start/blink_cmp/Cargo.toml

	# lsp
	git clone \
		https://github.com/neovim/nvim-lspconfig \
		$pack_path/start/nvim_lspconfig

	# mini

	#   ai
	git clone \
		https://github.com/nvim-mini/mini.ai \
		$pack_path/start/mini_ai

	#   surround
	git clone \
		https://github.com/nvim-mini/mini.surround \
		$pack_path/start/mini_surround

	#   tabline
	git clone \
		https://github.com/nvim-mini/mini.tabline \
		$pack_path/start/mini_tabline

	#   files
	git clone \
		https://github.com/nvim-mini/mini.files \
		$pack_path/start/mini_files

	#   move
	git clone \
		https://github.com/nvim-mini/mini.move \
		$pack_path/start/mini_move

	#   statusline
	git clone \
		https://github.com/nvim-mini/mini.statusline \
		$pack_path/start/mini_statusline

	# color schemes
	git clone \
		https://github.com/EdenEast/nightfox.nvim \
		$pack_path/start/nightfox

	git clone \
		https://github.com/rose-pine/neovim \
		$pack_path/start/rose_pine
}
