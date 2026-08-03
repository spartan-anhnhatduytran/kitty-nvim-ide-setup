-- nvim v0.8.0
return {
	"kdheepak/lazygit.nvim",
	lazy = true,
	cmd = {
		"LazyGitConfig",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	-- lazy.nvim only loads this plugin (and runs config(), which is where
	-- <leader>gg/<leader>gf actually get bound) when one of `cmd` or `keys`
	-- fires. Without listing the keys here too, they silently never work.
	keys = {
		"<leader>gg",
		"<leader>gf",
	},
	-- optional for floating window border decoration
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		-- lazygit.nvim's own :LazyGit command reuses/caches an internal
		-- scratch buffer and calls jobstart(..., {term=true}) inside a
		-- vim.schedule() callback. On very recent Neovim (0.12+) that
		-- combination intermittently fails with "requires unmodified
		-- buffer" depending on the previously-current buffer's state —
		-- the plugin is at its latest upstream commit, not fixed there
		-- yet. `:new` unconditionally creates a fresh, always-unmodified
		-- buffer, sidestepping the plugin's internal reuse logic entirely.
		local function open_lazygit(extra_args)
			vim.cmd("botright new")
			vim.cmd("resize 20")
			local cmd = { "lazygit" }
			if extra_args then
				vim.list_extend(cmd, extra_args)
			end
			vim.fn.jobstart(cmd, { term = true })
			vim.bo.buflisted = false
			vim.api.nvim_create_autocmd("TermClose", {
				buffer = vim.api.nvim_get_current_buf(),
				once = true,
				callback = function()
					vim.cmd("bd!")
				end,
			})
			vim.cmd("startinsert")
		end

		vim.keymap.set("n", "<leader>gg", function()
			open_lazygit()
		end, { desc = "LazyGit" })

		vim.keymap.set("n", "<leader>gf", function()
			open_lazygit({ "-f", vim.fn.expand("%") })
		end, { desc = "LazyGit Current File" })
	end,
}
