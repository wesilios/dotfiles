# neovim.config

> ⚠️ **DEPRECATED**: This configuration is outdated and should not be used. It will be updated in the future to work with newer Neovim versions and native LSP support. Please use the [nvim.lazy](../nvim.lazy) configuration instead.

---

My Personal Neovim Configuration (Legacy)

A clean, modular Neovim configuration optimized for development productivity.

**Cross-Platform Support:** Windows (32/64-bit) • Linux • macOS

## Structure

    .neovim.config/
    ├── init.vim                    # Main configuration entry point (cross-platform)
    ├── install.ps1                 # Windows installation script
    ├── install.sh                  # Linux/macOS installation script
    ├── autoload/                   # Autoload scripts
    │   └── plug.vim                # vim-plug plugin manager
    ├── colors/                     # Custom color schemes
    │   └── molokai256.vim          # Molokai 256-color theme
    ├── configs/                    # Modular configuration files
    │   ├── 1.plugins.vim           # Plugin definitions (cross-platform)
    │   ├── 2.plugins-settings.vim  # Plugin-specific settings
    │   └── 3.settings.vim          # General Neovim settings
    ├── ftplugin/                   # Filetype-specific configurations
    │   └── java.vim                # Java language settings
    └── .gitignore                  # Git ignore patterns

**Configuration Paths:**
- **Windows:** `%LOCALAPPDATA%\nvim` (typically `C:\Users\YourName\AppData\Local\nvim`)
- **Linux/macOS:** `~/.config/nvim`

## Installation

This configuration supports **Windows (32/64-bit)**, **Linux**, and **macOS**. Choose your platform below for detailed installation instructions.

### Quick Install (Automated)

For a quick automated installation, use the provided installation scripts:

**Windows (PowerShell):**
```powershell
# Download and run the installer
iwr -useb https://raw.githubusercontent.com/wesilios/neovim.config/main/install.ps1 | iex

# Or if you've cloned the repo
.\install.ps1
```

**Linux/macOS (Bash):**
```bash
# Download and run the installer
curl -fsSL https://raw.githubusercontent.com/wesilios/neovim.config/main/install.sh | bash

# Or if you've cloned the repo
chmod +x install.sh
./install.sh
```

### Manual Installation

If you prefer manual installation or the automated script doesn't work, follow the platform-specific instructions below.

### Prerequisites

All platforms require:
- **Neovim 0.5+** installed
- **Git** for cloning the repository
- **Node.js and npm/yarn** (for CoC and markdown-preview plugins)
- **Python 3** with pip (for some language servers)

Platform-specific requirements:
- **Windows**: PowerShell 5.1+ or PowerShell Core, Visual Studio Build Tools or MinGW (for compiling plugins)
- **Linux**: build-essential package (gcc, make, etc.)
- **macOS**: Xcode Command Line Tools

---

## Windows Installation (32-bit & 64-bit)

### Step 1: Install Neovim

**Option A: Using Chocolatey (Recommended)**
```powershell
choco install neovim
```

**Option B: Using Scoop**
```powershell
scoop install neovim
```

