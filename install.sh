#!/usr/bin/env bash

# ============================================
# Dotfiles Installer — Neovim, Zsh, Tmux
# Symlinks config files from ~/dotfiles into place
# ============================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo -e "${CYAN}${BOLD}"
echo "  ╔═══════════════════════════════════════╗"
echo "  ║         dotfiles installer            ║"
echo "  ║  Neovim · Zsh · Tmux                 ║"
echo "  ╚═══════════════════════════════════════╝"
echo -e "${NC}"
echo -e "  Dotfiles: ${CYAN}${DOTFILES_DIR}${NC}"
echo ""

OS="$(uname -s)"
case "$OS" in
    Linux*)  PLATFORM="Linux" ;;
    Darwin*) PLATFORM="macOS" ;;
    *)       PLATFORM="Unknown" ;;
esac

command_exists() { command -v "$1" >/dev/null 2>&1; }

# ─── Helper: create symlink, backing up anything already there ────────────────
link() {
    local src="$1"   # file inside ~/dotfiles
    local dst="$2"   # canonical location (~/.zshrc, ~/.config/nvim, …)

    mkdir -p "$(dirname "$dst")"

    if [ -L "$dst" ]; then
        local current
        current="$(readlink "$dst")"
        if [ "$current" = "$src" ]; then
            echo -e "  ${GREEN}[ok] ${dst}${NC} (already linked)"
            return
        fi
        echo -e "  ${YELLOW}Removing old symlink: ${dst}${NC}"
        rm "$dst"
    elif [ -e "$dst" ]; then
        local backup="${dst}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "  ${YELLOW}Backing up ${dst} → ${backup}${NC}"
        mv "$dst" "$backup"
    fi

    ln -sf "$src" "$dst"
    echo -e "  ${GREEN}[linked] ${dst}${NC}"
    echo -e "         ${CYAN}→ ${src}${NC}"
}

# ─── Component selection ──────────────────────────────────────────────────────

echo -e "${BOLD}Which components do you want to install?${NC}"
echo ""

ask_yn() {
    local answer
    read -r -p "$(echo -e "${CYAN}  $1${NC} [Y/n]: ")" answer
    answer="${answer:-y}"
    [[ "$answer" =~ ^[Yy]$ ]]
}

INSTALL_ZSH=false
INSTALL_TMUX=false
INSTALL_NVIM=false

ask_yn "Zsh   (.zshrc + .p10k.zsh + zinit)"  && INSTALL_ZSH=true
ask_yn "Tmux  (.config/tmux/tmux.conf + TPM)" && INSTALL_TMUX=true
ask_yn "Neovim (.config/nvim + lazy.nvim)"    && INSTALL_NVIM=true

echo ""

# ─── Prerequisite checks ─────────────────────────────────────────────────────

echo -e "${BOLD}Checking prerequisites...${NC}"

MISSING=()

check() {
    local cmd="$1" label="$2"
    if command_exists "$cmd"; then
        echo -e "${GREEN}  [ok] ${label}${NC}"
    else
        echo -e "${RED}  [!!] ${label} not found${NC}"
        MISSING+=("$label")
    fi
}

$INSTALL_ZSH  && check zsh   "zsh"
$INSTALL_TMUX && check tmux  "tmux"
$INSTALL_NVIM && check nvim  "neovim"

( $INSTALL_ZSH || $INSTALL_TMUX || $INSTALL_NVIM ) && check git "git"

