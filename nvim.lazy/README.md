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

- **Neovim 0.11.5+**
- **Git**
- **Nerd Font** (for icons) — [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads) recommended
- Optional formatters:
  - `stylua`
  - `prettier`

---

## 🚀 Installation

Clone into your Neovim config directory:

```bash
git clone <repo-url> ~/.config/nvim
```

## Launch Neovim:

```bash
nvim
```

---

## ✨ Features
### Global Color Scheme Switching

Supports:

- Gruvbox — light / dark
- TokyoNight — storm / night / day
- Rosé Pine — main / moon / dawn

Examples:

```bash
:lua SwitchColorScheme("gruvbox", "light")
:lua SwitchColorScheme("tokyonight", "storm")
:lua SwitchColorScheme("rosepine", "dawn")
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
