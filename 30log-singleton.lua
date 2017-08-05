-- 30log-singleton.lua, singleton pattern implementation
-- (c) 2015, R. Yonaba

local class = require '30log-plus'
local SingletonClass = class("Singleton")
local instance = SingletonClass()

function SingletonClass.new()
  error('Cannot instantiate from a Singleton class')
end
function SingletonClass.init() end

function SingletonClass.extend()
  error('Cannot extend from a Singleton class')
end

function SingletonClass:getInstance()
  return instance
end

return SingletonClass

