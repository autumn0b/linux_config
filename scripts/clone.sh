mkdir -p ~/.config/

cp -r ~/sync/linux_config/hypr/ ~/.config/
cp -r ~/sync/linux_config/waybar/ ~/.config/
cp -r ~/sync/linux_config/rofi/ ~/.config/

cp -r ~/sync/linux_config/ghostty/ ~/.config/
cp -r ~/sync/linux_config/nvim/ ~/.config/
cp ~/sync/linux_config/.zshrc ~/.zshrc

printf "Warning: { nix, reaper, and factorio } config files are not automatically copied\n"

sudo mkdir -p /etc/keyd/
sudo cp -r ~/sync/linux_config/keyd/ /etc/
