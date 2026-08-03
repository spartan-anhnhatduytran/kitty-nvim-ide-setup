# Changes from upstream (thongnv701/dotfiles)

Fixes discovered while setting up the `ide` kitty+Neovim workflow.

## kitty

- `kitty.conf`: added `exe_search_path /opt/homebrew/bin` — GUI-launched kitty
  doesn't inherit a login shell's PATH, so `launch nvim` in a session file
  failed with "No such file or directory" even when Neovim was installed.
- `ide.session` (new): kitty session that opens Neovim (through a login shell,
  so it sees `brew`/`go`/`nvm`) plus a terminal pane below.
- Removed `pass_keys.py` — it was a 404 error page accidentally committed
  instead of the real smart-splits.nvim kitten; `install-kittens.bash`
  (run by the smart-splits.nvim Neovim plugin) copies the correct kittens in.

## Neovim — `plugins/telescope.lua`

- Telescope opens the selected file in whatever window was focused when the
  picker launched. If that's the Neo-tree sidebar, the file replaced the tree
  instead of opening in a code pane. Added `focus_code_window()`: steps out to
  a non-tree window before opening `find_files`/`live_grep`/`oldfiles`, and
  creates one via `vsplit` if none exists yet.

## Neovim — `plugins/neo-tree.lua`

- `window.mappings["<space>"] = "none"` — Neo-tree bound bare `<space>` to
  `toggle_node` with `nowait = true` by default, which swallowed the `<space>`
  leader key before a `<leader>ff`-style combo could fire while the tree was
  focused. `<CR>`/`o` still open/toggle nodes.

## Neovim — `plugins/auto-session.lua`

- `auto_session_enable_last_session = false` — restoring the *last* session
  regardless of cwd would pull in another project's layout.
- `pre_save_cmds = { "Neotree close" }` / `post_restore_cmds` /
  `no_restore_cmds` — Neo-tree's sidebar doesn't serialize into sessions
  cleanly; close it before saving, reopen after restore.
- Added a guarded `EnsureNeoTree` user command (used by `post_restore_cmds`/
  `no_restore_cmds` instead of a bare `Neotree show`): when Neovim starts with
  a path argument (e.g. `nvim .`), `hijack_netrw_behavior` converts that
  buffer into the tree on its own slightly after startup. Calling
  `Neotree show` unconditionally at the same time raced it and opened a
  second, independent tree instance. `EnsureNeoTree` skips entirely whenever
  `vim.fn.argc() > 0`, leaving `hijack_netrw` as the sole path in that case.

## Toolchain (not config, but required)

`setup.sh` installs these — Mason/Telescope silently fail without them:

- `go` — required by the `gopls` Mason LSP install
- `fd` — required by Telescope's `find_files` (`find_command` is hardcoded to it)
- `ripgrep` — required by Telescope's `live_grep`
- `neovim` itself — not installed by default on a fresh macOS machine
