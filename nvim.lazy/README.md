# 🌿 My Neovim Configuration

A lightweight, fast, and fully Lua-based Neovim setup built with **lazy.nvim**, focusing on:

- Clean UI
- Fast navigation
- Smart formatting
- Modern Lua plugin ecosystem
- Easy color scheme switching
- Minimal magic, maximum control

---

## 📁 Folder Structure

```
    .
    |-- init.lua
    |-- lazy-lock.json
    |-- lua
    |   |-- core
    |   |   |-- autocmds.lua
    |   |   |-- keymaps.lua
    |   |   `-- options.lua
    |   `-- plugins
    |       |-- configs
    |       |   |-- colorscheme.lua
    |       |   |-- conform.lua
    |       |   |-- harpoon.lua
    |       |   |-- lualine.lua
    |       |   |-- telescope.lua
    |       |   |-- treesitter.lua
    |       |   |-- undotree.lua
    |       |   |-- vim-fugitive.lua
    |       |   |-- which-key.lua
    |       |   `-- yanky.lua
    |       `-- init.lua
    `-- stylua.toml
```


---

## 📦 Requirements

### Core Dependencies

#### Required (Minimum Setup)
| Tool | Purpose | Why Required |
|------|---------|--------------|
| **Neovim 0.11.5+** | Editor | Core requirement |
| **Git** | Version control | Plugin manager, vim-fugitive |
| **Nerd Font** | Icons | nvim-web-devicons, lualine |
| **Ripgrep (rg)** | Text search | Telescope live_grep, grep_string |
| **C Compiler** | Build parsers | nvim-treesitter compilation |

#### C Compiler by Platform
- **Windows**: gcc (via MinGW, TDM-GCC, or MSYS2), clang, or MSVC
- **Linux**: gcc or clang (usually in build-essential/base-devel)
- **macOS**: clang (via Xcode Command Line Tools)

### Optional but Recommended

| Tool | Purpose | Used By | Impact if Missing |
|------|---------|---------|-------------------|
| **fd** | Fast file finder | Telescope find_files | Falls back to slower find/rg |
| **stylua** | Lua formatter | conform.nvim | Lua formatting won't work |
| **prettier** | JS/TS/CSS/HTML formatter | conform.nvim | Web formatting won't work |

### Plugin Dependencies Summary

| Plugin | External Dependencies | Notes |
|--------|----------------------|-------|
| telescope.nvim | **ripgrep** (required), fd (optional) | No alternative for live grep |
| nvim-treesitter | **C compiler** (required) | Compiles language parsers |
| conform.nvim | stylua, prettier (optional) | Only needed for formatting |
| lualine.nvim | Nerd Font (required) | Icons won't display correctly |
| nvim-web-devicons | Nerd Font (required) | Icons won't display correctly |
| vim-fugitive | Git (required) | Git integration |
| harpoon | None | Pure Lua |
| yanky.nvim | None | Pure Lua |
| undotree | None | Pure Lua |
| which-key.nvim | None | Pure Lua |

---

## 🚀 Installation Guide

### Step 1: Install Dependencies

#### 🪟 Windows

**Via Chocolatey (Recommended):**
```powershell
# Core dependencies
choco install neovim git ripgrep gcc

# Optional tools
choco install fd stylua

# Formatters (if needed)
npm install -g prettier
```

**Via Scoop:**
```powershell
scoop install neovim git ripgrep gcc
scoop install fd stylua
npm install -g prettier
```

**Via winget:**
```powershell
winget install Neovim.Neovim
winget install Git.Git
winget install BurntSushi.ripgrep.MSVC
# For gcc, install MinGW or use Visual Studio Build Tools
```

**Note:** For Treesitter on Windows, you need a C compiler. Options:
- MinGW-w64: `choco install mingw`
- TDM-GCC: Download from [tdm-gcc.tdragon.net](https://jmeubank.github.io/tdm-gcc/)
- MSVC: Install Visual Studio Build Tools

#### 🐧 Linux

**Debian/Ubuntu:**
```bash
# Core dependencies
sudo apt update
sudo apt install neovim git ripgrep build-essential

# Optional tools
sudo apt install fd-find

# Formatters
cargo install stylua  # Requires Rust
npm install -g prettier
```

**Arch Linux:**
```bash
# Core dependencies
sudo pacman -S neovim git ripgrep base-devel

# Optional tools
sudo pacman -S fd stylua

# Formatters
npm install -g prettier
```

**Fedora/RHEL:**
```bash
# Core dependencies
sudo dnf install neovim git ripgrep gcc make

# Optional tools
sudo dnf install fd-find

# Formatters
cargo install stylua
npm install -g prettier
```

#### 🍎 macOS

**Using Homebrew:**
```bash
# Core dependencies
brew install neovim git ripgrep

# C compiler (Xcode Command Line Tools)
xcode-select --install

# Optional tools
brew install fd stylua

# Formatters
npm install -g prettier
```

### Step 2: Install Configuration

**Linux/macOS:**
```bash
# Clone the repository
git clone https://github.com/wesilios/neovim.config

