local M = {}

-- Keep this in sync with the keymaps actually configured across
-- lua/plugins/*.lua — it's meant to be the one place a newbie can look
-- everything up without reading every plugin file.
local CONTENT = {
	"  Cheat Sheet — kitty + Neovim IDE",
	"  press q or <Esc> to close",
	"",
	"  NEW TO VIM? READ THIS FIRST",
	"    Neovim has modes — the bottom-left corner always shows which one:",
	"      NORMAL   shortcuts work (Space ff, gg, hjkl to move, etc.)",
	"      INSERT   you're typing code, like a normal text editor",
	"    Esc               Insert -> Normal (or type jk while in Insert)",
	"    i                 Normal -> Insert, cursor stays put",
	"    In a :terminal (LazyGit, a shell inside Neovim): plain Esc does",
	"    NOT leave — it's sent to the program instead. Use Ctrl+q.",
	"    Stuck? Press Space (leader) and wait half a second — a popup",
	"    lists every shortcut you can press next (which-key).",
	"",
	"  FIND & SEARCH",
	"    Space ff        Find files",
	"    Space fw        Live grep / search code",
	"    Space Space     Recent files",
	"",
	"  FILE EXPLORER (Neo-tree)",
	"    Space e         Toggle file tree",
	"    Space ef        Focus file tree",
	"    Enter / o       Open file, or open/close folder",
	"    z               Collapse all folders",
	"    W               Expand all folders",
	"",
	"  GIT",
	"    Space gg        LazyGit — full TUI (status/stage/commit/push)",
	"    Space gf        LazyGit — current file only",
	"    Space gn        Neogit status (staged/unstaged diff)",
	"    Space gd        Diff current file (inline split)",
	"    Space gD        Diffview — full working tree diff",
	"    Space gh        Preview hunk diff (floating popup)",
	"    Space gl        File history / diff log",
	"    Space gs        Stage hunk under cursor",
	"    Space gr        Reset (discard) hunk under cursor",
	"    Space gb        Toggle inline git blame",
	"    Space gB        Show full git blame for line",
	"    ]c / [c         Jump to next / previous changed hunk",
	"",
	"  PANES & WINDOWS (kitty)",
	"    Ctrl+h/j/k/l    Move between panes — works across kitty AND",
	"                    Neovim splits, whichever has focus",
	"    Alt+h/j/k/l     Resize the current pane/split",
	"    Cmd+Enter       New kitty pane (vertical split)",
	"    Cmd+Shift+Enter New kitty pane (horizontal split)",
	"",
	"  THIS CHEAT SHEET",
	"    Space ?         Toggle this panel",
}

function M.setup()
	vim.keymap.set("n", "<leader>?", function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.b[buf].is_cheatsheet then
				vim.api.nvim_win_close(win, true)
				return
			end
		end

		vim.cmd("botright vsplit")
		vim.cmd("vertical resize 50")

		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_win_set_buf(0, buf)
		vim.b[buf].is_cheatsheet = true

		vim.api.nvim_buf_set_lines(buf, 0, -1, false, CONTENT)
		vim.bo[buf].buftype = "nofile"
		vim.bo[buf].bufhidden = "wipe"
		vim.bo[buf].swapfile = false
		vim.bo[buf].modifiable = false
		vim.wo.wrap = false
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.wo.signcolumn = "no"

		local close = "<cmd>close<cr>"
		vim.keymap.set("n", "q", close, { buffer = buf, silent = true })
		vim.keymap.set("n", "<Esc>", close, { buffer = buf, silent = true })
	end, { desc = "Toggle cheat sheet" })
end

return M
