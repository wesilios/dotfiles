# Neovim Docker Containers

Two Docker options for running Neovim in isolated environments.

## 🚀 Quick Start

### Option 1: Minimal (Alpine) ⭐ Recommended
**~200-300MB** | bash shell | Install tools as needed

```bash
# Build from repository root (required)
docker build -f Docker/Dockerfile -t nvim-minimal .
docker run -it --rm nvim-minimal
```

### Option 2: Full (Arch)
**~2.8GB** | zsh + oh-my-zsh | Everything pre-installed

```bash
# Build from repository root (required)
docker build -f Docker/Dockerfile.arch -t nvim-arch .
docker run -it --rm nvim-arch
```

## 📋 Comparison

| Feature | Minimal (Dockerfile) | Full (Dockerfile.arch) |
|---------|---------------------|------------------------|
| **Size** | ~200-300MB | ~2.8GB |
| **Build** | 1-2 min | 5-10 min |
| **Shell** | bash | zsh + oh-my-zsh |
| **Python/Node** | Install later | ✅ Pre-installed |
| **Best For** | Learning, CI/CD | Full dev environment |

## 📦 What's Included

### Both Images
✅ neovim, git, ripgrep, fd, gcc, make, luarocks

### Only Full (Dockerfile.arch)
✅ bash, zsh, oh-my-zsh, curl, python, pip, nodejs, npm, stylua

### Minimal - Install Post-Creation
Use `post-install.sh` script inside container:
```bash
# Copy script into container
docker cp post-install.sh <container>:/home/arch/

# Inside container
chmod +x post-install.sh
./post-install.sh
```

## 📖 Documentation

- **[DOCKER.minimal.md](DOCKER.md)** - Complete minimal setup guide
- **[DOCKER.arch.md](DOCKER-arch.md)** - Complete full setup guide
- **[post-install.sh](post-install.sh)** - Interactive tool installer

## 🔧 Common Commands

```bash
# Build (must be from repository root)
docker build -f Docker/Dockerfile -t nvim-minimal .
docker build -f Docker/Dockerfile.arch -t nvim-arch .

# Run with volume mount (from repo root)
docker run -it --rm -v $(pwd)/projects:/home/arch/Projects nvim-minimal

# Persistent container
docker run -it --name nvim-dev nvim-minimal
docker start -ai nvim-dev

# Copy post-install script into container
docker cp Docker/post-install.sh nvim-dev:/home/arch/
```

## 🎯 Which One to Choose?

**Choose Minimal if:**
- ✅ You want smallest image (~200-300MB)
- ✅ Learning Neovim or testing configs
- ✅ Limited disk space (CI/CD, cloud)
- ✅ Prefer bash over zsh

**Choose Full if:**
- ✅ You want everything ready immediately
- ✅ Need Python/Node.js for LSP, formatters
- ✅ Prefer zsh with oh-my-zsh
- ✅ Don't mind 2.8GB image size

---

**Important:** All build commands must be run from the **repository root** directory using `-f Docker/Dockerfile` or `-f Docker/Dockerfile.arch`. This is required because Docker needs access to the `nvim.lazy/` folder.

