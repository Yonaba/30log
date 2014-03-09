local assert, pairs, type, tostring, setmetatable = assert, pairs, type, tostring, setmetatable
local baseMt, _instances, _classes, class = {}, setmetatable({},{__mode='k'}), setmetatable({},{__mode='k'})
local function deep_copy(t, dest, aType)
  local t, r = t or {}, dest or {}
  for k,v in pairs(t) do
    if aType and type(v)==aType then r[k] = v elseif not aType then
      if type(v) == 'table' and k ~= "__index" then r[k] = deep_copy(v) else r[k] = v end
    end; end; return r
end
local function instantiate(self,...)
  assert(_classes[self],'new() should be called from a class.')
  local instance = deep_copy(self); _instances[instance] = tostring(instance); setmetatable(instance,self)
  if self.__init then if type(self.__init) == 'table' then deep_copy(self.__init, instance) else self.__init(instance, ...) end; end; return instance
end
local function extends(self,extra_params)
  local heir = {}; _classes[heir] = {tostring(heir), children={}}; _classes[self].children[#_classes[self].children] = heir
  deep_copy(extra_params, deep_copy(self, heir)); heir.__index, heir.super = heir, self; return setmetatable(heir,self)
end
baseMt = { __call = function (self,...) return self:new(...) end, __tostring = function(self,...) if _instances[self] then
  return ('object(of %s):<%s>'):format((rawget(getmetatable(self),'__name') or '?'), _instances[self]) end return _classes[self] and 
  ('class(%s):<%s>'):format((rawget(self,'__name') or '?'),_classes[self][1]) or self end, __newindex = function(self,key,value)
  rawset(self, key, value); for i=1, #_classes[self].children do _classes[self].children[i][key] = value; end
end}
class = function(attr)
  local c = deep_copy(attr); _classes[c] = {tostring(c), children={}};
  c.include = function(self,include) assert(_classes[self], 'Mixins can only be used on classes.'); return deep_copy(include, self, 'function') end
  c.new, c.extends, c.__index, c.__call, c.__tostring = instantiate, extends, c, baseMt.__call, baseMt.__tostring;
  c.is = function(self, kind) local super; while true do super = getmetatable(super or self) ; if super == kind or super == nil then break end ; end;
  return kind and (super == kind) end; return setmetatable(c,baseMt)
end; return class
