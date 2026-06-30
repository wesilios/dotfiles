# dotfiles

My personal dotfiles for Linux and macOS — Neovim, Zsh, and Tmux.

## Symlink layout

After running `install.sh`, the following symlinks are created:

| Symlink | → Dotfiles source |
|---------|-------------------|
| `~/.zshrc` | `~/dotfiles/.zshrc` |
| `~/.p10k.zsh` | `~/dotfiles/.p10k.zsh` |
| `~/.config/nvim` | `~/dotfiles/config/nvim` |
| `~/.config/tmux/tmux.conf` | `~/dotfiles/config/tmux/tmux.conf` |

## Quick install

```bash
git clone https://github.com/wesilios/neovim.config ~/dotfiles
cd ~/dotfiles
./install.sh
```

The script prompts which components to install, backs up any existing configs, then creates symlinks.

## What's included

| Tool | Source | Description |
|------|--------|-------------|
| **Neovim** | [`config/nvim/`](./config/nvim/) | lazy.nvim Lua config with LSP, Treesitter, Telescope |
| **Zsh** | [`.zshrc`](./.zshrc) · [`.p10k.zsh`](./.p10k.zsh) | zinit · Powerlevel10k · autosuggestions · syntax-highlighting |
| **Tmux** | [`config/tmux/tmux.conf`](./config/tmux/tmux.conf) | Vim-style pane navigation, TPM plugins |

## Repository layout

```
dotfiles/
├── .zshrc                        # ~/.zshrc
├── .p10k.zsh                     # ~/.p10k.zsh  (Powerlevel10k prompt config)
├── config/
│   ├── nvim/                     # ~/.config/nvim  (lazy.nvim Lua config)
│   │   ├── init.lua
│   │   └── lua/
│   │       ├── core/
│   │       └── plugins/
│   └── tmux/
│       └── tmux.conf             # ~/.config/tmux/tmux.conf
├── neovim.config/                # legacy: nvim.plug, Docker test containers
├── install.sh                    # this installer
└── README.md
```

## Requirements

| Tool | Version | Install |
|------|---------|---------|
| Neovim | 0.11.5+ | `apt/brew install neovim` |
| Git | any | `apt/brew install git` |
| Zsh | 5.0+ | `apt/brew install zsh` |
| Tmux | 3.1+ | `apt/brew install tmux` |
| Ripgrep | any | `apt/brew install ripgrep` |
| Nerd Font | any | [nerdfonts.com](https://www.nerdfonts.com/) |

## Neovim LSP servers

Install inside Neovim via `:Mason`:

```
lua-language-server   clangd   neocmakelsp   typescript-language-server   roslyn
```

## Platform support

Linux (Ubuntu/Debian, Arch, Fedora), macOS, Docker — see [`neovim.config/Docker/`](./neovim.config/Docker/).

## License

MIT — see [`neovim.config/LICENSE`](./neovim.config/LICENSE).
