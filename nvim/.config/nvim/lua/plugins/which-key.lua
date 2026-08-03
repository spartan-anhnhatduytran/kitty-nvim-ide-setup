-- Shows a popup listing available next keys whenever you press <leader> (or
-- any other prefix key) and pause. The single biggest discoverability win
-- for someone new to Neovim's leader-key shortcuts — no memorizing needed.
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		delay = 300,
	},
}