# Copy nvim.lazy to your config directory
cp -r neovim.config/nvim.lazy ~/.config/nvim
```

**Windows (PowerShell):**
```powershell
# Clone the repository
git clone https://github.com/wesilios/neovim.config

# Copy nvim.lazy to your config directory
Copy-Item -Recurse neovim.config\nvim.lazy $env:LOCALAPPDATA\nvim
```

### Step 3: Launch Neovim

```bash
nvim
```

Plugins will automatically install on first launch via lazy.nvim.

### Step 4: Verify Installation

Run health checks:
```vim
:checkhealth
:checkhealth telescope
:checkhealth treesitter
```

Check for missing dependencies:
```bash
# Verify all tools are installed
nvim --version
git --version
rg --version
gcc --version  # or clang --version
fd --version   # optional
```

---

## ✨ Features

### 🎨 Color Scheme Switching

This configuration includes three beautiful color schemes with multiple variants.

#### Available Themes

| Theme | Variants | Description |
|-------|----------|-------------|
| **Gruvbox** | `dark`, `light` | Retro groove color scheme |
| **TokyoNight** | `moon`, `storm`, `night`, `day` | Clean, dark theme inspired by Tokyo's night |
| **Rosé Pine** | `main`, `moon`, `dawn` | Soho vibes with natural contrast |

#### How to Switch Themes

**Method 1: Interactive Keymap (Recommended)**
```vim
<leader>cl
```
This will prompt you to:
1. Choose a theme (gruvbox/tokyonight/rosepine)
2. Choose a variant (depends on theme)

**Method 2: Lua Command**
```lua
:lua SwitchColorScheme("gruvbox", "dark")
:lua SwitchColorScheme("gruvbox", "light")
:lua SwitchColorScheme("tokyonight", "moon")
:lua SwitchColorScheme("tokyonight", "storm")
:lua SwitchColorScheme("tokyonight", "night")
:lua SwitchColorScheme("tokyonight", "day")
:lua SwitchColorScheme("rosepine", "main")
:lua SwitchColorScheme("rosepine", "moon")
:lua SwitchColorScheme("rosepine", "dawn")
```

**Method 3: Edit Configuration**

To set a default theme, edit `lua/plugins/configs/colorscheme.lua`:

```lua
-- Change the default theme loaded on startup
-- In lua/plugins/init.lua, line 42-46:
{
  'ellisonleao/gruvbox.nvim',
  config = function()
    require(configpath .. 'colorscheme').switchtogruvbox('dark')  -- Change 'dark' to 'light'
  end,
},
```

Or call a different theme function:
```lua
-- For TokyoNight
require(configpath .. 'colorscheme').switchtotokyonight('storm')

-- For Rosé Pine
require(configpath .. 'colorscheme').switchtorosepine('moon')
```

## Plugins Included

```
conform.nvim
gruvbox.nvim
harpoon
lazy.nvim
lualine.nvim
nvim-treesitter
nvim-web-devicons
playground
plenary.nvim
rose-pine
telescope.nvim
tokyonight.nvim
undotree
vim-fugitive
which-key.nvim
yanky.nvim
```

---

## ⌨️ Key Mappings

**Leader key**: `<Space>`

### Core Navigation
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>pv` | Normal | Open file explorer (netrw) |
| `<leader>o` | Normal | Insert empty line below cursor |
| `<leader>O` | Normal | Insert empty line above cursor |
| `<leader>w` | Normal | Save file |
| `<leader>wq` | Normal | Save and quit |
| `<leader>q` | Normal | Quit |
| `<Alt-j>` | Normal | Move line down |
| `<Alt-k>` | Normal | Move line up |
| `<Alt-j>` | Visual | Move selection down |
| `<Alt-k>` | Visual | Move selection up |

### Telescope (File & Text Search)
| Keymap | Mode | Description | Required Tool |
|--------|------|-------------|---------------|
| `<leader>ff` | Normal | Find files | Telescope (built-in) |
| `<leader>fg` | Normal | **Live grep** | **ripgrep** ✅ |
| `<leader>ps` | Normal | **Grep search** | **ripgrep** ✅ |
| `<leader>fb` | Normal | Find buffers | Telescope (built-in) |
| `<leader>fh` | Normal | Help tags | Telescope (built-in) |

### Git (vim-fugitive)
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>gs` | Normal | Git status |
| `<leader>gb` | Normal | Git blame |
| `<leader>gd` | Normal | Git diff (vertical split) |
| `<leader>gc` | Normal | Git commit |
| `<leader>g?` | Normal | Fugitive help |
| `<leader>gS` | Normal | Git status (Telescope) |
| `<leader>gB` | Normal | Git branches (Telescope) |
| `<leader>gC` | Normal | Git commits (Telescope) |
| `<leader>gF` | Normal | Git tracked files (Telescope) |
| `<leader>gT` | Normal | Git stash (Telescope) |

### Harpoon (Quick File Navigation)
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>h` | Normal | Add file to Harpoon |
| `<leader>H` | Normal | Toggle Harpoon quick menu |
| `<leader>h1` to `<leader>h9` | Normal | Jump to Harpoon file 1-9 |
| `<Ctrl-Shift-P>` | Normal | Previous Harpoon buffer |
| `<Ctrl-Shift-N>` | Normal | Next Harpoon buffer |

