return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = { "williamboman/mason.nvim" },
	config = function()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"clangd",
				"rust_analyzer",
				"ts_ls",
				"gopls",
				"wgsl_analyzer",
				"arduino_language_server",
			},
			automatic_installation = true,
			-- Kotlin is started manually as JetBrains kotlin-lsp in
			-- language-server-protocol.lua. Block mason from auto-enabling the
			-- fwcd kotlin_language_server (it conflicts and OOMs on big projects).
			-- arduino_language_server is started manually in plugins/arduino.lua
			-- with -cli/-clangd/-fqbn flags. The mason default cmd lacks them and
			-- would crash, so block auto-enable here too.
			automatic_enable = { exclude = { "kotlin_language_server", "arduino_language_server" } },
		})
	end,
}
