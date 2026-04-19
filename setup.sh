#!/bin/bash

# ==============================================================================
# Dotfiles Symlink Setup Script (Pretty & Verbose Edition)
# ==============================================================================
# This script safely backs up existing configs and creates symlinks to the
# dotfiles repository. It provides detailed, formatted output with colors.
# ==============================================================================

set -e  # Exit on error (can be removed if partial execution preferred)

# --- Terminal Formatting ------------------------------------------------------
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Text styles
BOLD='\033[1m'
DIM='\033[2m'
UNDERLINE='\033[4m'

# Symbols (text only, no emoji)
SYM_OK="[OK]"
SYM_WARN="[WARN]"
SYM_ERROR="[ERR]"
SYM_INFO="->"
SYM_BACKUP="[BACKUP]"
SYM_LINK="[LINK]"
SYM_DIR="[DIR]"
SYM_FILE="[FILE]"

# --- Helper Functions ---------------------------------------------------------
print_separator() {
    echo -e "${DIM}──────────────────────────────────────────────────────────────────────${NC}"
}

print_header() {
    echo -e "\n${BOLD}${WHITE}${1}${NC}"
    print_separator
}

print_success() {
    echo -e "${GREEN}${SYM_OK} ${1}${NC}"
}

print_error() {
    echo -e "${RED}${SYM_ERROR} ${1}${NC}"
}

print_warning() {
    echo -e "${YELLOW}${SYM_WARN} ${1}${NC}"
}

print_info() {
    echo -e "${BLUE}${SYM_INFO} ${1}${NC}"
}

print_path_info() {
    echo -e "  ${DIM}${SYM_DIR} $1${NC}"
}

print_backup_info() {
    echo -e "  ${YELLOW}${SYM_BACKUP} $1 -> $2${NC}"
}

print_link_info() {
    echo -e "  ${CYAN}${SYM_LINK} $1 -> $2${NC}"
}

# Check if path needs backup (exists as regular file/dir, not a symlink)
needs_backup() {
    ([ -f "$1" ] && ! [ -L "$1" ]) || ([ -d "$1" ] && ! [ -L "$1" ])
}

# Process a configuration path: remove symlink or backup regular file/dir
process_path() {
    local path="$1"
    local name="$2"

    if [ -L "$path" ]; then
        print_warning "Removing existing symlink: $path"
        rm -v "$path" | sed 's/^/    /'
    elif [ -d "$path" ]; then
        local backup_name="${name}_${BACKUP_TIMESTAMP}"
        print_backup_info "$path" "$BACKUP_DIR/$backup_name"
        mkdir -p "$BACKUP_DIR"
        mv -v "$path" "$BACKUP_DIR/$backup_name" | sed 's/^/    /'
    elif [ -f "$path" ]; then
        local backup_name="${name}_${BACKUP_TIMESTAMP}"
        print_backup_info "$path" "$BACKUP_DIR/$backup_name"
        mkdir -p "$BACKUP_DIR"
        mv -v "$path" "$BACKUP_DIR/$backup_name" | sed 's/^/    /'
    else
        print_info "No existing item at $path"
    fi
}

# Create a symlink with verbose output
create_symlink() {
    local src="$1"
    local dst="$2"
    local desc="$3"

    print_info "Creating symlink for ${BOLD}${desc}${NC}"
    print_link_info "$dst" "$src"
    if ln -s -v "$src" "$dst" | sed 's/^/    /'; then
        print_success "Symlink created successfully."
    else
        print_error "Failed to create symlink $dst"
        exit 1
    fi
    echo
}

# --- Main Script --------------------------------------------------------------
clear  # Optional: start with a clean screen

echo -e "${BOLD}${MAGENTA}"
echo "  +======================================================================+"
echo "  |                 DOTFILES SYMLINK SETUP SCRIPT                         |"
echo "  +======================================================================+"
echo -e "${NC}"

# --- Variables ----------------------------------------------------------------
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/backup/dotfiles"
BACKUP_TIMESTAMP=""
BACKUP_NEEDED=false