### Yanky (Yank History)
| Keymap | Mode | Description |
|--------|------|-------------|
| `<Ctrl-c>` | Normal | Yank line/selection |
| `p` | Normal/Visual | Paste after (Yanky) |
| `P` | Normal/Visual | Paste before (Yanky) |
| `]p` | Normal | Previous yank entry |
| `[p` | Normal | Next yank entry |
| `<leader>yh` | Normal | Open yank history picker |
| `<leader>yhc` | Normal | Clear yank history |

### Undotree
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>u` | Normal | Toggle undotree |

### Which-Key
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>?` | Normal | Show buffer local keymaps |

### Color Scheme
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>cl` | Normal | Change color scheme (interactive) |

### Formatting
| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>cf` | Normal/Visual | Format buffer with Conform |

### Plugin Management
| Command | Description |
|---------|-------------|
| `:Lazy` | Open lazy.nvim plugin manager |
| `:Lazy sync` | Sync plugins (install/update/clean) |
| `:Lazy update` | Update plugins |
| `:Lazy clean` | Remove unused plugins |

### Health Check
| Command | Description |
|---------|-------------|
| `:checkhealth` | Check Neovim health |
| `:checkhealth telescope` | Check Telescope dependencies |
| `:checkhealth treesitter` | Check Treesitter and C compiler |

---

## 🚨 Troubleshooting

### Telescope Issues

**Problem: `live_grep` not working or "ripgrep not found"**
```bash
# Solution: Install ripgrep
# Windows
choco install ripgrep

# Linux (Ubuntu/Debian)
sudo apt install ripgrep

# macOS
brew install ripgrep

# Verify installation
rg --version
```

**Problem: Telescope shows no results**
- Check if ripgrep is in PATH: `rg --version`
- Run `:checkhealth telescope`
- Restart Neovim after installing ripgrep

**Problem: File finding is slow**
- Install `fd` for faster file finding
- Telescope will automatically use it if available

### Treesitter Issues

**Problem: "No C compiler found" or parser installation fails**

**Windows:**
```powershell
# Install MinGW
choco install mingw

# Or install TDM-GCC from https://jmeubank.github.io/tdm-gcc/

# Verify
gcc --version

# Tell Treesitter to use gcc
# Add to your init.lua:
require('nvim-treesitter.install').compilers = { "gcc" }
```

**Linux:**
```bash
# Debian/Ubuntu
sudo apt install build-essential

# Arch
sudo pacman -S base-devel

# Fedora
sudo dnf groupinstall "Development Tools"
```

**macOS:**
```bash
xcode-select --install
```

**Problem: Treesitter parsers not installing**
```vim
# Manually install parsers
:TSInstall lua
:TSInstall javascript
:TSInstall typescript
:TSInstall python

# Update all parsers
:TSUpdate

# Check status
:checkhealth treesitter
```

### Formatting Issues

**Problem: Lua formatting not working**
```bash
# Install stylua
# Windows
choco install stylua

# Linux (with Rust/Cargo)
cargo install stylua

# macOS
brew install stylua

# Verify
stylua --version
```

**Problem: JavaScript/TypeScript formatting not working**
```bash
# Install prettier
npm install -g prettier

# Verify
prettier --version
```

### Icon/Display Issues

**Problem: Icons showing as boxes or question marks**
- Install a Nerd Font: [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads)
- Configure your terminal to use the Nerd Font
- Restart your terminal

**Problem: Colors look wrong**
- Ensure your terminal supports 24-bit true color
- Check terminal settings for color support
- Try different color schemes with `<leader>cl`

### Plugin Issues

**Problem: Plugins not installing**
```vim
# Sync plugins
:Lazy sync

# Check for errors
:Lazy

# Clear cache and reinstall
:Lazy clean
:Lazy sync
```

**Problem: Lazy.nvim not bootstrapping**
- Delete `~/.local/share/nvim/lazy` (Linux/macOS) or `%LOCALAPPDATA%\nvim-data\lazy` (Windows)
- Restart Neovim
- Plugins will reinstall automatically

### Git Integration Issues

**Problem: vim-fugitive commands not working**
```bash
# Ensure git is installed
git --version

# Check if you're in a git repository
git status
```

### Performance Issues

**Problem: Neovim feels slow**
- Run `:Lazy profile` to see plugin load times
- Disable unused plugins in `lua/plugins/init.lua`
- Check `:checkhealth` for issues

---

## 📚 Additional Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [lazy.nvim Documentation](https://github.com/folke/lazy.nvim)
- [Telescope Documentation](https://github.com/nvim-telescope/telescope.nvim)
- [Treesitter Documentation](https://github.com/nvim-treesitter/nvim-treesitter)
- [Conform.nvim Documentation](https://github.com/stevearc/conform.nvim)