**Option C: Manual Installation**
1. Download from [Neovim Releases](https://github.com/neovim/neovim/releases)
2. Extract to `C:\Program Files\Neovim`
3. Add to PATH: `C:\Program Files\Neovim\bin`

### Step 2: Install Prerequisites

```powershell
# Install Node.js (if not already installed)
choco install nodejs

# Install Python (if not already installed)
choco install python

# Install build tools (choose one)
# Option A: Visual Studio Build Tools
choco install visualstudio2019buildtools

# Option B: MinGW
choco install mingw
```

### Step 3: Clone Configuration

```powershell
# Clone to the Windows Neovim config directory
git clone https://github.com/wesilios/neovim.config "$env:LOCALAPPDATA\nvim"
```

### Step 4: Install vim-plug

```powershell
# PowerShell command to install vim-plug
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni "$env:LOCALAPPDATA\nvim-data\site\autoload\plug.vim" -Force
```

### Step 5: Install Plugins

```powershell
# Open Neovim
nvim

# Inside Neovim, run:
:PlugInstall

# Wait for installation to complete, then restart Neovim
```

### Step 6: Install Language Servers (Optional)

```powershell
# For JavaScript/TypeScript
npm install -g typescript typescript-language-server

# For Rust
rustup component add rls rust-analysis rust-src

# For Python
pip install python-language-server
```

---

## Linux Installation

### Step 1: Install Neovim

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install neovim
```

**Fedora:**
```bash
sudo dnf install neovim
```

**Arch Linux:**
```bash
sudo pacman -S neovim
```

**From Source (Latest Version):**
```bash
sudo apt install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
git clone https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```

### Step 2: Install Prerequisites

```bash
# Ubuntu/Debian
sudo apt install git nodejs npm python3 python3-pip build-essential

# Fedora
sudo dnf install git nodejs npm python3 python3-pip gcc make

# Arch Linux
sudo pacman -S git nodejs npm python python-pip base-devel
```

### Step 3: Clone Configuration

```bash
# Backup existing config if it exists
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup

# Clone the configuration
git clone https://github.com/wesilios/neovim.config ~/.config/nvim
```

### Step 4: Install vim-plug

```bash
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### Step 5: Install Plugins

```bash
# Open Neovim
nvim

# Inside Neovim, run:
:PlugInstall

# Wait for installation to complete, then restart Neovim
```

### Step 6: Install Language Servers (Optional)

```bash
# For JavaScript/TypeScript
sudo npm install -g typescript typescript-language-server

# For Rust
rustup component add rls rust-analysis rust-src

# For Python
pip3 install python-language-server
```

---

## macOS Installation

### Step 1: Install Neovim

**Using Homebrew (Recommended):**
```bash
brew install neovim
```

**Using MacPorts:**
```bash
sudo port install neovim
```

### Step 2: Install Prerequisites

```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install git node python
```

### Step 3: Clone Configuration

```bash
# Backup existing config if it exists
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup

# Clone the configuration
git clone https://github.com/wesilios/neovim.config ~/.config/nvim
```

### Step 4: Install vim-plug

```bash
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### Step 5: Install Plugins

```bash
# Open Neovim
nvim

# Inside Neovim, run:
:PlugInstall

# Wait for installation to complete, then restart Neovim
```

### Step 6: Install Language Servers (Optional)

```bash
# For JavaScript/TypeScript
npm install -g typescript typescript-language-server

# For Rust
rustup component add rls rust-analysis rust-src

# For Python
pip3 install python-language-server
```

---

## Post-Installation Configuration

### Verify Installation

After installation, verify everything works:

```vim
" Inside Neovim, check plugin status
:PlugStatus

" Check CoC status
:CocInfo

" Check health
:checkhealth
```

### Troubleshooting

**Plugins not installing:**
- Ensure you have internet connection
- Check `:messages` for error details
- Try `:PlugClean` then `:PlugInstall` again

**CoC not working:**
```vim
" Inside Neovim
:CocInstall coc-snippets coc-pairs
```

**Build errors on Windows:**
- Ensure Visual Studio Build Tools or MinGW is installed
- Run Neovim as Administrator for first-time plugin installation

**Permission errors on Linux/macOS:**
- Don't use `sudo` with Neovim
- Ensure `~/.config/nvim` is owned by your user: `sudo chown -R $USER:$USER ~/.config/nvim`

### Platform-Specific Notes

**Windows:**
- Configuration automatically detects Windows and uses `%LOCALAPPDATA%\nvim`
- Some plugins require Visual Studio Build Tools or MinGW for compilation
- PowerShell execution policy may need to be adjusted: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
- For best results, use Windows Terminal or a modern terminal emulator

**Linux:**
- Different distributions use different package managers (apt, dnf, pacman, etc.)
- Ensure you have build-essential or equivalent development tools installed
- Some plugins may require additional system libraries
- Works great with any terminal emulator

**macOS:**
- Xcode Command Line Tools are required for building plugins
- Homebrew is the recommended package manager
- Works seamlessly with iTerm2, Terminal.app, or any modern terminal
- Apple Silicon (M1/M2) is fully supported

## Features

- **Cross-Platform Support**: Works seamlessly on Windows (32/64-bit), Linux, and macOS
- **Modular Configuration**: Organized into separate files for easy maintenance
- **Plugin Management**: Uses vim-plug for efficient plugin handling
- **Rich Language Support**: JavaScript, TypeScript, Rust, Java, C#, Python, and more
- **Intelligent Autocompletion**: CoC (Conquer of Completion) with LSP support
- **Fuzzy Finding**: Fast file navigation with fzf
- **Git Integration**: Built-in Git commands via vim-fugitive
- **File Explorer**: NERDTree for easy file browsing
- **Syntax Checking**: Real-time linting with ALE
- **Custom Themes**: Gruvbox and Molokai color schemes included
- **Automated Installation**: Platform-specific installation scripts
- **Clean Structure**: Well-organized directory layout

## Customization

### Adding New Plugins

Edit `configs/1.plugins.vim` and add your plugin using vim-plug syntax:
```vim
Plug 'author/plugin-name'
```

### Modifying Settings

- General settings: Edit configs/3.settings.vim 
- Plugin settings: Edit configs/2.plugins-settings.vim 
- Language-specific: Add files to ftplugin/ directory

### Adding Color Schemes
Place .vim color scheme files in the colors/ directory.

### Plugin List
The configuration includes carefully selected plugins for enhanced productivity. Check configs/1.plugins.vim for the complete list.

## Contributing
1. Fork the repository
2. Create your feature branch: git checkout -b feature/amazing-feature
3. Commit your changes: git commit -m 'Add some amazing feature'
4. Push to the branch: git push origin feature/amazing-feature
5. Open a Pull Request

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Documentation

- [Neovim Documentation](https://neovim.io/doc/) - Official Neovim docs
- [vim-plug Documentation](https://github.com/junegunn/vim-plug) - Plugin manager docs
- [CoC Documentation](https://github.com/neoclide/coc.nvim) - Autocompletion docs

## Support

If you encounter any issues or have questions:
- Run `:checkhealth` in Neovim to diagnose issues
- Open an issue on GitHub with your OS, Neovim version, and error details
- Check the Neovim documentation
- Visit vim-plug documentation