if [ ${#MISSING[@]} -gt 0 ]; then
    echo ""
    echo -e "${RED}Missing: ${MISSING[*]}${NC}"
    echo ""
    if [ "$PLATFORM" = "macOS" ]; then
        echo -e "${CYAN}  brew install ${MISSING[*]}${NC}"
    else
        echo -e "${CYAN}  sudo apt install ${MISSING[*]}          # Ubuntu/Debian${NC}"
        echo -e "${CYAN}  sudo pacman -S ${MISSING[*]}            # Arch${NC}"
        echo -e "${CYAN}  sudo dnf install ${MISSING[*]}          # Fedora${NC}"
    fi
    exit 1
fi

echo ""

# ─── Zsh ─────────────────────────────────────────────────────────────────────

if $INSTALL_ZSH; then
    echo -e "${BOLD}Setting up Zsh...${NC}"

    echo -e "${CYAN}  zinit bootstraps itself on first shell start — no manual install needed.${NC}"
    echo -e "${CYAN}  Plugins (powerlevel10k, autosuggestions, syntax-highlighting) are fetched${NC}"
    echo -e "${CYAN}  automatically the first time you open a new shell.${NC}"
    echo ""

    echo -e "  Linking:"
    link "$DOTFILES_DIR/.zshrc"    "$HOME/.zshrc"
    link "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
    echo ""

    echo -e "  ${CYAN}Powerlevel10k notes:${NC}"
    echo -e "  • To reconfigure the prompt, run: ${CYAN}p10k configure${NC}"
    echo -e "  • Official docs: ${CYAN}https://github.com/romkatv/powerlevel10k#zinit${NC}"
    echo ""
fi

# ─── Tmux ────────────────────────────────────────────────────────────────────

if $INSTALL_TMUX; then
    echo -e "${BOLD}Setting up Tmux...${NC}"

    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        echo -e "${YELLOW}  Installing TPM (Tmux Plugin Manager)...${NC}"
        git clone --depth=1 https://github.com/tmux-plugins/tpm \
            "$HOME/.tmux/plugins/tpm"
    else
        echo -e "${GREEN}  [ok] TPM already installed${NC}"
    fi

    echo ""
    echo -e "  Linking:"
    link "$DOTFILES_DIR/config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
    echo ""

    # Install plugins if a tmux server is already running
    if tmux info >/dev/null 2>&1; then
        echo -e "${YELLOW}  Installing tmux plugins via TPM...${NC}"
        "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 \
            && echo -e "${GREEN}  [ok] Tmux plugins installed${NC}" \
            || echo -e "${YELLOW}  [!]  Run prefix+I inside tmux to install plugins${NC}"
    else
        echo -e "${YELLOW}  [!]  Start tmux and press prefix+I to install plugins${NC}"
    fi
    echo ""
fi

# ─── Neovim ──────────────────────────────────────────────────────────────────

if $INSTALL_NVIM; then
    echo -e "${BOLD}Setting up Neovim...${NC}"
    echo -e "${GREEN}  [ok] $(nvim --version | head -n1)${NC}"

    if ! command_exists rg; then
        echo -e "${YELLOW}  [!]  Ripgrep not found — live grep will not work${NC}"
        if [ "$PLATFORM" = "macOS" ]; then
            echo -e "${CYAN}       brew install ripgrep${NC}"
        else
            echo -e "${CYAN}       sudo apt install ripgrep   # Ubuntu/Debian${NC}"
            echo -e "${CYAN}       sudo pacman -S ripgrep     # Arch${NC}"
        fi
    fi

    # Populate config/nvim from neovim.config/nvim.lazy (source of truth)
    if [ ! -d "$DOTFILES_DIR/config/nvim" ]; then
        if [ -d "$DOTFILES_DIR/neovim.config/nvim.lazy" ]; then
            echo -e "${YELLOW}  Copying nvim.lazy from neovim.config...${NC}"
            cp -r "$DOTFILES_DIR/neovim.config/nvim.lazy" "$DOTFILES_DIR/config/nvim"
        else
            echo -e "${YELLOW}  Cloning neovim.config from GitHub (wesilios/neovim.config)...${NC}"
            git clone --depth=1 https://github.com/wesilios/neovim.config /tmp/neovim-config-temp
            cp -r /tmp/neovim-config-temp/nvim.lazy "$DOTFILES_DIR/config/nvim"
            rm -rf /tmp/neovim-config-temp
        fi
        echo -e "${GREEN}  [ok] config/nvim populated${NC}"
    else
        echo -e "${GREEN}  [ok] config/nvim already exists — skipping copy${NC}"
    fi

    echo ""
    echo -e "  Linking:"
    link "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
    echo ""

    echo -e "${YELLOW}  Syncing plugins (lazy.nvim)...${NC}"
    if nvim --headless "+Lazy! sync" +qa 2>/dev/null; then
        echo -e "${GREEN}  [ok] Plugins synced${NC}"
    else
        echo -e "${YELLOW}  [!]  Plugins will sync on first nvim launch${NC}"
    fi
    echo ""

    echo -e "${CYAN}  Help docs:${NC}"
    echo -e "  • To generate the custom help doc:    open nvim → ${CYAN}<leader>?g${NC}"
    echo -e "  • To rebuild all plugin help tags:    open nvim → ${CYAN}:helptags ALL${NC}"
    echo ""
fi

# ─── Done ────────────────────────────────────────────────────────────────────

echo -e "${CYAN}${BOLD}══════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}  Done!${NC}"
echo -e "${CYAN}${BOLD}══════════════════════════════════════════${NC}"
echo ""

echo -e "  Symlinks created:"
$INSTALL_ZSH  && echo -e "  ${CYAN}~/.zshrc${NC}                  → ${DOTFILES_DIR}/.zshrc"
$INSTALL_ZSH  && echo -e "  ${CYAN}~/.p10k.zsh${NC}               → ${DOTFILES_DIR}/.p10k.zsh"
$INSTALL_TMUX && echo -e "  ${CYAN}~/.config/tmux/tmux.conf${NC}  → ${DOTFILES_DIR}/config/tmux/tmux.conf"
$INSTALL_NVIM && echo -e "  ${CYAN}~/.config/nvim${NC}            → ${DOTFILES_DIR}/config/nvim"
echo ""

if $INSTALL_ZSH; then
    echo -e "  Zsh:    open a new shell — zinit + plugins auto-install on first start"
    echo -e "          run ${CYAN}p10k configure${NC} to reconfigure the prompt"
    echo -e "          see ${CYAN}https://github.com/romkatv/powerlevel10k#zinit${NC} for docs"
fi
$INSTALL_TMUX && echo -e "  Tmux:   start tmux, press ${CYAN}prefix+I${NC} to install plugins"
$INSTALL_NVIM && echo -e "  Neovim: run ${CYAN}nvim${NC} — plugins auto-install on first launch"
$INSTALL_NVIM && echo -e "          run ${CYAN}<leader>?g${NC} inside nvim to generate custom :help doc"
$INSTALL_NVIM && echo -e "          run ${CYAN}:helptags ALL${NC} inside nvim to rebuild all plugin help tags"
$INSTALL_NVIM && echo -e "  Source: config/nvim is copied from ${CYAN}neovim.config/nvim.lazy${NC} (not tracked in git)"
echo ""
