-- In lua/plugins/treesitter.lua
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	config = function()
		-- Register wgsl file type
		vim.filetype.add({ extension = { wgsl = "wgsl", wesl = "wesl" } })

		-- Arduino sketches: own filetype (not cpp, so clangd does not also
		-- attach), but reuse the cpp tree-sitter parser for highlighting since
		-- no "arduino" parser exists. LSP handled in after/ftplugin/arduino.lua.
		vim.filetype.add({ extension = { ino = "arduino", pde = "arduino" } })
		vim.treesitter.language.register("cpp", "arduino")

		-- Configure wgsl parser
		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
		parser_config.wgsl = {
			install_info = {
				url = "https://github.com/szebniok/tree-sitter-wgsl",
				files = { "src/parser.c", "src/scanner.c" },
			},
		}

		require("nvim-treesitter.configs").setup({
			ensure_installed = { "wgsl", "kotlin", "java", "cpp" },
			sync_install = false,
			auto_install = false,  -- CRITICAL - prevents auto-compilation conflicts
			ignore_install = { "tsx", "typescript", "javascript", "vimdoc" },
			
			highlight = { enable = true },
			indent = { enable = true },
		})

		-- Windows-specific fixes
		require("nvim-treesitter.install").prefer_git = false
		require("nvim-treesitter.install").compilers = { "zig", "cl", "clang", "gcc" }
		
		-- Prevent concurrent installations
		vim.g.loaded_tree_sitter_install = 1
	end,
}