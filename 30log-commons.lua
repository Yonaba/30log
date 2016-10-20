-- 30log-commons.lua, Interface for Class-Commons, (c) 2012 TsT2005
-- Class-Commons <https://github.com/bartbes/Class-Commons>

local class = require('30log')

return {
	class = function(name, prototype, parent)
		local klass = class():extend(nil,parent):extend(nil,prototype)
		klass.init = prototype.init or (parent or {}).init
		klass.name = name
		return klass
	end,
	
	instance = function(class, ...)
		return class:new(...)
	end
}