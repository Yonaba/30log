local assert, pairs, type, tostring, baseMt, _instances, _classes, class =  assert, pairs, type, tostring, {}, {}, {}
local function deep_copy(t, dest, aType)
  local t, r = t or {}, dest or {}
  for k,v in pairs(t) do
    if aType and type(v)==aType then r[k] = v elseif not aType then
      if type(v) == 'table' and k ~= "__index" then r[k] = deep_copy(v) else r[k] = v end
    end
  end; return r
end
local function instantiate(self,...)
  local instance = deep_copy(self) ; _instances[instance] = tostring(instance); setmetatable(instance,self)
  if self.__init then
    if type(self.__init) == 'table' then deep_copy(self.__init, instance) else self.__init(instance, ...) end
  end
  return instance
end
local function extends(self,extra_params)
  local heir = {}; _classes[heir] = tostring(heir); deep_copy(extra_params, deep_copy(self, heir));
  heir.__index, heir.super = heir, self; return setmetatable(heir,self)
end
baseMt = { __call = function (self,...) return self:new(...) end,
   __tostring = function(self,...)
    if _instances[self] then return ('object (of %s): <%s>'):format((rawget(getmetatable(self),'__name') or 'Unnamed'), _instances[self]) end
    return _classes[self] and ('class (%s): <%s>'):format((rawget(self,'__name') or 'Unnamed'),_classes[self]) or self
  end}
class = function(attr)
  local c = deep_copy(attr) ; _classes[c] = tostring(c);
  c.with = function(self,include) assert(_classes[self], 'Mixins can only be used on classes') return deep_copy(include, self, 'function') end
  c.new, c.extends, c.__index, c.__call, c.__tostring = instantiate, extends, c, baseMt.__call, baseMt.__tostring; return setmetatable(c,baseMt)
end; return class