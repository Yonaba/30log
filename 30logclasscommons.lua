local PATH = (...):match("^(.+)%.[^%.]+$") or ''
local class = require(PATH .. ".30log")

-- Interface for cross class-system compatibility
-- see https://github.com/bartbes/Class-Commons).
if common_class ~= false and not common then
  common = {}
  function common.class(name, prototype, parent)
    local klass = class():extends(parent):extends(prototype)
    klass.__init = prototype.init or (parent or {}).init
    return klass
  end
  function common.instance(class, ...)
    return class:new(...)
  end
end