rm -rf ~/.config/zsh
rm -f ~/.zshrc
rm -f ~/.zshenv
rm -rf ~/.config/nvim

ln -s ~/dotfiles/zsh/.zshenv ~/.zshenv
ln -s ~/dotfiles/zsh ~/.config/zsh
ln -s ~/dotfiles/nvim ~/.config/nvim
