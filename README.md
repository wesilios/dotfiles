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
├── Dockerfile
├── LICENSE
├── README.md
├── install.ps1
├── install.sh
├── nvim.lazy
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
└── nvim.plug
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

## Requirements

- **Neovim 0.11.5+** (for nvim.lazy)
- **Git**
- **Nerd Font** (for icons)

## Platform Support

- Windows (32/64-bit)
- Linux
- macOS
- Docker (Arch Linux playground)

## 🐳 Docker Playground

Try the configuration in an isolated Arch Linux environment without affecting your system:

```bash
# Build the image
docker build -t nvim-playground .

# Run interactively
docker run -it --rm nvim-playground

# Inside the container, launch Neovim
nvim
```

The Docker image includes:
- Neovim with nvim.lazy configuration pre-installed
- **yay** AUR helper for installing additional packages
- Oh My Zsh with agnoster theme
- Common tools: fzf, ripgrep, stylua, tree

## License

MIT License - see [LICENSE](./LICENSE) for details.
