export ZSH="$HOME/.oh-my-zsh"
. "$HOME/.cargo/env"

ZSH_THEME="robbyrussell"
plugins=(git fzf zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

eval "$(/opt/homebrew/bin/brew shellenv)"

alias gl="git log --oneline --decorate --graph --all"
alias gs="git status"
alias l='y'
alias ll='ls -lah'
alias python='python3'
alias gem='gemini'

alias vim='nvim'
alias codex='codex --search'

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
