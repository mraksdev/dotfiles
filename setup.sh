#!/bin/sh

# ==============================================================================
# Dotfiles Symlink Setup Script (POSIX-compliant Pretty & Verbose Edition)
# ==============================================================================
# This script safely backs up existing configs and creates symlinks to the
# dotfiles repository. It provides detailed, formatted output with colors.
# ==============================================================================

set -e  # Exit on error

# --- Terminal Formatting ------------------------------------------------------
# Colors (using octal escape for strict POSIX compatibility)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# Text styles
BOLD='\033[1m'
DIM='\033[2m'
UNDERLINE='\033[4m'

# Symbols
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
    printf "%b──────────────────────────────────────────────────────────────────────%b\n" "$DIM" "$NC"
}

print_header() {
    printf "\n%b%s%b\n" "$BOLD$WHITE" "$1" "$NC"
    print_separator
}

print_success() {
    printf "%b%s %s%b\n" "$GREEN" "$SYM_OK" "$1" "$NC"
}

print_error() {
    printf "%b%s %s%b\n" "$RED" "$SYM_ERROR" "$1" "$NC"
}

print_warning() {
    printf "%b%s %s%b\n" "$YELLOW" "$SYM_WARN" "$1" "$NC"
}

print_info() {
    printf "%b%s %s%b\n" "$BLUE" "$SYM_INFO" "$1" "$NC"
}

print_path_info() {
    printf "  %b%s %s%b\n" "$DIM" "$SYM_DIR" "$1" "$NC"
}

print_backup_info() {
    printf "  %b%s %s -> %s%b\n" "$YELLOW" "$SYM_BACKUP" "$1" "$2" "$NC"
}

print_link_info() {
    printf "  %b%s %s -> %s%b\n" "$CYAN" "$SYM_LINK" "$1" "$2" "$NC"
}

# Check if path needs backup
needs_backup() {
    ( [ -f "$1" ] && [ ! -L "$1" ] ) || ( [ -d "$1" ] && [ ! -L "$1" ] )
}

# Process a configuration path
process_path() {
    _pp_path="$1"
    _pp_name="$2"

    if [ -L "$_pp_path" ]; then
        print_warning "Removing existing symlink: $_pp_path"
        rm -v "$_pp_path" | sed 's/^/    /'
    elif [ -d "$_pp_path" ]; then
        _backup_name="${_pp_name}_${BACKUP_TIMESTAMP}"
        print_backup_info "$_pp_path" "$BACKUP_DIR/$_backup_name"
        mkdir -p "$BACKUP_DIR"
        mv -v "$_pp_path" "$BACKUP_DIR/$_backup_name" | sed 's/^/    /'
    elif [ -f "$_pp_path" ]; then
        _backup_name="${_pp_name}_${BACKUP_TIMESTAMP}"
        print_backup_info "$_pp_path" "$BACKUP_DIR/$_backup_name"
        mkdir -p "$BACKUP_DIR"
        mv -v "$_pp_path" "$BACKUP_DIR/$_backup_name" | sed 's/^/    /'
    else
        print_info "No existing item at $_pp_path"
    fi
}

# Create a symlink
create_symlink() {
    _cs_src="$1"
    _cs_dst="$2"
    _cs_desc="$3"

    printf "%b->%b Creating symlink for %b%s%b\n" "$BLUE" "$NC" "$BOLD" "$_cs_desc" "$NC"
    print_link_info "$_cs_dst" "$_cs_src"
    if ln -s -v "$_cs_src" "$_cs_dst" | sed 's/^/    /'; then
        print_success "Symlink created successfully."
    else
        print_error "Failed to create symlink $_cs_dst"
        exit 1
    fi
    echo
}

# --- Main Script --------------------------------------------------------------
clear 2>/dev/null || true

printf "%b\n" "${BOLD}${MAGENTA}"
printf "  +======================================================================+\n"
printf "  |                 DOTFILES SYMLINK SETUP SCRIPT                         |\n"
printf "  +======================================================================+\n"
printf "%b\n" "${NC}"

# --- Variables ----------------------------------------------------------------
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/backup/dotfiles"
BACKUP_TIMESTAMP=""
BACKUP_NEEDED=false

print_header "ENVIRONMENT INFORMATION"
printf "%b->%b Dotfiles directory : %b%s%b\n" "$BLUE" "$NC" "$BOLD" "$DOTFILES_DIR" "$NC"
printf "%b->%b Config directory   : %b%s%b\n" "$BLUE" "$NC" "$BOLD" "$CONFIG_DIR" "$NC"
printf "%b->%b Backup directory   : %b%s%b\n" "$BLUE" "$NC" "$BOLD" "$BACKUP_DIR" "$NC"

# --- Ensure config directory exists early -------------------------------------
print_header "PREPARING TARGET DIRECTORY"
printf "%b->%b Ensuring %b%s%b exists...\n" "$BLUE" "$NC" "$BOLD" "$CONFIG_DIR" "$NC"
mkdir -p -v "$CONFIG_DIR" | sed 's/^/    /'
print_success "Target directory is ready."

# --- Pre-check: Source directories existence ----------------------------------
print_header "VERIFYING SOURCE STRUCTURE"

REQUIRED_DIRS="zsh nvim tmux lf"
missing_dirs=""

for dir in $REQUIRED_DIRS; do
    if [ -d "$DOTFILES_DIR/$dir" ]; then
        printf "%b[OK]%b Found source directory: %b%s%b\n" "$GREEN" "$NC" "$BOLD" "$dir" "$NC"
    else
        print_error "Missing source directory: $dir"
        missing_dirs="$missing_dirs $dir"
    fi
done

if [ -n "$missing_dirs" ]; then
    echo
    print_error "Missing required directories in dotfiles:$missing_dirs"
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

set -- \
    "$CONFIG_DIR/zsh" \
    "$HOME/.zshrc" \
    "$HOME/.zshenv" \
    "$CONFIG_DIR/nvim" \
    "$CONFIG_DIR/tmux" \
    "$CONFIG_DIR/lf"

for target do
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
    printf "%b->%b Backup timestamp: %b%s%b\n" "$BLUE" "$NC" "$BOLD" "$BACKUP_TIMESTAMP" "$NC"
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
    printf "%b[OK]%b Backups saved to: %b%s%b\n" "$GREEN" "$NC" "$BOLD" "$BACKUP_DIR" "$NC"
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
printf "%b%s SETUP COMPLETED SUCCESSFULLY!%b\n" "$GREEN$BOLD" "$SYM_OK" "$NC"
echo
printf "%b->%b You may need to restart your shell or run: %bsource ~/.zshrc%b\n" "$BLUE" "$NC" "$BOLD" "$NC"
printf "%b──────────────────────────────────────────────────────────────────────%b\n\n" "$DIM" "$NC"
