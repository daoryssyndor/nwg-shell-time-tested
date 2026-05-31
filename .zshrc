# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Oh My Zsh core ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

eval "$(ssh-agent -s)" >/dev/null
ssh-add -q ~/.ssh/id_ed25519 2>/dev/null

plugins=(
  git
  fzf
  zsh-autosuggestions
  zsh-syntax-highlighting   # OMZ will load it, but we also source it explicitly at end
)

# Define styles before loading plugin (and make sure the array exists)
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=46'                 # vivid green for valid commands
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=196,bold'     # red + bold for unknown
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=220'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=220'
ZSH_HIGHLIGHT_STYLES[path]='fg=39'
ZSH_HIGHLIGHT_STYLES[quoted-argument]='fg=45'

source "$ZSH/oh-my-zsh.sh"

# Powerlevel10k config (if present)
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Aliases
alias ll='ls -ltra'
#alias hx='helix'
alias c='clear'
alias fo='hx "$(fzf)"'
# --- FZF defaults (used by Ctrl-R / Ctrl-T) ---
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git 2>/dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_CTRL_T_COMMAND='{
  fd --type f --hidden --follow --exclude .git "$HOME/___w" 2>/dev/null
  fd --type f --hidden --follow --exclude .git . 2>/dev/null
}'
#---priotirize dirs--- ALT+C---
export FZF_ALT_C_COMMAND='{
  fd --type d --hidden --follow --exclude .git "$HOME/___w" 2>/dev/null
  fd --type d --hidden --follow --exclude .git . 2>/dev/null
}'

# --- visually distinct ___w folder ---
export FZF_CTRL_T_OPTS='
  --ansi
  --color=fg:#c0c0c0,hl:#ffaf00
'

# --- Extra keybinds ---
# accept autosuggestion by word
bindkey '^ ' autosuggest-accept         # Ctrl+Space
# menu completion backward with Shift-Tab
bindkey -M menuselect '^[[Z' reverse-menu-complete

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# --- Make absolutely sure highlighting is LAST ---
# (Prevents other scripts from resetting ZLE styles)
HIGHL_PLUGIN="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -r "$HIGHL_PLUGIN" ]] && source "$HIGHL_PLUGIN"
export ELECTRON_TRUST_STORE=0
export VSCODE_CREDENTIAL_SERVICE=plaintext

#yazi CWD
# --- Yazi CWD jump ---
unalias y 2>/dev/null       # remove any alias set earlier (OMZ/plugins)

y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  command yazi "$@" --cwd-file="$tmp"
  cwd="$(<"$tmp")"
  rm -f -- "$tmp"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd -- "$cwd"
}

# optional: shows up in `alias`, doesn't affect calls (function wins)
alias y='y'
alias z='zoxide'

export PATH="$HOME/.local/bin:$PATH"
export GOOSE_DISABLE_KEYRING=1
export EDITOR=helix
alias yay='env -u NO_PROXY -u no_proxy HTTPS_PROXY=socks5h://127.0.0.1:9050 HTTP_PROXY=socks5h://127.0.0.1:9050 ALL_PROXY=socks5h://127.0.0.1:9050 yay'

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export EDITOR=helix
export VISUAL=helix

# opencode
export PATH=/home/drew/.opencode/bin:$PATH

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Added by LM Studio CLI tool (lms)
export PATH="$PATH:/home/drew/.lmstudio/bin"
export PATH="$HOME/.lmstudio/bin:$PATH"
export PATH="$HOME/.local/share/npm-global/bin:$HOME/.local/bin:$PATH"
alias telegram='GDK_GL=disable Telegram'
