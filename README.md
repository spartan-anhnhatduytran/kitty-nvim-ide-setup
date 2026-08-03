# kitty + Neovim IDE setup

One-command macOS setup for a kitty-terminal IDE: Neovim (LazyVim-style config,
Telescope, Neo-tree, LSP via Mason) wired to kitty splits with
[smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim), so
`Ctrl+hjkl` moves seamlessly between terminal panes and Neovim splits.

Forked from [thongnv701/dotfiles](https://github.com/thongnv701/dotfiles) — all
credit for the original Neovim/kitty/zsh configuration goes there. This fork
adds the `setup.sh` bootstrap script and an `ide.session` kitty layout, plus a
handful of fixes (see [CHANGES.md](CHANGES.md)).

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/spartan-anhnhatduytran/kitty-nvim-ide-setup/main/setup.sh | bash
```

Or clone first and run it locally:

```sh
git clone https://github.com/spartan-anhnhatduytran/kitty-nvim-ide-setup.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

The script:
1. Installs Homebrew if missing
2. Installs `kitty`, `neovim`, `stow`, `go`, `fd`, `ripgrep`
3. Clones this repo to `~/dotfiles` (skipped if already cloned)
4. Symlinks `kitty/` and `nvim/` config into `~/.config` via `stow`
5. Adds an `ide` alias to `~/.zshrc`
6. Installs all Neovim plugins headlessly (`lazy.nvim`) and the `gopls` LSP

Safe to re-run — every step is idempotent.

## Usage

Open a new terminal (or `source ~/.zshrc`), `cd` into any project, and run:

```sh
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

## Requirements

macOS only (uses Homebrew + kitty's macOS-specific config).
