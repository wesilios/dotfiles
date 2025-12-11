# Minimal Neovim Docker (Alpine Linux)

> **📦 Image Size:** ~200-300MB (Ultra-minimal, bare essentials only)
> **Base OS:** Alpine Linux
> **Shell:** bash (zsh/oh-my-zsh can be installed post-creation)

## 🎯 Philosophy

This is the **absolute bare minimum** to run Neovim with essential plugins.
- No curl (unless you install it)
- No zsh/oh-my-zsh (use bash, or install later)
- No Python/Node.js (install post-creation as needed)
- Smallest possible image size

## 📦 What's Included (Bare Minimum)

### Pre-installed Packages
| Package | Purpose | Size Impact |
|---------|---------|-------------|
| **neovim** | Editor | ~50MB |
| **git** | Version control, plugin manager | ~10MB |
| **bash** | Shell (minimal) | ~1MB |
| **ripgrep** | Text search (Telescope required) | ~5MB |
| **fd** | File finder (Telescope optional) | ~2MB |
| **gcc** | C compiler (Treesitter) | ~50MB |
| **musl-dev** | C library headers | ~20MB |
| **make** | Build tool | ~5MB |
| **lua5.1** | Lua runtime | ~5MB |
| **lua5.1-dev** | Lua headers | ~5MB |
| **luarocks5.1** | Lua package manager | ~5MB |
| **sudo** | Privilege escalation | ~1MB |

**Total:** ~200-300MB (including Alpine base ~7MB + dependencies)

### NOT Included (Install Post-Creation)
- ❌ curl (install if needed: `sudo apk add curl`)
- ❌ zsh (install if needed: `sudo apk add zsh`)
- ❌ oh-my-zsh (install via post-install.sh)
- ❌ Python/pip (install: `sudo apk add python3 py3-pip`)
- ❌ Node.js/npm (install: `sudo apk add nodejs npm`)
- ❌ stylua (install: `cargo install stylua`)
- ❌ prettier (install: `npm install -g prettier`)

## 🚀 Quick Start

### Build the Image
```bash
# Must build from repository root (required for nvim.lazy/ access)
docker build -f Docker/Dockerfile -t nvim-minimal .

# Build with BuildKit (faster, recommended)
DOCKER_BUILDKIT=1 docker build -f Docker/Dockerfile -t nvim-minimal .

# Build without cache (fresh build)
docker build -f Docker/Dockerfile --no-cache -t nvim-minimal .
```

### Run the Container
```bash
# One-time use (removed after exit)
docker run -it --rm nvim-minimal

# Persistent container
docker run -it --name nvim-dev nvim-minimal

# With volume mount for projects
docker run -it --rm -v $(pwd)/projects:/home/arch/Projects nvim-minimal
```

### Inside the Container
```bash
# Launch Neovim (plugins auto-install on first run)
nvim

# Check what's installed
neovim --version
git --version
rg --version
```

## 📦 Post-Installation (Optional Tools)

### Option 1: Use the Post-Install Script
```bash
# Copy script into container (from host)
docker cp post-install.sh nvim-dev:/home/arch/

# Inside container
chmod +x post-install.sh
./post-install.sh
# Follow interactive menu to install tools
```

### Option 2: Manual Installation

#### Install zsh + Oh My Zsh
```bash
sudo apk add zsh curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Change default shell
sudo sed -i "s|/bin/bash|/bin/zsh|g" /etc/passwd
exec zsh
```

#### Install Python
```bash
sudo apk add python3 py3-pip
python3 --version
pip3 --version
```

#### Install Node.js (via apk)
```bash
sudo apk add nodejs npm
node --version
npm --version
```

#### Install Node.js (via nvm - recommended)
```bash
sudo apk add curl
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts
```

#### Install stylua (Lua formatter)
```bash
sudo apk add cargo
cargo install stylua
export PATH="$HOME/.cargo/bin:$PATH"
```

#### Install prettier (JS/TS formatter)
```bash
# Requires Node.js
npm install -g prettier
```

## 🎯 Use Cases

### Perfect For:
- ✅ Learning Neovim basics
- ✅ Minimal playground environment
- ✅ CI/CD pipelines (small image)
- ✅ Limited disk space scenarios
- ✅ Quick testing of Neovim configs
- ✅ Understanding bare minimum requirements

### Not Ideal For:
- ❌ Full development environment (use Dockerfile.arch instead)
- ❌ Immediate productivity (requires post-install)
- ❌ Users who want everything pre-configured

## 📊 Size Comparison

| Metric | Minimal (Dockerfile) | Full (Dockerfile.arch) |
|--------|---------------------|------------------------|
| Base OS | Alpine (~7MB) | Arch (~400MB) |
| Final Size | ~200-300MB | ~2.8GB |
| Build Time | 1-2 minutes | 5-10 minutes |
| Pre-installed | Bare minimum | Everything |
| Ready to use | ⚠️ Partial | ✅ Yes |

## 🔗 Related Files

- `Dockerfile` - This minimal setup
- `Dockerfile.arch` - Full Arch Linux setup (2.8GB)
- `post-install.sh` - Interactive post-installation script
- `DOCKER.arch.md` - Documentation for full setup
- `README.md` - Quick comparison guide
- `../nvim.lazy/` - Neovim configuration

