local M = {}

function M.eval(opts)
	local config = require("k.config")
	table.insert(config, opts or {})

	local origdir = vim.loop.cwd()
	local bufdir = vim.fn.expand("%:p:h")

	local program = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	if not program then
		return
	end

	local cmd = "echo " .. program .. '" | ' .. config.path

	vim.cmd.cd(bufdir)
	local p = assert(io.popen(cmd))
	local output = p:read("*all")
	local lines = vim.split(output, "\n")
	p:close()
	vim.cmd.cd(origdir)

	vim.api.nvim_command("botright new")
	vim.api.nvim_buf_set_option(0, "filetype", "k")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	vim.opt_local.modified = false

	vim.api.nvim_command("redraw!")
end
