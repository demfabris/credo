export ZSH="$HOME/.oh-my-zsh"
. "$HOME/.cargo/env"

ZSH_THEME="robbyrussell"
plugins=(git fzf zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

eval "$(/opt/homebrew/bin/brew shellenv)"

[[ -f ~/.config/lsd/colors.zsh ]] && source ~/.config/lsd/colors.zsh
[[ -f ~/.secrets/env ]] && source ~/.secrets/env

# Ayu Dark theme for fzf
export FZF_DEFAULT_OPTS="
  --height 100% --layout=reverse --border
  --preview 'bat --color=always --style=numbers --line-range :500 {}'
  --color=fg:#bfbdb6,bg:#0a0e14,hl:#c2a05c
  --color=fg+:#bfbdb6,bg+:#2d3640,hl+:#e6b450
  --color=info:#5c6773,prompt:#c2a05c,pointer:#c2a05c
  --color=marker:#7e9350,spinner:#1f6f88,header:#5c6773
  --color=border:#5c6773,gutter:#0a0e14
"

alias gl="git log --oneline --decorate --graph --all"
alias gs="git status"
alias l='y'
alias ll='lsd -lah'
alias python='python3'
alias vim='nvim'
alias pp='pbcopy'
alias claude='claude --allow-dangerously-skip-permissions'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

export SUDO_EDITOR="nvim"
export EDITOR="nvim"

export LANG=en_US.UTF-8
export GIT_AUTHOR_NAME="Fabricio Dematte"

# GitHub token for MCP servers (dynamically fetched from gh CLI)
export GITHUB_PERSONAL_ACCESS_TOKEN="$(gh auth token 2>/dev/null)"

export PATH="$PATH:~/Library/Android/sdk/emulator/"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH="$DENO_INSTALL/bin:$PATH"
export CPPFLAGS="-I /opt/homebrew/opt/openjdk@17/include"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

[[ -f ~/.zshrc.d/niceties.zsh ]] && source ~/.zshrc.d/niceties.zsh

# bun completions
[ -s "/Users/demfabris/.bun/_bun" ] && source "/Users/demfabris/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# zoxide (smarter cd)
eval "$(zoxide init zsh)"

export PATH="$PATH:$HOME/.local/bin"

# Prefer Homebrew binaries over system
export PATH="/opt/homebrew/bin:$PATH"
