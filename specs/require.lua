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
	
	context('it should also contain the following fields:', function()

		test('a _DESCRIPTION field, type string', function()
			assert_type(class._DESCRIPTION, 'string')
		end)
		
		test('a _VERSION field, type string', function()
			assert_type(class._VERSION, 'string')
		end)		

		test('a _URL field, type string', function()
			assert_type(class._URL, 'string')
		end)
		
		test('a _LICENSE field, type string', function()
			assert_type(class._LICENSE, 'string')
		end)
		
	end)	
	
	test('class table should be callable', function()
		assert_not_error(class)
	end)
	
end)

context('require("30log-global")', function()
	
	before(function()
		require '30log-global'
	end)
	
	test('set a global "class"', function()
		assert_type(class, 'table')
	end)
	
	after(function()
		class = nil
	end)
	
end)