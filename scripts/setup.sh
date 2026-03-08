mkdir -p ~/sync/
mv ~/linux_config/ ~/sync/

~/sync/linux_config/scripts/loadc.sh

tldr --update
sudo systemctl enable keyd --now
sudo keyd reload

git config --global user.email "nel.malachi@proton.me"
git config --global user.name "autumn0b"
