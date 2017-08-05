-- @LICENSE MIT
-- @author: CPE

return function(base, handlers)
	for handler, callbacks in pairs(handlers) do

		base[handler] = function(...)
			local cache = setmetatable({}, {__mode = 'k'})
			for _, callback in ipairs(callbacks) do
				if cache[callback] then return true end
				cache[callback] = true
				local res = callback(...)
				if not res then return false end
			end
			return true
		end
	end
end