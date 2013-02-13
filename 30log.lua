--[[
	Copyright (c) 2012 Roland Yonaba

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local type, pairs, setmetatable, baseMt, instances, classes, class = type, pairs, setmetatable, {}, {}, {}
local function deep_copy(t, dest)
  local r = dest or {}
  for k,v in pairs(t) do
    if type(v) == 'table' and k ~= "__index" then r[k] = deep_copy(v) else r[k] = v end
  end
  return r
end
local function instantiate(self,...)
  local instance = {} ; instances[instance] = tostring(instance)
  if self.__init then
		if type(self.__init) == 'table' then deep_copy(self.__init, instance) else self.__init(instance, ...) end
	end
  return setmetatable(instance,self)
end
local function extends(self,extra_params)
  local heirClass = class(extra_params)
  heirClass.__index, heirClass.super = heirClass, self
  return setmetatable(heirClass,self)
end
baseMt = { __call = function (self,...) return self:new(...) end, __tostring = function(self,...)
	if instances[self] then return ('object: <%s>'):format(instances[self]) end
	return classes[self] and ('class: <%s>'):format(classes[self]) or self
end}
class = function(members)
  local c = members and deep_copy(members) or {} ; classes[c] = tostring(c)
  c.new, c.extends, c.__index, c.__call, c.__tostring = instantiate, extends, c, baseMt.__call, baseMt.__tostring
	return setmetatable(c,baseMt)
end
return class