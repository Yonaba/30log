require 'luacov'
context('require("30log")', function()

	local class
	
	before(function() class = require '30log' end)
	
	test('should return a table',function()
		assert_type(class, 'table')
	end)
	
	context('this table should contain the following keys and values:', function()

		test('a function named "isClass"', function()
			assert_type(class.isClass, 'function')
		end)

		test('a function named "isInstance"', function()
			assert_type(class.isInstance, 'function')
		end)			
		
	end)
	
	test('class table should be callable', function()
		assert_not_error(class)
	end)
	
end)

context('require("30logglobal")', function()
	
	before(function()
		require '30logglobal'
	end)
	
	test('set a global "class"', function()
		assert_type(class, 'table')
	end)
	
end)