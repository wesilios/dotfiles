#!/usr/bin/env bash

# ============================================
# Neovim Configuration Installer for Linux/macOS
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  Neovim Configuration Installer${NC}"
echo -e "${CYAN}  Platform: $(uname -s)${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Detect platform
OS="$(uname -s)"
case "$OS" in
    Linux*)  PLATFORM="Linux" ;;
    Darwin*) PLATFORM="macOS" ;;
    *) PLATFORM="Unknown";;
esac

# Function: check command exists
command_exists() { command -v "$1" >/dev/null 2>&1; }

echo -e "${YELLOW}Checking prerequisites...${NC}"

MISSING=()

# Neovim
if ! command_exists nvim; then
    MISSING+=("Neovim")
    echo -e "${RED}[X] Neovim not found${NC}"
else
    NVIM_VERSION=$(nvim --version | head -n1)
    echo -e "${GREEN}[OK] Neovim found: ${NVIM_VERSION}${NC}"
fi

# Git
if ! command_exists git; then
    MISSING+=("Git")
    echo -e "${RED}[X] Git not found${NC}"
else
    echo -e "${GREEN}[OK] Git found${NC}"
fi

# Node.js (optional - only needed for nvim.plug)
if ! command_exists node; then
    echo -e "${YELLOW}[!] Node.js not found (required for nvim.plug, optional for nvim.lazy)${NC}"
else
    echo -e "${GREEN}[OK] Node.js found: $(node --version)${NC}"
fi

# Python (optional)
if ! command_exists python3; then
    echo -e "${YELLOW}[!] Python3 not found (optional)${NC}"
else
    echo -e "${GREEN}[OK] Python3 found: $(python3 --version)${NC}"
fi

# Check optional but important tools
if ! command_exists rg; then
    echo -e "${YELLOW}[!] Ripgrep not found (REQUIRED for nvim.lazy live grep)${NC}"
    if [ "$PLATFORM" = "Linux" ]; then
        echo -e "${CYAN}    Install: sudo apt install ripgrep (Ubuntu/Debian)${NC}"
        echo -e "${CYAN}            sudo pacman -S ripgrep (Arch)${NC}"
        echo -e "${CYAN}            sudo dnf install ripgrep (Fedora)${NC}"
    else
        echo -e "${CYAN}    Install: brew install ripgrep${NC}"
    fi
else
    echo -e "${GREEN}[OK] Ripgrep found: $(rg --version | head -n1)${NC}"
fi

if ! command_exists fd; then
    echo -e "${YELLOW}[!] fd not found (optional, improves file finding)${NC}"
    if [ "$PLATFORM" = "Linux" ]; then
        echo -e "${CYAN}    Install: sudo apt install fd-find (Ubuntu/Debian)${NC}"
        echo -e "${CYAN}            sudo pacman -S fd (Arch)${NC}"
    else
        echo -e "${CYAN}    Install: brew install fd${NC}"
    fi
else
    echo -e "${GREEN}[OK] fd found${NC}"
fi

# Stop if prerequisites missing
if [ ${#MISSING[@]} -gt 0 ]; then
    echo ""
    echo -e "${RED}Missing required prerequisites: ${MISSING[*]}${NC}"
    echo ""
    echo -e "${YELLOW}Please install missing prerequisites:${NC}"

    if [ "$PLATFORM" = "Linux" ]; then
        echo -e "Ubuntu/Debian:"
        echo -e "  sudo apt install neovim git"
        echo ""
        echo -e "Arch Linux:"
        echo -e "  sudo pacman -S neovim git"
        echo ""
        echo -e "Fedora:"
        echo -e "  sudo dnf install neovim git"
    else
        echo -e "macOS:"
        echo -e "  brew install neovim git"
    fi

    exit 1
fi

# Configuration selection
echo ""
echo -e "${CYAN}Choose configuration:${NC}"
echo -e "  ${GREEN}1. nvim.lazy${NC} (recommended) - Modern Lua config with lazy.nvim"
echo -e "  ${YELLOW}2. nvim.plug${NC} (deprecated)  - Legacy VimScript with vim-plug"
echo ""
read -p "Enter your choice (1/2, default 1): " CONFIG_CHOICE

case "$CONFIG_CHOICE" in
    2) SELECTED_CONFIG="plug" ;;
    *) SELECTED_CONFIG="lazy" ;;
esac

echo ""
echo -e "${GREEN}Selected: nvim.${SELECTED_CONFIG}${NC}"

echo ""
echo -e "${YELLOW}Setting up Neovim configuration...${NC}"

CONFIG="$HOME/.config/nvim"
DATA="$HOME/.local/share/nvim"
BACKUP_PATH=""

# Handle existing config
if [ -d "$CONFIG" ]; then
    echo ""
    echo -e "${YELLOW}Existing Neovim configuration found at: ${CONFIG}${NC}"
    echo -e "${CYAN}What would you like to do?${NC}"
    echo -e "  ${GREEN}1. Backup${NC} - Create timestamped backup of old config"
    echo -e "  ${RED}2. Remove${NC} - Delete old config (cannot be undone)"
    echo ""
    read -p "Enter your choice (1/2, default 1): " BACKUP_CHOICE

    case "$BACKUP_CHOICE" in
        2)
            echo -e "${RED}Removing existing config...${NC}"
            rm -rf "$CONFIG"
            echo -e "${GREEN}[OK] Old config removed${NC}"
            ;;
        *)
            BACKUP_PATH="${CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
            echo -e "${YELLOW}Backing up existing config to: ${BACKUP_PATH}${NC}"
            mv "$CONFIG" "$BACKUP_PATH"
            echo -e "${GREEN}[OK] Old config backed up${NC}"
            ;;
    esac
