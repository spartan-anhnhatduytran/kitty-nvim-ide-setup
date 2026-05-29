return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			enable_git_status = true,
			enable_diagnostics = true,
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
				},
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
				hijack_netrw_behavior = "open_current",
				use_libuv_file_watcher = true,
			},
			window = {
				width = 50,
				position = "left",
			},
		})

		vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Explorer", silent = true })
		vim.keymap.set("n", "<leader>ef", ":Neotree focus<CR>", { desc = "Focus Explorer", silent = true })
	end,
}
