local M = {}

local va = vim.api

-- Locals

local function get_visual_lines()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local cline, ccol = cursor[1], cursor[2]
	local vline, vcol = vim.fn.line("v"), vim.fn.col("v")

	local sline, scol
	local eline, ecol
	if cline == vline then
		if ccol <= vcol then
			sline, scol = cline, ccol
			eline, ecol = vline, vcol
			scol = scol + 1
		else
			sline, scol = vline, vcol
			eline, ecol = cline, ccol
			ecol = ecol + 1
		end
	elseif cline < vline then
		sline, scol = cline, ccol
		eline, ecol = vline, vcol
		scol = scol + 1
	else
		sline, scol = vline, vcol
		eline, ecol = cline, ccol
		ecol = ecol + 1
	end

	return va.nvim_buf_get_lines(0, sline - 1, eline, 0)
end

local function get_buffer_lines()
	return va.nvim_buf_get_lines(0, 0, -1, true)
end

local function run_k(cmd)
	local origdir = vim.loop.cwd()
	local bufdir = vim.fn.expand("%:p:h")

	vim.cmd.cd(bufdir)
	local p = assert(io.popen(cmd))
	local output = p:read("*all")
	p:close()
	vim.cmd.cd(origdir)

	return vim.split(output, "\n")
end

-- Module

function M.eval(opts)
	local config = require("k.config")
	table.insert(config, opts or {})

	local lines = get_buffer_lines()
	if not lines then
		return
	end
	local program = table.concat(lines, "\n")
	local cmd = 'printf "' .. program .. '\n" | ' .. config.path .. " 2>&1"
	require("k.postwin").post(run_k(cmd))
end

function M.eval_selection(opts)
	local config = require("k.config")
	table.insert(config, opts or {})

	local lines = get_visual_lines()
	if not lines then
		return
	end
	local program = table.concat(lines, "\n")
	local cmd = 'printf "' .. program .. '\n" | ' .. config.path .. " 2>&1"
	require("k.postwin").post(run_k(cmd))
end

function M.clear()
	require("k.postwin").clear()
end

return M
