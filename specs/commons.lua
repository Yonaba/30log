require 'luacov'
local common = require('30log-commons')

context('30log-commons', function()

	test('Existence of common.class', function()
		assert_type(common.class, 'function')
	end)

	test('Existence of common.instance', function()
		assert_type(common.instance, 'function')
	end)

	test('Creating a class', function()
		local class = {}
		class = common.class('class', class)
		assert_equal(class.name, 'class')
	end)

	test('Instantiation', function()
		local c = common.class('', {})
		local o = common.instance(c)
		assert_not_nil(o)
		assert_type(o, 'table')
	end)

	test('accessing members', function()
		local c = common.class("Accessing members", {member = true})
		local o = common.instance(c)
		assert_true(o.member)
	end)

	test('Inheritance', function()
		local c1 = common.class("Inheritance", {member = true})
		local c2 = common.class("Inheritance2", {}, c1)
		local o = common.instance(c2)
		assert_true(o.member)
	end)

	test('Calling members', function()
		local c = common.class("Calling members", {member = function() return true end})
		local o = common.instance(c)
		assert_not_error(o.member)
	end)

	test("Initializer", function()
		local initialized = false
		local c = common.class("Initializer", {init = function() initialized = true end})
		local o = common.instance(c)
		assert_true(initialized)
	end)

	test("Inherited Initializer", function()
		local initialized = false
		local c1 = common.class("Inherited Initializer", {init = function() initialized = true end})
		local c2 = common.class("Inherited Initializer2", {}, c1)
		local o = common.instance(c2)
		assert_true(initialized)
	end)

	test("Initializer available in derived classes", function()
		local initialized = false
		local c1 = common.class("Parent Class", {init = function() initialized = true end})
		local c2 = common.class("Derived Class", {init = function() assert(c1.init)() end})
		local o = common.instance(c2)
		assert_true(initialized)
	end)

end)