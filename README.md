# 🌿 Neovim Configuration

My personal Neovim configurations with support for multiple plugin managers.

## Available Configurations

| Configuration                | Plugin Manager                                   | Status        | Description                                      |
|------------------------------|--------------------------------------------------|---------------|--------------------------------------------------|
| **[nvim.lazy](./nvim.lazy)** | [lazy.nvim](https://github.com/folke/lazy.nvim)  | ✅ Active      | Modern Lua-based configuration with lazy loading |
| **[nvim.plug](./nvim.plug)** | [vim-plug](https://github.com/junegunn/vim-plug) | ⚠️ Deprecated | Legacy VimScript configuration                   |

## 📁 Directory Structure

```
.
├── Docker/                # Docker containers (Alpine & Arch)
├── LICENSE
├── README.md              # This file
├── install.ps1            # Windows installer
├── install.sh             # Linux/macOS installer
├── nvim.lazy              # ✅ Recommended configuration
│   ├── README.md
│   ├── init.lua
│   ├── lazy-lock.json
│   ├── lua
│   │   ├── core
│   │   │   ├── autocmds.lua
│   │   │   ├── keymaps.lua
│   │   │   └── options.lua
│   │   └── plugins
│   │       ├── configs
│   │       │   ├── colorscheme.lua
│   │       │   ├── conform.lua
│   │       │   ├── harpoon.lua
│   │       │   ├── lualine.lua
│   │       │   ├── telescope.lua
│   │       │   ├── treesitter.lua
│   │       │   ├── undotree.lua
│   │       │   ├── vim-fugitive.lua
│   │       │   ├── which-key.lua
│   │       │   └── yanky.lua
│   │       └── init.lua
│   └── stylua.toml
└── nvim.plug              # ⚠️ Deprecated configuration
    ├── README.md
    ├── autoload
    │   └── plug.vim
    ├── colors
    │   └── molokai256.vim
    ├── configs
    │   ├── 1.plugins.vim
    │   ├── 2.plugins-settings.vim
    │   └── 3.settings.vim
    ├── ftplugin
    │   └── java.vim
    └── init.vim
```

## Quick Start

### Using nvim.lazy (Recommended)

```bash
# Clone and copy to your Neovim config directory
git clone https://github.com/wesilios/neovim.config
cp -r neovim.config/nvim.lazy ~/.config/nvim
```

See [nvim.lazy/README.md](./nvim.lazy/README.md) for detailed setup instructions.

## 📋 Requirements

### nvim.lazy (Recommended)
See [nvim.lazy/README.md](./nvim.lazy/README.md#-requirements) for complete requirements and dependencies.

**Quick summary:**
- Neovim 0.11.5+, Git, Nerd Font
- **Ripgrep** (required for live grep)
- **Luarocks** (required for plugin management)
- C compiler (for Treesitter)
- Optional: fd, stylua, prettier, python3, nodejs

### nvim.plug (Deprecated)
⚠️ **DEPRECATED** - Use nvim.lazy instead
- Neovim 0.5+, Git, **Node.js & npm** (required for CoC)
- fzf, Python 3
- Build tools (platform-specific)

---

## 💾 Installation by Platform

### 🪟 Windows
```powershell
# Via Chocolatey (recommended)
choco install neovim git ripgrep mingw lua luarocks -y

# Via Scoop
scoop install neovim git ripgrep mingw lua luarocks

# Via winget
winget install Neovim.Neovim Git.Git BurntSushi.ripgrep.MSVC
# For MinGW and Luarocks, use Chocolatey: choco install mingw lua luarocks -y
```

### 🐧 Linux
```bash
# Debian/Ubuntu
sudo apt install neovim git ripgrep build-essential luarocks

# Arch Linux
sudo pacman -S neovim git ripgrep base-devel luarocks

# Fedora/RHEL
sudo dnf install neovim git ripgrep gcc make luarocks
```

### 🍎 macOS
```bash
brew install neovim git ripgrep luarocks
xcode-select --install  # For C compiler
```

📋 **For detailed installation instructions, optional tools, and troubleshooting, see [nvim.lazy/README.md](./nvim.lazy/README.md#-installation-guide)**

---

## Platform Support

- Windows (32/64-bit)
- Linux (Ubuntu, Debian, Arch, Fedora, RHEL)
- macOS
- Docker (Alpine & Arch Linux containers)

## 🐳 Docker Containers

Try Neovim in isolated Docker environments without affecting your system.

**Two options available:**
- **Minimal (Alpine):** ~200-300MB, bare essentials, install tools as needed
- **Full (Arch):** ~2.8GB, everything pre-installed, ready to use

```bash
# Minimal setup (recommended for learning)
cd Docker
docker build -t nvim-minimal .
docker run -it --rm nvim-minimal

# Full setup (complete dev environment)
cd Docker
docker build -f Dockerfile.arch -t nvim-arch .
docker run -it --rm nvim-arch
```

**📖 See [Docker/README.md](Docker/README.md) for complete documentation.**

## 🔗 Useful Links

- [Neovim](https://neovim.io/)
- [Ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)
- [fzf](https://github.com/junegunn/fzf)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

---

## License

MIT License - see [LICENSE](./LICENSE) for details.