fi

# Copy config
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$(dirname "$CONFIG")"

if [ -d "$SCRIPT_DIR/.git" ]; then
    echo -e "${YELLOW}Copying configuration from current directory...${NC}"
    if [ "$SELECTED_CONFIG" = "lazy" ]; then
        cp -r "$SCRIPT_DIR/nvim.lazy" "$CONFIG"
    else
        cp -r "$SCRIPT_DIR/nvim.plug" "$CONFIG"
    fi
else
    echo -e "${YELLOW}Cloning configuration from GitHub...${NC}"
    git clone https://github.com/wesilios/neovim.config /tmp/neovim-config-temp
    if [ "$SELECTED_CONFIG" = "lazy" ]; then
        cp -r /tmp/neovim-config-temp/nvim.lazy "$CONFIG"
    else
        cp -r /tmp/neovim-config-temp/nvim.plug "$CONFIG"
    fi
    rm -rf /tmp/neovim-config-temp
fi

echo -e "${GREEN}[OK] Configuration copied successfully${NC}"

# Plugin manager setup based on selection
if [ "$SELECTED_CONFIG" = "lazy" ]; then
    echo ""
    echo -e "${YELLOW}lazy.nvim will bootstrap automatically on first launch${NC}"
    echo ""
    echo -e "${YELLOW}Syncing plugins...${NC}"
    if nvim --headless "+Lazy! sync" +qa 2>/dev/null; then
        echo -e "${GREEN}[OK] Plugins synced successfully${NC}"
    else
        echo -e "${YELLOW}[!] Plugins will sync on first launch${NC}"
    fi
else
    echo ""
    echo -e "${YELLOW}Installing vim-plug...${NC}"
    PLUG="$DATA/site/autoload/plug.vim"
    mkdir -p "$(dirname "$PLUG")"

    if curl -fsSL https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -o "$PLUG"; then
        echo -e "${GREEN}[OK] vim-plug installed${NC}"
    else
        echo -e "${RED}Failed to install vim-plug${NC}"
        exit 1
    fi

    echo ""
    echo -e "${YELLOW}Installing plugins...${NC}"
    echo "This may take a few minutes..."

    if nvim --headless +PlugInstall +qall; then
        echo -e "${GREEN}[OK] Plugins installed successfully${NC}"
    else
        echo -e "${YELLOW}[!] Plugin installation completed with warnings${NC}"
        echo -e "${YELLOW}You may need to run :PlugInstall manually${NC}"
    fi
fi

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Display backup information if backup was created
if [ -n "$BACKUP_PATH" ]; then
    echo -e "${CYAN}Old configuration backed up to:${NC}"
    echo -e "${YELLOW}  $BACKUP_PATH${NC}"
    echo ""
fi

if [ "$SELECTED_CONFIG" = "lazy" ]; then
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Run nvim"
    echo "  2. Plugins will auto-install on first launch"
    echo "  3. Run health check: :checkhealth"
    echo ""

    # Check if ripgrep is missing and warn
    if ! command_exists rg; then
        echo -e "${RED}IMPORTANT: Ripgrep is REQUIRED for live grep functionality!${NC}"
        echo -e "${YELLOW}  The following keymaps will NOT work without ripgrep:${NC}"
        echo -e "${YELLOW}    - <leader>fg (live grep)${NC}"
        echo -e "${YELLOW}    - <leader>ps (grep search)${NC}"
        echo ""
        echo -e "${CYAN}  Install ripgrep:${NC}"
        if [ "$PLATFORM" = "Linux" ]; then
            echo "    sudo apt install ripgrep       # Ubuntu/Debian"
            echo "    sudo pacman -S ripgrep         # Arch Linux"
            echo "    sudo dnf install ripgrep       # Fedora"
        else
            echo "    brew install ripgrep           # macOS"
        fi
        echo ""
    fi

    echo -e "${YELLOW}Optional but recommended tools:${NC}"
    echo "  - fd: faster file finding"
    echo ""
    echo -e "${YELLOW}Formatters (install via Mason :Mason):${NC}"
    echo "  - stylua: Lua formatter"
    echo "  - prettier: JS/TS/CSS/HTML/Markdown formatter (npm install -g prettier)"
    echo "  - clang-format: C/C++ formatter"
    echo "  - cmake-format: CMake formatter (pip install cmakelang)"
    echo "  - yamlfmt: YAML formatter"
    echo "  - hadolint: Dockerfile linter/formatter"
    echo ""
    echo -e "${YELLOW}Language Servers (install via Mason :Mason):${NC}"
    echo "  - lua-language-server: Lua LSP"
    echo "  - clangd: C/C++ LSP"
    echo "  - neocmakelsp: CMake LSP"
    echo "  - roslyn: C# LSP"
    echo "  - typescript-language-server: Javascript/Typescript LSP"
else
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Run nvim"
    echo "  2. Check plugin status: :PlugStatus"
    echo "  3. Run health check: :checkhealth"
    echo "  4. Install CoC extensions: :CocInstall coc-snippets coc-pairs"
    echo ""
    echo -e "${YELLOW}Optional language servers:${NC}"
    echo "  - Javascript/Typescript: npm install -g typescript typescript-language-server"
    echo "  - Python: pip3 install python-lsp-server"
    echo "  - Rust: rustup component add rls rust-src rust-analysis"
fi
echo ""
