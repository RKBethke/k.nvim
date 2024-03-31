local M = {}

function M.setup(opts)
	require("").setup(opts)
end

return setmetatable(M, {
	__index = function(_, k)
		return require("k.commands")[k]
	end,
})
