local M = {}

local va = vim.api

-- Locals

local function get_lines(buffer, sidx, eidx, strict_indexing)
	local lines = va.nvim_buf_get_lines(buffer, sidx, eidx, strict_indexing)
	if not lines or not #lines then
		return nil
	end

	-- Remove shebang
	if sidx == 0 and string.find(lines[1], "^#!.*k") then
		lines = { unpack(lines, 2) }
	end

	-- Remove comments and join lines
	local prog = ""
	for _, l in ipairs(lines) do
		if not string.find(l, "^/") then
			prog = prog .. l .. "\n"
		end
	end

	return prog
end

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

	return get_lines(0, sline - 1, eline, false)
end

local function get_buffer_lines()
	return get_lines(0, 0, -1, true)
end

local function run_k(path, stdin)
	local origdir = vim.loop.cwd()
	local bufdir = vim.fn.expand("%:p:h")

	vim.cmd.cd(bufdir)
	local output = vim.fn.system(path, stdin)
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

	require("k.outbuf").post(run_k(config.path, lines))
end

function M.eval_selection(opts)
	local config = require("k.config")
	table.insert(config, opts or {})

	local lines = get_visual_lines()
	if not lines then
		return
	end

	require("k.outbuf").post(run_k(config.path, lines))
end

function M.outbuf_toggle()
	require("k.outbuf").toggle()
end

function M.outbuf_clear()
	require("k.outbuf").clear()
end

return M
