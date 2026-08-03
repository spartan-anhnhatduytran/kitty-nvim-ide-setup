return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diff view (working tree vs HEAD)" },
		{ "<leader>gl", "<cmd>DiffviewFileHistory %<cr>", desc = "File history / diff log" },
	},
	config = function()
		require("diffview").setup()
	end,
}
