return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				file_ignore_patterns = { "node_modules", ".git/", "dist/" },
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
				},
				live_grep = {
					additional_args = function()
						return { "--type-add", "wgsl:*.{wgsl,wesl}" }
					end,
				},
			},
		})

		vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", {
			desc = "Find files",
			silent = true,
		})
		 vim.keymap.set("n", "<leader>fw", ":Telescope live_grep<CR>", {
            desc = "Live grep current word",
            silent = true
        })
		vim.keymap.set("n", "<leader><leader>", ":Telescope oldfiles<CR>", {
			desc = "Recent files",
			silent = true,
		})
	end,
}
