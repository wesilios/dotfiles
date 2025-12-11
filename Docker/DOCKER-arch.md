# Full Neovim Docker (Arch Linux)

> **📦 Image Size:** ~2.8GB (Full development environment)
> **Base OS:** Arch Linux
> **Shell:** zsh with Oh My Zsh (agnoster theme)

## 🎯 Philosophy

This is a **complete, ready-to-use** Neovim development environment.
- ✅ All tools pre-installed (Python, Node.js, npm, stylua)
- ✅ zsh with Oh My Zsh configured
- ✅ No post-installation required
- ✅ Immediate productivity

## 📦 What's Included (Everything)

### Pre-installed Packages

#### Core Tools
| Package | Purpose | Size Impact |
|---------|---------|-------------|
| **neovim** | Editor | ~100MB |
| **git** | Version control | ~50MB |
| **zsh** | Shell | ~10MB |
| **oh-my-zsh** | Shell framework | ~50MB |
| **ripgrep** | Text search | ~10MB |
| **fd** | File finder | ~5MB |
| **sudo** | Privilege escalation | ~5MB |
| **curl** | HTTP client | ~5MB |
| **unzip** | Archive extraction | ~5MB |

#### Build Tools
| Package | Purpose | Size Impact |
|---------|---------|-------------|
| **gcc** | C compiler | ~150MB |
| **make** | Build tool | ~10MB |
| **luarocks** | Lua package manager | ~20MB |

#### Development Runtimes
| Package | Purpose | Size Impact |
|---------|---------|-------------|
| **python** | Python runtime | ~100MB |
| **python-pip** | Python package manager | ~100MB |
| **nodejs** | JavaScript runtime | ~100MB |
| **npm** | Node package manager | ~50MB |

#### Formatters & Linters
| Package | Purpose | Size Impact |
|---------|---------|-------------|
| **stylua** | Lua formatter | ~20MB |

**Total:** ~2.8GB (including Arch base ~400MB + dependencies ~700MB)

## 🚀 Quick Start

### Build the Image
```bash
# Must build from repository root (required for nvim.lazy/ access)
docker build -f Docker/Dockerfile.arch -t nvim-arch .

# Build with BuildKit (faster, recommended)
DOCKER_BUILDKIT=1 docker build -f Docker/Dockerfile.arch -t nvim-arch .

# Build without cache (fresh build)
docker build -f Docker/Dockerfile.arch --no-cache -t nvim-arch .
```

### Run the Container
```bash
# One-time use (removed after exit)
docker run -it --rm nvim-arch

# Persistent container
docker run -it --name nvim-dev nvim-arch

# With volume mount for projects
docker run -it --rm -v $(pwd)/projects:/home/arch/Projects nvim-arch

# With persistent plugin data
docker run -it --rm \
  -v $(pwd)/projects:/home/arch/Projects \
  -v nvim-plugins:/home/arch/.local/share/nvim \
  nvim-arch
```

### Inside the Container
```bash
# Launch Neovim (plugins auto-install on first run)
nvim

# Everything is ready!
python3 --version
node --version
npm --version
stylua --version
```

## 🎯 Use Cases

### Perfect For:
- ✅ Full development environment
- ✅ Immediate productivity (no setup needed)
- ✅ LSP, formatters, linters all ready
- ✅ Users who want everything pre-configured
- ✅ Long-term development container
- ✅ Complex projects requiring multiple tools

### Not Ideal For:
- ❌ Limited disk space (use Dockerfile instead)
- ❌ CI/CD pipelines (too large)
- ❌ Quick testing (use Dockerfile instead)

## 📊 Size Breakdown

### What Contributes to 2.8GB?
- Base Arch Linux: ~400MB
- System packages (pacman cache cleaned): ~800MB
- Python + pip: ~200MB
- Node.js + npm: ~150MB
- gcc + make + build tools: ~300MB
- Neovim + plugins: ~100MB
- Oh My Zsh: ~50MB
- Other tools (ripgrep, fd, stylua, etc.): ~100MB
- **Overhead & dependencies**: ~700MB

## 🔧 Advanced Usage

### Build with Custom Arguments
```bash
# Build with specific tag
docker build -f Dockerfile.arch -t nvim-arch:v1.0 .

# Build with progress output
DOCKER_BUILDKIT=1 docker build -f Dockerfile.arch --progress=plain -t nvim-arch .
```

### docker-compose.yml
```yaml
version: '3.8'
services:
  neovim-arch:
    build:
      context: .
      dockerfile: Dockerfile.arch
    container_name: nvim-arch
    volumes:
      - ./projects:/home/arch/Projects
      - nvim-data:/home/arch/.local/share/nvim
    stdin_open: true
    tty: true

volumes:
  nvim-data:
```

### Export/Import Image
```bash
# Export (creates ~2.8GB file)
docker save nvim-arch > nvim-arch.tar

# Export compressed (creates ~1GB file)
docker save nvim-arch | gzip > nvim-arch.tar.gz

# Import
docker load < nvim-arch.tar
gunzip -c nvim-arch.tar.gz | docker load
```

## 🐛 Troubleshooting

### Package Signature Errors
```bash
# Update keyring
sudo pacman -Sy archlinux-keyring

# Force refresh package database
sudo pacman -Syy
```

### Disk Space Issues
```bash
# Clean package cache
sudo pacman -Scc

# Remove orphaned packages
sudo pacman -Rns $(pacman -Qtdq)
```

### Plugins Not Installing
```bash
# Manually sync plugins
nvim --headless "+Lazy! sync" +qa
```

## 📝 Notes

- Container runs as user `arch` with sudo privileges (no password)
- Neovim plugins install on first launch (1-2 minutes)
- Oh My Zsh pre-configured with **agnoster** theme
- All required + recommended tools pre-installed
- Python, Node.js, npm, stylua ready to use immediately

## 🔗 Related Files

- `Dockerfile.arch` - This full setup
- `Dockerfile` - Minimal Alpine setup (~200-300MB)
- `DOCKER.minimal.md` - Documentation for minimal setup
- `README.md` - Quick comparison guide
- `../nvim.lazy/` - Neovim configuration

