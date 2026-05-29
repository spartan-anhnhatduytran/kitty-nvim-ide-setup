return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local is_mac = jit.os == "OSX"
		local toggle_key = is_mac and [[<c-t>]] or [[<c-\>]]
		local shell = is_mac and os.getenv("SHELL") or "pwsh -NoExit"
		
		require("toggleterm").setup({
			size = 20,
			open_mapping = toggle_key,
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = "float",
			close_on_exit = true,
			shell = shell,
		})
	end,
}
