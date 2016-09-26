require 'luacov'
local class = require('30log')

context('class()', function()

	context('calling class() with no arguments', function()
		local aclass

		before(function() aclass = class() end)

		test('returns a new class', function()
			assert_type(aclass, 'table')
			assert_true(class.isClass(aclass))
		end)
		
		test('this class is unnamed', function()
			assert_nil(aclass.name)
		end)
	end)

	context('calling class(name)', function()
		local aclass
		local aclass_name = 'aclass'

		before(function() aclass = class(aclass_name) end)

		test('returns a new class', function()
			assert_type(aclass, 'table')
			assert_true(class.isClass(aclass))
		end)
		
		test('this class has the given name set', function()
			assert_equal(aclass.name, aclass_name)
		end)
	end)

	context('calling class(name, params)', function()
		local Point
		local params = {x = 0, y = 0}

		before(function() Point = class('Point', params) end)

		test('returns a class with attributes already set', function()
			assert_type(Point, 'table')
			assert_true(class.isClass(Point))
			assert_equal(Point.x, params.x)
			assert_equal(Point.y, params.y)
		end)
	end)

end)