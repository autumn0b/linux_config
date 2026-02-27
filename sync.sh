# config files
cp $HOME/.zshrc $HOME/sync/backup/
cp -r $HOME/.config/foot/ $HOME/sync/backup/
cp -r $HOME/.config/hypr/ $HOME/sync/backup/
cp -r $HOME/.config/nvim/ $HOME/sync/backup/
cp -r $HOME/.config/rofi/ $HOME/sync/backup/
cp -r $HOME/.config/waybar/ $HOME/sync/backup/
cp -r $HOME/.config/yazi/ $HOME/sync/backup/
cp -r $HOME/.config/zellij/ $HOME/sync/backup/

# other
mkdir -p $HOME/sync/backup/factorio/
cp $HOME/.factorio/config/config.ini $HOME/sync/backup/factorio/
