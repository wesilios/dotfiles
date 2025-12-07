# Neovim Playground on Arch Linux
# A Docker environment for testing the nvim.lazy configuration
FROM archlinux:latest

# Update system and install required packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        base-devel \
        sudo \
        curl \
        git \
        fzf \
        ripgrep \
        unzip \
        wget \
        gcc \
        neovim \
        fastfetch \
        diffutils \
        xclip \
        stylua \
        tree \
        zsh && \
    pacman -Scc --noconfirm

# Create user 'arch' with sudo privileges
RUN useradd -m -s /bin/zsh arch && \
    echo "arch ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/arch && \
    chmod 440 /etc/sudoers.d/arch

# Switch to user for yay installation (AUR helper cannot run as root)
USER arch
WORKDIR /home/arch

# Install yay (AUR helper)
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm && \
    cd .. && \
    rm -rf yay

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="agnoster"/' ~/.zshrc

# Copy Neovim configuration
COPY --chown=arch:arch nvim.lazy /home/arch/.config/nvim

# Create common directories
RUN mkdir -p ~/Downloads ~/Documents ~/Projects

# Default command - start zsh
CMD ["zsh"]

