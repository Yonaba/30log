local PATH = (...):match("^(.+)%.[^%.]+$") or ''
local class = require(PATH .. ".30log")

local function table_clone(t)
  local copy = {}
  for k,v in pairs(t) do
    if type(v) == 'table' then
      copy[k] = table_clone(v)
    else
      copy[k] = v
    end
  end
  return copy
end

local function table_merge(dest, source)
  for k,v in pairs(source) do  
    dest[k] = v
  end
  return dest
end

-- Interface for cross class-system compatibility
-- see https://github.com/bartbes/Class-Commons).
if common_class ~= false and not common then
  common = {}
  function common.class(name, prototype, parent)
    local klass = table_merge(class(parent), prototype)
    klass.__init = prototype.init or (parent or {}).init
    return klass
  end
  function common.instance(class, ...)
    return class:new(...)
  end
end