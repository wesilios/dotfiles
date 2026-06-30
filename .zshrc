# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- ZINIT LOADING ---
# (The installer automatically puts the Zinit initialization chunk here)

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"

# Add theme
zinit ice depth=1; zinit light romkatv/powerlevel10k

# --- PLUGINS ---
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
# zinit light Aloxaf/fzf-tab

# Load the OMZ Git library and plugin (for those handy git aliases)
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::command-not-found

# Ensure zinit's local plugin dir exists before compinit to avoid broken-symlink warning on fresh installs
ZINIT_COMPLETIONS="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/completions"
ZINIT_LOCAL_PLUGIN="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/plugins/_local---zinit"
if [[ -L "${ZINIT_COMPLETIONS}/_zinit" && ! -e "${ZINIT_COMPLETIONS}/_zinit" ]]; then
  mkdir -p "$ZINIT_LOCAL_PLUGIN"
  ln -sf "${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git/_zinit" "${ZINIT_LOCAL_PLUGIN}/_zinit"
fi
unset ZINIT_COMPLETIONS ZINIT_LOCAL_PLUGIN

autoload -Uz compinit && compinit
zinit cdreplay -q

# Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=6000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# --- YOUR PERSONAL CUSTOMIZATIONS ---
# Paste any old aliases, exports, or paths from your ~/.zshrc.bak here
alias ll="ls -la"

export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Styling
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# fzf --zsh flag not available in fzf v0.38.0 (Debian 12 default); requires v0.48+
