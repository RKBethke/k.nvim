local M = {}

-- Locals

local defaults = {
	path = "k",
	postwin = {
		float = true,
	},
}

local options

-- Module

function M.setup(opts)
	local all = { defaults, opts or {} }
	options = vim.tbl_deep_extend("force", unpack(all))
end

return setmetatable(M, {
	__index = function(_, key)
		if not options then
			M.setup()
		end
		return options[key]
	end,
})
