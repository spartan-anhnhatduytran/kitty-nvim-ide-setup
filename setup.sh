#!/usr/bin/env bash
# One-click setup: kitty + Neovim IDE layout.
# Installs everything needed and symlinks this repo's config via GNU Stow.
#
# Usage:
#   ./setup.sh
#   curl -fsSL https://raw.githubusercontent.com/<user>/kitty-nvim-ide-setup/main/setup.sh | bash
set -euo pipefail

REPO_URL="https://github.com/spartan-anhnhatduytran/kitty-nvim-ide-setup.git"
REPO_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

log()  { printf '\033[1;36m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$1"; }

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This setup targets macOS only." >&2
  exit 1
fi

# --- 1. Homebrew -------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  log "Homebrew already installed"
fi

# --- 2. Packages ---------------------------------------------------------
# kitty        terminal emulator
# neovim       editor
# stow         symlinks this repo's config into $HOME
# go           required by the gopls LSP server
# fd, ripgrep  required by Telescope find_files / live_grep
PACKAGES=(stow neovim go fd ripgrep)
CASKS=(kitty)

log "Installing packages: ${PACKAGES[*]}"
brew install "${PACKAGES[@]}"

log "Installing casks: ${CASKS[*]}"
for cask in "${CASKS[@]}"; do
  brew list --cask "$cask" >/dev/null 2>&1 || brew install --cask "$cask"
done

# --- 3. Clone the dotfiles repo -----------------------------------------
if [[ -d "$REPO_DIR/.git" ]]; then
  log "Repo already at $REPO_DIR, pulling latest"
  git -C "$REPO_DIR" pull --ff-only
else
  log "Cloning $REPO_URL to $REPO_DIR"
  git clone "$REPO_URL" "$REPO_DIR"
fi

# --- 4. Symlink config via stow ------------------------------------------
cd "$REPO_DIR"
log "Stowing kitty + nvim config"
stow -v kitty nvim

# --- 5. Wire the `ide` alias into zsh -------------------------------------
IDE_ALIAS='alias ide='"'"'kitty --session ~/.config/kitty/ide.session --directory "$(pwd)" --detach'"'"''
if ! grep -qF "$IDE_ALIAS" "$HOME/.zshrc" 2>/dev/null; then
  log "Adding \`ide\` alias to ~/.zshrc"
  {
    echo ""
    echo "# Kitty IDE mode: open new kitty window with nvim + terminal at current dir"
    echo "$IDE_ALIAS"
  } >> "$HOME/.zshrc"
else
  log "\`ide\` alias already present in ~/.zshrc"
fi

# --- 6. Bootstrap Neovim plugins + LSPs headlessly ------------------------
log "Installing Neovim plugins (lazy.nvim sync)..."
nvim --headless "+Lazy! sync" +qa

log "Installing gopls LSP server..."
nvim --headless "+MasonInstall gopls" +qa || warn "gopls install failed, retry inside nvim with :Mason"

log "Done. Open a new terminal (or 'source ~/.zshrc'), cd into any project, and run: ide"