print_header "ENVIRONMENT INFORMATION"
print_info "Dotfiles directory : ${BOLD}$DOTFILES_DIR${NC}"
print_info "Config directory   : ${BOLD}$CONFIG_DIR${NC}"
print_info "Backup directory   : ${BOLD}$BACKUP_DIR${NC}"

# --- Ensure config directory exists early -------------------------------------
print_header "PREPARING TARGET DIRECTORY"
print_info "Ensuring ${BOLD}$CONFIG_DIR${NC} exists..."
mkdir -p -v "$CONFIG_DIR" | sed 's/^/    /'
print_success "Target directory is ready."

# --- Pre-check: Source directories existence ----------------------------------
print_header "VERIFYING SOURCE STRUCTURE"
declare -a REQUIRED_DIRS=("zsh" "nvim" "tmux" "lf")
declare -a missing_dirs=()

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$DOTFILES_DIR/$dir" ]; then
        print_success "Found source directory: ${BOLD}$dir${NC}"
    else
        print_error "Missing source directory: $dir"
        missing_dirs+=("$dir")
    fi
done

if [ ${#missing_dirs[@]} -gt 0 ]; then
    echo
    print_error "Missing required directories in dotfiles: ${missing_dirs[*]}"
    print_error "Cannot proceed. Please ensure all directories exist."
    exit 1
fi

if [ ! -f "$DOTFILES_DIR/zsh/.zshenv" ]; then
    print_error "Missing required file: zsh/.zshenv"
    exit 1
fi
print_success "All required files and directories are present."

# --- Check existing configurations and prepare backup -------------------------
print_header "CHECKING EXISTING CONFIGURATIONS"
declare -a TARGETS=(
    "$CONFIG_DIR/zsh"
    "$HOME/.zshrc"
    "$HOME/.zshenv"
    "$CONFIG_DIR/nvim"
    "$CONFIG_DIR/tmux"
    "$CONFIG_DIR/lf"
)

for target in "${TARGETS[@]}"; do
    if needs_backup "$target"; then
        print_warning "Regular file/directory found: $target (will be backed up)"
        BACKUP_NEEDED=true
    elif [ -L "$target" ]; then
        print_info "Existing symlink: $target (will be replaced)"
    elif [ -e "$target" ]; then
        print_warning "Unknown type at $target (will be backed up)"
        BACKUP_NEEDED=true
    else
        print_info "No existing item at $target"
    fi
done

if [ "$BACKUP_NEEDED" = true ]; then
    BACKUP_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    print_info "Backup timestamp: ${BOLD}$BACKUP_TIMESTAMP${NC}"
fi
echo

# --- Process existing configurations (backup/remove) --------------------------
print_header "PROCESSING EXISTING CONFIGURATIONS"
process_path "$CONFIG_DIR/zsh" "zsh"
process_path "$HOME/.zshrc" ".zshrc"
process_path "$HOME/.zshenv" ".zshenv"
process_path "$CONFIG_DIR/nvim" "nvim"
process_path "$CONFIG_DIR/tmux" "tmux"
process_path "$CONFIG_DIR/lf" "lf"

if [ -n "$BACKUP_TIMESTAMP" ]; then
    echo
    print_success "Backups saved to: ${BOLD}$BACKUP_DIR${NC}"
fi

# --- Create symlinks ----------------------------------------------------------
print_header "CREATING SYMLINKS"
create_symlink "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv" "Zsh environment (.zshenv)"
create_symlink "$DOTFILES_DIR/zsh" "$CONFIG_DIR/zsh" "Zsh configuration directory"
create_symlink "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim" "Neovim configuration"
create_symlink "$DOTFILES_DIR/tmux" "$CONFIG_DIR/tmux" "Tmux configuration"
create_symlink "$DOTFILES_DIR/lf" "$CONFIG_DIR/lf" "Lf file manager configuration"

# --- Final Summary ------------------------------------------------------------
print_separator
echo -e "${GREEN}${BOLD}${SYM_OK} SETUP COMPLETED SUCCESSFULLY!${NC}"
echo
print_info "You may need to restart your shell or run: ${BOLD}source ~/.zshrc${NC}"
echo -e "${DIM}──────────────────────────────────────────────────────────────────────${NC}\n"
