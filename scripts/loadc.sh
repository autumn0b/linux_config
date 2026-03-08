printf "Warning: { nix, reaper, and factorio } config files are not automatically copied\n"
cp -r ~/sync/linux_config/configs/.config/ ~/
cp ~/sync/linux_config/configs/.zshrc ~/.zshrc
sudo cp -r ~/sync/linux_config/configs/keyd/ /etc/
