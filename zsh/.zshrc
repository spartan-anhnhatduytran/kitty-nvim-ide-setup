export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
eval "$(zoxide init zsh)"
export PATH="$PATH:$(npm get prefix)/bin"

. "$HOME/.local/bin/env"
