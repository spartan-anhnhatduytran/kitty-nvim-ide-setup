return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	build = "./kitty/install-kittens.bash",
	config = function()
		require("smart-splits").setup({
			default_amount = 3,
			at_edge = "stop",
		})

		local ss = require("smart-splits")

		-- Move between splits (Kitty passes these through when IS_NVIM is set)
		vim.keymap.set("n", "<C-h>", ss.move_cursor_left, { desc = "Move to left split/pane" })
		vim.keymap.set("n", "<C-j>", ss.move_cursor_down, { desc = "Move to lower split/pane" })
		vim.keymap.set("n", "<C-k>", ss.move_cursor_up, { desc = "Move to upper split/pane" })
		vim.keymap.set("n", "<C-l>", ss.move_cursor_right, { desc = "Move to right split/pane" })

		-- Resize splits (Kitty passes alt+hjkl through when IS_NVIM is set)
		vim.keymap.set("n", "<A-h>", ss.resize_left, { desc = "Resize left" })
		vim.keymap.set("n", "<A-j>", ss.resize_down, { desc = "Resize down" })
		vim.keymap.set("n", "<A-k>", ss.resize_up, { desc = "Resize up" })
		vim.keymap.set("n", "<A-l>", ss.resize_right, { desc = "Resize right" })
	end,
}
