-- Expected the class implementation to be passed as arg
local class = require(...)

-- Test API
local collectgarbage = collectgarbage
local ipairs = ipairs
local clock = os.clock

local tests = {}
local results = {}

local function addTest(description, f)
  tests[#tests+1] = {name = description, f = f}
end

local function benchmark(code, times)
  local final_memory, final_time
  local init_memory = collectgarbage('count')
  local init_time = os.clock()
  for i = 1, (times or 1) do code() end
  final_time = os.clock()
  collectgarbage()
  final_memory = collectgarbage('count')
  return (final_time-init_time),(final_memory-init_memory)
end

local function runAll(tests, eachTestTimes)
  for i, test in ipairs(tests) do
    local time, memUsed = benchmark(test.f, eachTestTimes)
    print(('%02d. %09s (%dx): %.3fs %04d kiB')
      :format(i, test.name, eachTestTimes, time, memUsed))
  end
end

-- Tests
local klass
addTest('Creating a class', function()
  klass = class()
end)

local klass = class()
local instance

addTest('Creating an instance (function call style)', function()
  instance = klass()
end)

addTest('Creating an instance (using new())', function()
  instance = klass:new()
end)

klass.attribute = 0
instance = klass()

addTest('Direct access to instance attribute', function()
  local attr = instance.attribute
end)

function klass:getAttribute()
  return self.attribute
end

addTest('Accessing instance attribute through getter', function()
  local attr = instance:getAttribute()
end)

function klass:setAttribute(value)
  self.attribute = value
end

addTest('Accessing instance attribute through setter', function()
  instance:setAttribute(1)
end)

local derivedKlass
addTest('Extending from a class', function()
  derivedKlass = klass:extends()
end)

local derivedKlass = klass:extends()
local derivedInstance = derivedKlass()

addTest('Indexing inherited attribute (1-lvl depth)', function()
  local attr = derivedInstance.attribute
end)

addTest('Calling inherited method (1-lvl depth)', function()
  local attr = derivedInstance:getAttribute()
end)

addTest('Calling inherited setter method (1-lvl depth)', function()
  derivedInstance:setAttribute(1)
end)

-- Running all tests
runAll(tests, 1e5)