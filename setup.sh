rm -rf ~/.config/zsh
rm -f ~/.zshrc
rm -f ~/.zshenv
rm -rf ~/.config/nvim
rm -rf ~/.config/tmux

ln -s ~/dotfiles/zsh/.zshenv ~/.zshenv
ln -s ~/dotfiles/zsh ~/.config/zsh
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/tmux ~/.config/tmux
