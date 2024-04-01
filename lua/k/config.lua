local M = {}

-- Locals

local defaults = {
	path = "k",
	overwrite = false,
	outbuf = {
		float = false,
		float_opts = {
			relative = "editor",
			anchor = "NE",
			row = 0,
			col = function()
				return vim.o.columns
			end,
			width = 64,
			height = function()
				return vim.fn.winheight(0)
			end,
			border = "single",
			style = "minimal",
		},
	},
}

local options

-- Module

function M.setup(opts)
	options = vim.tbl_deep_extend("force", defaults, opts or {})
end

-- Get a copy of the config options, overridden with the provided table(s).
function M.get(...)
	if not options then
		M.setup()
	end

	local all = { {}, options }
	for i = 1, select("#", ...) do
		local opts = select(i, ...)
		if opts then
			table.insert(all, opts)
		end
	end

	return vim.tbl_deep_extend("force", unpack(all))
end

return setmetatable(M, {
	__index = function(_, key)
		if not options then
			M.setup()
		end
		return options[key]
	end,
})
