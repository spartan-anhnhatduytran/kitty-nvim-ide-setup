# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS SHARE_HISTORY

# Prefix search on up/down arrow
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
eval "$(zoxide init zsh)"
export PATH="$PATH:$(npm get prefix)/bin"

. "$HOME/.local/bin/env"

# bun completions
[ -s "/Users/thongnguyen/.bun/_bun" ] && source "/Users/thongnguyen/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export ANTHROPIC_MODEL="claude-opus-4-8"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export FLYWAY_DIR=/opt/homebrew/opt/flyway/libexec
alias pio="$HOME/.platformio/penv/bin/pio"
alias lich="curl lich.day"
alias lichthang="curl lich.day/\$(date +%Y%m)"

# Kitty IDE mode: open new kitty window with nvim + terminal at current dir
alias ide='kitty --session ~/.config/kitty/ide.session --directory "$(pwd)" --detach'
