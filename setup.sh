#!/usr/bin/env bash
# One-click setup: kitty + Neovim IDE layout.
# Installs everything needed and symlinks this repo's config via GNU Stow.
#
# Usage:
#   ./setup.sh
#   ./setup.sh --doctor
#   curl -fsSL https://raw.githubusercontent.com/spartan-anhnhatduytran/kitty-nvim-ide-setup/main/setup.sh | bash
set -euo pipefail

REPO_URL="https://github.com/spartan-anhnhatduytran/kitty-nvim-ide-setup.git"
REPO_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

log()  { printf '\033[1;36m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$1"; }
ok()   { printf '  \033[1;32m✓\033[0m %s\n' "$1"; }
fail() { printf '  \033[1;31m✗\033[0m %s\n' "$1"; }

IDE_ALIAS_MARKER='alias ide='

# --- Doctor: health-check an existing install ------------------------------
run_doctor() {
  echo "devterm-style doctor — checking your kitty + Neovim IDE setup"
  echo ""
  local failed=0

  if command -v kitty >/dev/null 2>&1; then
    ok "kitty installed ($(kitty --version))"
  else
    fail "kitty not found"; failed=1
  fi

  if command -v nvim >/dev/null 2>&1; then
    ok "Neovim installed ($(nvim --version | head -1))"
  else
    fail "Neovim not found"; failed=1
  fi

  for tool in go fd rg stow; do
    if command -v "$tool" >/dev/null 2>&1; then
      ok "$tool installed"
    else
      fail "$tool not found (needed for gopls / Telescope / stow)"; failed=1
    fi
  done

  if [[ -L "$HOME/.config/kitty" && "$(readlink -f "$HOME/.config/kitty")" == "$REPO_DIR"* ]]; then
    ok "kitty config stowed (~/.config/kitty)"
  else
    fail "kitty config not linked — run: cd $REPO_DIR && stow kitty"; failed=1
  fi

  if [[ -L "$HOME/.config/nvim" && "$(readlink -f "$HOME/.config/nvim")" == "$REPO_DIR"* ]]; then
    ok "nvim config stowed (~/.config/nvim)"
  else
    fail "nvim config not linked — run: cd $REPO_DIR && stow nvim"; failed=1
  fi

  if grep -qF "$IDE_ALIAS_MARKER" "$HOME/.zshrc" 2>/dev/null; then
    ok "\`ide\` alias present in ~/.zshrc"
  else
    fail "\`ide\` alias missing from ~/.zshrc"; failed=1
  fi

  if [[ -x "$HOME/.local/share/nvim/mason/bin/gopls" ]]; then
    ok "gopls LSP installed"
  else
    fail "gopls not installed — run inside nvim: :MasonInstall gopls"; failed=1
  fi

  echo ""
  if [[ "$failed" -eq 0 ]]; then
    echo "All checks passed."
  else
    echo "Some checks failed — re-run ./setup.sh to fix them."
    exit 1
  fi
}

for arg in "$@"; do
  case "$arg" in
    --doctor)
      run_doctor
      exit 0
      ;;
    -h|--help)
      echo "Usage: ./setup.sh [--doctor] [-h|--help]"
      exit 0
      ;;
  esac
done

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
if ! grep -qF "$IDE_ALIAS_MARKER" "$HOME/.zshrc" 2>/dev/null; then
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
log "Check your setup anytime with: ./setup.sh --doctor"
