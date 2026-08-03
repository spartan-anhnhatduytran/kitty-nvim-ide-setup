# kitty-nvim-ide-setup

> One command to the terminal IDE senior devs spend a weekend configuring.

[![macOS](https://img.shields.io/badge/macOS-12%2B-brightgreen.svg)](https://www.apple.com/macos/)
[![Terminal: kitty](https://img.shields.io/badge/terminal-kitty-1a1b26.svg)](https://sw.kovidgoyal.net/kitty/)
[![Editor: Neovim](https://img.shields.io/badge/editor-Neovim-57A143.svg)](https://neovim.io)
[![Shell: zsh](https://img.shields.io/badge/shell-zsh-blue.svg)](https://www.zsh.org/)

---

```bash
curl -fsSL https://raw.githubusercontent.com/spartan-anhnhatduytran/kitty-nvim-ide-setup/main/setup.sh | bash
```

---

## What is this?

A one-command bootstrap for a **kitty + Neovim terminal IDE**: file tree, fuzzy
finder, LSP, and pane navigation that feels like a real editor — but it's just
a terminal.

Run the script on a fresh macOS machine and get the full setup — Neovim
plugins, LSPs, and a kitty session layout — in a couple of minutes.

**Stack:** [kitty](https://sw.kovidgoyal.net/kitty/) ·
[Neovim](https://neovim.io) + [lazy.nvim](https://github.com/folke/lazy.nvim) ·
[Telescope](https://github.com/nvim-telescope/telescope.nvim) ·
[Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) ·
[Mason](https://github.com/williamboman/mason.nvim) ·
[smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim)

Forked from [thongnv701/dotfiles](https://github.com/thongnv701/dotfiles) — all
credit for the original Neovim/kitty/zsh configuration goes there. This fork
adds the one-click `setup.sh`, the `ide` kitty session layout, and a handful of
fixes for duplicate file-tree windows and missing CLI dependencies (see
[CHANGES.md](CHANGES.md) for the full list and why each one was needed).

---

## Quick Start

**One-liner (recommended):**
```bash
curl -fsSL https://raw.githubusercontent.com/spartan-anhnhatduytran/kitty-nvim-ide-setup/main/setup.sh | bash
```

**Or clone and run:**
```bash
git clone https://github.com/spartan-anhnhatduytran/kitty-nvim-ide-setup.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

Safe to re-run — every step checks if it's already done and skips it.

---

## What Gets Installed

| Component | Purpose | Skip if present |
|-----------|---------|------------------|
| **kitty** | GPU-accelerated terminal emulator | ✓ |
| **Neovim** | Editor | ✓ |
| **stow** | Symlinks this repo's config into `~/.config` | ✓ |
| **go** | Required by the `gopls` LSP install | ✓ |
| **fd** | Required by Telescope's `find_files` | ✓ |
| **ripgrep** | Required by Telescope's `live_grep` | ✓ |
| **~50 Neovim plugins** | Telescope, Neo-tree, LSP, completion, treesitter, etc. | ✓ |
| **gopls** (via Mason) | Go LSP server | ✓ |

The script also:
- Clones this repo to `~/dotfiles` (or pulls if already cloned)
- Symlinks `kitty/` and `nvim/` config via `stow`
- Adds an `ide` alias to `~/.zshrc`

---

## Usage

Open a new terminal (or `source ~/.zshrc`), `cd` into any project, and run:

```bash
ide
```

This opens a new kitty window with:
- Neo-tree file explorer on the left
- Neovim editor on the right
- A terminal pane below

### Keymaps

| Keys | Action |
|---|---|
| `Space ff` | Find files (Telescope) |
| `Space fw` | Live grep / search code (Telescope) |
| `Space Space` | Recent files |
| `Space e` | Toggle file explorer |
| `Ctrl+h/j/k/l` | Move between kitty panes / Neovim splits (auto-detects which) |
| `Alt+h/j/k/l` | Resize panes/splits |
| `Cmd+Enter` | New kitty pane (vertical split) |
| `Cmd+Shift+Enter` | New kitty pane (horizontal split) |

---

## Doctor Command

Run `./setup.sh --doctor` to verify your setup is working correctly:

```
devterm-style doctor — checking your kitty + Neovim IDE setup

  ✓ kitty installed (kitty 0.48.2 created by Kovid Goyal)
  ✓ Neovim installed (NVIM v0.12.4)
  ✓ go installed
  ✓ fd installed
  ✓ rg installed
  ✓ stow installed
  ✓ kitty config stowed (~/.config/kitty)
  ✓ nvim config stowed (~/.config/nvim)
  ✓ `ide` alias present in ~/.zshrc
  ✓ gopls LSP installed

All checks passed.
```

---

## Options

```
./setup.sh [OPTIONS]

  --doctor      Check your setup for issues, no install
  -h, --help    Show help
```

---

## Requirements

- macOS 12 (Monterey) or later
- Homebrew (auto-installed if missing)
- Internet connection (for downloading components)

---

## Uninstall

```bash
# Remove installed components
brew uninstall kitty neovim stow go fd ripgrep

# Remove the config symlinks
cd ~/dotfiles && stow -D kitty nvim

# Remove the `ide` alias — delete the block it added at the bottom of ~/.zshrc

# Remove the repo
rm -rf ~/dotfiles
```

## License

Configuration inherited from [thongnv701/dotfiles](https://github.com/thongnv701/dotfiles)
retains its original terms. `setup.sh`, this README, and `CHANGES.md` — added
in this fork — are released under no additional restrictions; use them freely.
