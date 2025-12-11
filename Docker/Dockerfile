# Ultra-Minimal Neovim on Alpine Linux
# Target size: ~200-300MB (bare minimum, no shell extras)
# Install zsh/oh-my-zsh post-creation if desired
FROM alpine:latest

# Set environment variables
ENV LANG=en_US.UTF-8 \
    TERM=xterm-256color

# Install ONLY bare minimum packages in single layer
RUN apk add --no-cache \
        # Core essentials (absolute minimum)
        sudo \
        git \
        bash \
        # Neovim and required tools
        neovim \
        ripgrep \
        fd \
        # Build tools (for Treesitter)
        gcc \
        musl-dev \
        make \
        # Lua for Neovim
        lua5.1 \
        lua5.1-dev \
        luarocks5.1 && \
    # Create symlinks for lua/luarocks
    ln -sf /usr/bin/lua5.1 /usr/bin/lua && \
    ln -sf /usr/bin/luarocks-5.1 /usr/bin/luarocks && \
    # Clean up
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

# Create user 'arch' with sudo privileges (using bash as default shell)
RUN adduser -D -s /bin/bash arch && \
    echo "arch ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/arch && \
    chmod 440 /etc/sudoers.d/arch

# Switch to user
USER arch
WORKDIR /home/arch

# Create minimal bash profile for better UX
RUN echo 'export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' > ~/.bashrc && \
    echo 'alias ll="ls -lah"' >> ~/.bashrc && \
    echo 'alias vim="nvim"' >> ~/.bashrc && \
    echo 'export EDITOR=nvim' >> ~/.bashrc

# Create directories
RUN mkdir -p ~/Projects ~/.config

# Copy Neovim configuration (from parent directory)
COPY --chown=arch:arch ../nvim.lazy/init.lua /home/arch/.config/nvim/init.lua
COPY --chown=arch:arch ../nvim.lazy/lazy-lock.json /home/arch/.config/nvim/lazy-lock.json
COPY --chown=arch:arch ../nvim.lazy/stylua.toml /home/arch/.config/nvim/stylua.toml
COPY --chown=arch:arch ../nvim.lazy/lua /home/arch/.config/nvim/lua

# Default command
CMD ["bash"]

