#!/bin/bash
# Post-installation script for Alpine minimal Docker container
# Run this inside the container to install additional tools

set -e

echo "=========================================="
echo "Neovim Alpine - Post Installation Script"
echo "=========================================="
echo ""

# Function to install zsh and oh-my-zsh
install_zsh() {
    echo "📦 Installing zsh and Oh My Zsh..."
    sudo apk add --no-cache zsh curl
    
    # Install Oh My Zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Set robbyrussell theme (minimal)
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="robbyrussell"/' ~/.zshrc
    
    # Remove unnecessary themes (keep only robbyrussell)
    cd ~/.oh-my-zsh/themes && ls | grep -v "^robbyrussell.zsh-theme$" | xargs rm -f
    
    # Keep only essential plugins
    cd ~/.oh-my-zsh/plugins && ls | grep -v -e "^git$" -e "^sudo$" | xargs rm -rf
    
    # Change default shell
    sudo sed -i "s|/bin/bash|/bin/zsh|g" /etc/passwd
    
    echo "✅ zsh and Oh My Zsh installed successfully!"
    echo "   Restart your shell or run: exec zsh"
}

# Function to install Python
install_python() {
    echo "📦 Installing Python and pip..."
    sudo apk add --no-cache python3 py3-pip
    echo "✅ Python installed successfully!"
    python3 --version
    pip3 --version
}

# Function to install Node.js via apk
install_nodejs_apk() {
    echo "📦 Installing Node.js and npm (via apk)..."
    sudo apk add --no-cache nodejs npm
    echo "✅ Node.js installed successfully!"
    node --version
    npm --version
}

# Function to install Node.js via nvm
install_nodejs_nvm() {
    echo "📦 Installing Node.js via nvm..."
    sudo apk add --no-cache curl
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    
    # Source nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Install LTS
    nvm install --lts
    nvm use --lts
    
    echo "✅ Node.js (via nvm) installed successfully!"
    node --version
    npm --version
}

# Function to install stylua
install_stylua() {
    echo "📦 Installing stylua (Lua formatter)..."
    sudo apk add --no-cache cargo
    cargo install stylua
    echo "✅ stylua installed successfully!"
    echo "   Add to PATH: export PATH=\"\$HOME/.cargo/bin:\$PATH\""
}

# Function to install prettier
install_prettier() {
    echo "📦 Installing prettier (requires Node.js)..."
    if ! command -v npm &> /dev/null; then
        echo "❌ npm not found. Install Node.js first."
        return 1
    fi
    npm install -g prettier
    echo "✅ prettier installed successfully!"
    prettier --version
}

# Function to install all common tools
install_all() {
    echo "📦 Installing all common development tools..."
    install_python
    install_nodejs_apk
    install_stylua
    install_prettier
    echo ""
    echo "✅ All tools installed successfully!"
}

# Interactive menu
show_menu() {
    echo "Select what to install:"
    echo "  1) zsh + Oh My Zsh"
    echo "  2) Python + pip"
    echo "  3) Node.js + npm (via apk)"
    echo "  4) Node.js + npm (via nvm)"
    echo "  5) stylua (Lua formatter)"
    echo "  6) prettier (JS/TS formatter)"
    echo "  7) Install all (Python, Node via apk, stylua, prettier)"
    echo "  8) Exit"
    echo ""
    read -p "Enter choice [1-8]: " choice
    
    case $choice in
        1) install_zsh ;;
        2) install_python ;;
        3) install_nodejs_apk ;;
        4) install_nodejs_nvm ;;
        5) install_stylua ;;
        6) install_prettier ;;
        7) install_all ;;
        8) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid choice. Exiting."; exit 1 ;;
    esac
}

# Run menu
show_menu

echo ""
echo "=========================================="
echo "Installation complete!"
echo "=========================================="

