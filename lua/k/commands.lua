local M = {}

local va = vim.api

-- Locals

local function get_visual_lines()
	local vstart = vim.fn.getpos("'<")
	local vend = vim.fn.getpos("'>")
	return va.nvim_buf_get_lines(0, vstart[2], vend[2])
end

local function get_buffer_lines()
	return va.nvim_buf_get_lines(0, 0, -1, true)
end

-- Module

function M.eval(opts)
	local config = require("k.config")
	table.insert(config, opts or {})

	local origdir = vim.loop.cwd()
	local bufdir = vim.fn.expand("%:p:h")

	local lines = get_buffer_lines()
	if not lines then
		return
	end
	local program = table.concat(lines, "\n")

	local cmd = 'printf "' .. program .. '\n" | ' .. config.path .. " 2>&1"

	vim.cmd.cd(bufdir)
	local p = assert(io.popen(cmd))
	local output = p:read("*all")
	p:close()
	vim.cmd.cd(origdir)

	local out_lines = vim.split(output, "\n")
	require("k.postwin").post({ unpack(out_lines, 1, #out_lines - 1) })
end

return M
