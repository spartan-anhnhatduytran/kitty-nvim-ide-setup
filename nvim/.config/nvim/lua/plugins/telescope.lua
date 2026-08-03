return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local telescope = require("telescope")
		local action_state = require("telescope.actions.state")

		-- Telescope opens the selected file in whatever window was active when
		-- the picker was launched. If that's the Neo-tree sidebar, the picked
		-- file replaces the tree instead of appearing in the code pane. Step
		-- out to a non-tree window first so the sidebar always survives.
		local function focus_code_window()
			if vim.bo.filetype ~= "neo-tree" then
				return
			end
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				if vim.bo[buf].filetype ~= "neo-tree" then
					vim.api.nvim_set_current_win(win)
					return
				end
			end
			-- No code window exists yet (tree is the only window, e.g. right
			-- after startup) - open one instead of letting the file land in
			-- the tree's own window, which makes Neo-tree defensively re-open
			-- itself in a second split ("duplicated folder"). Must be `vnew`,
			-- not `vsplit`: `:vsplit` clones the CURRENT buffer (still the
			-- Neo-tree buffer) into the new window, which is the same bug by
			-- another path. `:vnew` opens a genuinely empty buffer instead.
			vim.cmd("vnew")
		end

		-- Jump cursor into the preview window to navigate with normal motions.
		-- <C-h> again (now buffer-local in the preview) returns to the prompt.
		local function focus_preview(prompt_bufnr)
			local picker = action_state.get_current_picker(prompt_bufnr)
			local previewer = picker.previewer
			if not previewer or not previewer.state or not previewer.state.winid then
				return
			end
			local prompt_win = picker.prompt_win
			vim.keymap.set("n", "<C-h>", function()
				vim.api.nvim_set_current_win(prompt_win)
			end, { buffer = previewer.state.bufnr })
			vim.api.nvim_set_current_win(previewer.state.winid)
		end

		telescope.setup({
			defaults = {
				file_ignore_patterns = { "node_modules", ".git/", "dist/", ".yarn/", "workers/", "__pycache__/", ".venv/", "venv/", "%.gz$", "%.zip$" },
				preview = {
					treesitter = true,
				},
				mappings = {
					i = { ["<C-h>"] = focus_preview },
					n = { ["<C-h>"] = focus_preview },
				},
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						preview_width = 0.55,
					},
				},
				path_display = function(_, path)
					local tail = require("telescope.utils").path_tail(path)
					local parent = vim.fn.fnamemodify(path, ":h")
					if parent == "." then
						return tail
					end
					return string.format("%-40s  %s", tail, parent)
				end,
			},
			pickers = {
				find_files = {
					hidden = true,
					find_command = {
						"fd", "--type", "f", "--hidden", "--follow",
						"--exclude", ".git",
						"--exclude", "node_modules",
						"--exclude", ".yarn",
						"--exclude", "workers",
						"--exclude", "__pycache__",
						"--exclude", ".venv",
						"--exclude", "venv",
					},
				},
				live_grep = {
					additional_args = function()
						return { "--type-add", "wgsl:*.{wgsl,wesl}" }
					end,
				},
			},
		})

		vim.keymap.set("n", "<leader>ff", function()
			focus_code_window()
			require("telescope.builtin").find_files()
		end, { desc = "Find files", silent = true })
		vim.keymap.set("n", "<leader>fw", function()
			focus_code_window()
			require("telescope.builtin").live_grep()
		end, { desc = "Live grep current word", silent = true })
		vim.keymap.set("n", "<leader><leader>", function()
			focus_code_window()
			require("telescope.builtin").oldfiles()
		end, { desc = "Recent files", silent = true })
	end,
}
