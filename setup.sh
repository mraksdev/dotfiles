#!/bin/bash

# Script to setup symlinks for dotfiles
# This script should be located in the root of the dotfiles directory

# Get the directory where this script is located (dotfiles directory)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/backup/dotfiles"

echo "Using dotfiles directory: $DOTFILES_DIR"

echo "Setting up symlinks from $DOTFILES_DIR..."

# Backup and remove existing config files and directories
# If it's a symlink, just delete it. Otherwise, back it up.
BACKUP_TIMESTAMP=""

# Check if any backups will be needed
needs_backup() {
  ([ -f "$1" ] && ! [ -L "$1" ]) || ([ -d "$1" ] && ! [ -L "$1" ])
}

# Create backup directory only if needed
if needs_backup "$CONFIG_DIR/zsh" || needs_backup "$HOME/.zshrc" || \
   needs_backup "$HOME/.zshenv" || needs_backup "$CONFIG_DIR/nvim" || \
   needs_backup "$CONFIG_DIR/tmux"; then
  mkdir -p "$BACKUP_DIR"
  BACKUP_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
  echo "Existing configurations found. Creating backups..."
fi

if [ -L "$CONFIG_DIR/zsh" ]; then
  echo "Removing symlink $CONFIG_DIR/zsh..."
  rm "$CONFIG_DIR/zsh"
elif [ -d "$CONFIG_DIR/zsh" ]; then
  echo "Backing up $CONFIG_DIR/zsh..."
  mv "$CONFIG_DIR/zsh" "$BACKUP_DIR/zsh_$BACKUP_TIMESTAMP"
fi

if [ -L "$HOME/.zshrc" ]; then
  echo "Removing symlink $HOME/.zshrc..."
  rm "$HOME/.zshrc"
elif [ -f "$HOME/.zshrc" ]; then
  echo "Backing up $HOME/.zshrc..."
  mv "$HOME/.zshrc" "$BACKUP_DIR/.zshrc_$BACKUP_TIMESTAMP"
fi

if [ -L "$HOME/.zshenv" ]; then
  echo "Removing symlink $HOME/.zshenv..."
  rm "$HOME/.zshenv"
elif [ -f "$HOME/.zshenv" ]; then
  echo "Backing up $HOME/.zshenv..."
  mv "$HOME/.zshenv" "$BACKUP_DIR/.zshenv_$BACKUP_TIMESTAMP"
fi

if [ -L "$CONFIG_DIR/nvim" ]; then
  echo "Removing symlink $CONFIG_DIR/nvim..."
  rm "$CONFIG_DIR/nvim"
elif [ -d "$CONFIG_DIR/nvim" ]; then
  echo "Backing up $CONFIG_DIR/nvim..."
  mv "$CONFIG_DIR/nvim" "$BACKUP_DIR/nvim_$BACKUP_TIMESTAMP"
fi

if [ -L "$CONFIG_DIR/tmux" ]; then
  echo "Removing symlink $CONFIG_DIR/tmux..."
  rm "$CONFIG_DIR/tmux"
elif [ -d "$CONFIG_DIR/tmux" ]; then
  echo "Backing up $CONFIG_DIR/tmux..."
  mv "$CONFIG_DIR/tmux" "$BACKUP_DIR/tmux_$BACKUP_TIMESTAMP"
fi

if [ -n "$BACKUP_TIMESTAMP" ]; then
  echo "Configurations backed up to $BACKUP_DIR"
fi

# Verify subdirectories exist before linking
echo "Verifying dotfiles structure..."
for dir in "zsh" "nvim" "tmux"; do
  if [ ! -d "$DOTFILES_DIR/$dir" ]; then
    echo "Warning: $DOTFILES_DIR/$dir not found, skipping..."
    continue
  fi
done

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Create symlinks
echo "Creating symlinks..."
ln -s "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
ln -s "$DOTFILES_DIR/zsh" "$CONFIG_DIR/zsh"
ln -s "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"
ln -s "$DOTFILES_DIR/tmux" "$CONFIG_DIR/tmux"
ln -s "$DOTFILES_DIR/lf" "$CONFIG_DIR/lf"

echo "Setup complete!"
