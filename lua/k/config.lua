local M = {}

local defaults = {
	path = "k"
}

function M.setup(opts)
	local all = { opts or {}, defaults }
	return vim.tbl_deep_extend("force", unpack(all))
end

return setmetatable(M, {
	__index = function(_, key)
		options or M.setup()
		return options[key]
	end,
})
