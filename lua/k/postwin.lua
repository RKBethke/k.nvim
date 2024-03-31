local M = {}

local va = vim.api
local config = require("k.config")

-- Locals

M.win = nil
M.buf = nil

local function is_valid()
	return M.buf and va.nvim_buf_is_loaded(M.buf)
end

local function create()
	if is_valid() then
		return M.buf
	end
	local buf = va.nvim_create_buf(true, true)
	va.nvim_buf_set_option(buf, "filetype", "k")
	va.nvim_buf_set_name(buf, "[k]")
	M.buf = buf
	return buf
end

local function is_open()
	return M.win and va.nvim_win_is_valid(M.win)
end

function M.on_open()
	vim.opt_local.buftype = "nofile"
	vim.opt_local.bufhidden = "hide"
	vim.opt_local.swapfile = false
	local decorations = {
		"number",
		"relativenumber",
		"modeline",
		"wrap",
		"cursorline",
		"cursorcolumn",
		"foldenable",
		"list",
	}
	for _, s in ipairs(decorations) do
		vim.opt_local[s] = false
	end
end

local function open_float()
	local opts = {
		relative = "editor",
		anchor = "NE",
		row = 0,
		col = vim.o.columns,
		width = 64,
		height = 14,
		border = "single",
		style = "minimal",
	}
	return va.nvim_open_win(M.buf, false, opts)
end

local function open_split()
	vim.cmd("botright split")
	local id = va.nvim_get_current_win()
	va.nvim_win_set_buf(id, M.buf)
	vim.cmd([[ wincmd p ]])
	return id
end

-- Module

function M.open()
	if is_open() then
		return M.win
	end
	if not is_valid() then
		create()
	end

	M.win = config.postwin.float and open_float() or open_split()
	vim.api.nvim_win_call(M.win, M.on_open)
	return M.win
end

function M.post(output)
	if not is_valid() or not is_open() then
		M.open()
	end
	M.clear()

	va.nvim_buf_set_option(M.buf, "modifiable", true)
	va.nvim_buf_set_lines(M.buf, 0, -1, true, output)
	va.nvim_buf_set_option(M.buf, "modifiable", false)
end

function M.toggle()
	if is_open() then
		M.close()
	else
		M.open()
	end
end

function M.clear()
	if is_valid() then
		va.nvim_buf_set_option(M.buf, "modifiable", true)
		va.nvim_buf_set_lines(M.buf, 0, -1, true, {})
		va.nvim_buf_set_option(M.buf, "modifiable", false)
	end
end

function M.destroy()
	if is_open() then
		pcall(va.nvim_win_close, M.win, true)
		M.win = nil
	end
	if is_valid() then
		va.nvim_buf_delete(M.buf, { force = true })
		M.buf = nil
	end
	M.last_size = nil
end

return M
