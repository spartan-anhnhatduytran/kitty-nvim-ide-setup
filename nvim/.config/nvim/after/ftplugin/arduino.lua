-- Arduino / IoT (.ino) per-buffer setup. Runs natively for every arduino
-- buffer (no lazy plugin spec, so it cannot collide with nvim-lspconfig).
--
-- Tooling (install once, outside nvim):
--   brew install arduino-cli
--   arduino-cli config init
--   arduino-cli core update-index
--   arduino-cli core install esp32:esp32 esp8266:esp8266
-- arduino-language-server is installed by mason (ensure_installed).
--
-- Per-sketch board override: sketch.yaml next to the .ino with e.g.
--   default_fqbn: esp8266:esp8266:nodemcuv2
-- Else DEFAULT_FQBN below. List boards: arduino-cli board listall.

local DEFAULT_FQBN = "esp32:esp32:esp32"

local buf = vim.api.nvim_get_current_buf()

local function sketch_root()
	return vim.fs.root(buf, { "sketch.yaml", ".git" })
		or vim.fs.dirname(vim.api.nvim_buf_get_name(buf))
end

-- Resolve FQBN: sketch.yaml default_fqbn wins over DEFAULT_FQBN.
local function resolve_fqbn(root)
	local yaml = root .. "/sketch.yaml"
	if vim.fn.filereadable(yaml) == 1 then
		for _, line in ipairs(vim.fn.readfile(yaml)) do
			local v = line:match("^%s*default_fqbn:%s*(.+)%s*$")
			if v then
				return vim.trim(v:gsub('["\']', ""))
			end
		end
	end
	return DEFAULT_FQBN
end

-- Start arduino-language-server (wraps clangd + arduino-cli, board-aware).
local als = vim.fn.exepath("arduino-language-server")
local arduino_cli = vim.fn.exepath("arduino-cli")
local clangd = vim.fn.exepath("clangd")

if als ~= "" and arduino_cli ~= "" then
	local cli_config = vim.fn.expand("~/Library/Arduino15/arduino-cli.yaml")
	if vim.fn.filereadable(cli_config) == 0 then
		cli_config = vim.fn.expand("~/.arduino15/arduino-cli.yaml")
	end

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local ok, cmp = pcall(require, "cmp_nvim_lsp")
	if ok then
		capabilities = cmp.default_capabilities(capabilities)
	end

	local root = sketch_root()
	vim.lsp.start({
		name = "arduino_language_server",
		cmd = {
			als,
			"-cli", arduino_cli,
			"-cli-config", cli_config,
			"-clangd", clangd,
			"-fqbn", resolve_fqbn(root),
		},
		root_dir = root,
		capabilities = capabilities,
	})
else
	vim.notify("arduino-cli / arduino-language-server not found", vim.log.levels.WARN)
end

-- Compile / upload / monitor keymaps (buffer-local).
local function run(cmd)
	vim.cmd("split | terminal " .. cmd)
end

local root = sketch_root()
local fqbn = resolve_fqbn(root)
vim.keymap.set("n", "<leader>ac", function()
	run("arduino-cli compile -b " .. fqbn .. " " .. root)
end, { buffer = buf, desc = "Arduino compile" })
vim.keymap.set("n", "<leader>au", function()
	run("arduino-cli upload -b " .. fqbn .. " " .. root)
end, { buffer = buf, desc = "Arduino upload" })
vim.keymap.set("n", "<leader>am", function()
	vim.ui.input({ prompt = "Serial port (e.g. /dev/cu.usbserial-*): " }, function(port)
		if port and port ~= "" then
			run("arduino-cli monitor -p " .. port)
		end
	end)
end, { buffer = buf, desc = "Arduino serial monitor" })
