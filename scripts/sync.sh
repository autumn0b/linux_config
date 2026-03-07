# config files
printf "copying config files:\n"

# zsh
cp ~/.zshrc                       ~/sync/linux_config/
printf "  zsh cp\n\n"


# foot
if [ -d "$HOME/sync/linux_config/foot/" ]; then
	rm -r ~/sync/linux_config/foot/
	printf "  foot rm\n"
fi
cp -r ~/.config/foot/             ~/sync/linux_config/
printf "  foot cp\n\n"


# ghostty
if [ -d "$HOME/sync/linux_config/ghostty/" ]; then
	rm -r ~/sync/linux_config/ghostty/
	printf "  ghostty rm\n"
fi
cp -r ~/.config/ghostty/             ~/sync/linux_config/
printf "  ghostty cp\n\n"


# hypr
if [ -d "$HOME/sync/linux_config/hypr/" ]; then
	rm -r ~/sync/linux_config/hypr/
	printf "  hypr rm\n"
fi
cp -r ~/.config/hypr/             ~/sync/linux_config/
printf "  hypr cp\n\n"


# nvim
if [ -d "$HOME/sync/linux_config/nvim/" ]; then
	rm -r ~/sync/linux_config/nvim/
	printf "  nvim rm\n"
fi
cp -r ~/.config/nvim/             ~/sync/linux_config/
printf "  nvim cp\n\n"


# rofi
if [ -d "$HOME/sync/linux_config/rofi/" ]; then
	rm -r ~/sync/linux_config/rofi/
	printf "  rofi rm\n"
fi
cp -r ~/.config/rofi/             ~/sync/linux_config/
printf "  rofi cp\n\n"


# waybar
if [ -d "$HOME/sync/linux_config/waybar/" ]; then
	rm -r ~/sync/linux_config/waybar/
	printf "  waybar rm\n"
fi
cp -r ~/.config/waybar/           ~/sync/linux_config/
printf "  waybar cp\n\n"


# yazi
if [ -d "$HOME/sync/linux_config/yazi/" ]; then
	rm -r ~/sync/linux_config/yazi/
	printf "  yazi rm\n"
fi
cp -r ~/.config/yazi/             ~/sync/linux_config/
printf "  yazi cp\n\n"


# zellij
if [ -d "$HOME/sync/linux_config/zellij/" ]; then
	rm -r ~/sync/linux_config/zellij/
	printf "  zellij rm\n"
fi
cp -r ~/.config/zellij/           ~/sync/linux_config/
printf "  zellij cp\n\n"


# factorio
if [ -d "$HOME/sync/linux_config/factorio/" ]; then
	rm -r ~/sync/linux_config/factorio/
	printf "  factorio rm\n"
fi
mkdir -p ~/sync/linux_config/factorio/
cp ~/.factorio/config/config.ini  ~/sync/linux_config/factorio/
printf "  factorio cp\n\n"


# reaper
cp ~/.config/REAPER/reaper-kb.ini ~/sync/linux_config/
printf "  reaper cp\n\n"


# keyd
if [ -d "$HOME/sync/linux_config/keyd/" ]; then
	sudo rm -rf ~/sync/linux_config/keyd/
	printf "  keyd rm\n"
fi
cp -r /etc/keyd/                 ~/sync/linux_config/
printf "  keyd cp\n\n"


# nixos
if [ -d "/etc/nixos/" ]; then
	sudo cp -r /etc/nixos/configuration.nix ~/sync/linux_config/
	printf "  nixos cp\n\n"
fi

echo "complete\n"
