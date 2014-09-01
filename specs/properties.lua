require 'luacov'
local Class = require '30log'

context('Properties', function()

  test('can be defined and accessed', function()
    local theClass = Class()
    theClass:property("prop", function(self) return 1 end, nil)

    local instance = theClass()

    assert_true(instance.prop ~= nil)
    assert_equal(instance.prop, 1)
  end)

  test('can be set and read using anonymous methods', function()
    local theClass = Class()
    function theClass:__init() self.value = 0 end
    theClass:property("prop",
        function(self) return self.value end,
        function(self, value) self.value = value end
    )

    local instance = theClass()

    assert_equal(instance.prop, instance.value)
    assert_equal(instance.prop, 0)
    instance.prop = 2
    instance.prop = 1
    assert_equal(instance.prop, instance.value)
    assert_equal(instance.prop, 1)
    instance.prop = 2e8
    assert_equal(instance.prop, instance.value)
    assert_equal(instance.prop, 2e8)
  end)

  test('can be inherited', function()
    local theClass = Class()
    function theClass:__init() self.value = 0 end
    function theClass:getProperty() return self.value end
    function theClass:setProperty(value) self.value = value end
    theClass:property("prop", "getProperty", "setProperty")

    local inheritedClass = theClass:extends()
    local inheritedInstance = inheritedClass()

    assert_equal(inheritedInstance.prop, inheritedInstance.value)
    assert_equal(inheritedInstance.prop, 0)
    inheritedInstance.prop = 1
    assert_equal(inheritedInstance.prop, inheritedInstance.value)
    assert_equal(inheritedInstance.prop, 1)
    inheritedInstance.prop = 2e8
    assert_equal(inheritedInstance.prop, inheritedInstance.value)
    assert_equal(inheritedInstance.prop, 2e8)
  end)

  test("it's possible to replace class getter/setter methods in a subclass", function()
    local theClass = Class()
    function theClass:__init() self.value = 0 end
    function theClass:getProperty() return self.value end
    function theClass:setProperty(value) self.value = value end
    theClass:property("prop", "getProperty", "setProperty")

    local inheritedClass = theClass:extends()
    function inheritedClass:getProperty() return self.value * 2 end
    function inheritedClass:setProperty(value) self.value = value * 2 end

    local inheritedInstance = inheritedClass()

    assert_equal(inheritedInstance.prop, 0)
    inheritedInstance.prop = 1
    assert_equal(inheritedInstance.prop, inheritedInstance.value * 2)
    assert_equal(inheritedInstance.prop, 4)
    inheritedInstance.prop = 2e8
    assert_equal(inheritedInstance.prop, inheritedInstance.value * 2)
    assert_equal(inheritedInstance.prop, 2e8 * 4)
  end)

  test("can be declared as read-only", function()
    local theClass = Class()

    function theClass:__init() self.value = 42 end
    function theClass:getProperty() return self.value end

    theClass:property("prop", "getProperty", nil)

    local instance = theClass()

    assert_equal(instance.prop, instance.value)
    assert_equal(instance.prop, 42)
    assert_error(function() instance.prop = 42 end)
    assert_error(function() instance.prop = 0 end)
    assert_error(function() instance.prop = 3e44 end)
  end)

  test("can be declared as write-only", function()
    local theClass = Class()
    function theClass:__init() self.value = 42 end
    function theClass:setProperty(value) self.value = value end
    theClass:property("prop", nil, "setProperty")

    local instance = theClass()

    assert_equal(instance.value, 42)
    assert_error(function() return instance.prop end)
    instance.prop = 13
    assert_equal(instance.value, 13)
    assert_error(function() return instance.prop end)
    instance.prop = 7e3 + 123
    instance.prop = 5e7 + 321337
    instance.prop = 12
    assert_equal(instance.value, 12)
    assert_error(function() return instance.prop end)
  end)

  test("can be declared as unwriteable and unreadable", function()
    local theClass = Class()
    theClass:property("prop", nil, nil)

    local instance = theClass()

    assert_error(function() return instance.prop end)
    assert_error(function() instance.prop = 12 end)
  end)

end)

