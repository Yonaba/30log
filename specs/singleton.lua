require 'luacov'

local SingletonClass = require '30log-singleton'
local class = require '30log'

context('30log is distributed with a default singleton class implementation', function()

	context('This SingletonClass', function()
	
		local singletonInstance
		
		before(function()
			singletonInstance = SingletonClass:getInstance()
		end)

		test('is recognized as a class', function()
			assert_true(class.isClass(SingletonClass))
		end)
		
		test('is named "Singleton"', function()
			assert_equal(SingletonClass.name, "Singleton")
		end)
		
		test('this class cannot instantiate', function()
			assert_error(SingletonClass)
		end)
		
		test('and cannot be derived to make new classes.', function()
			assert_error(SingletonClass.extend)
		end)
		
		test('It implements a method named "getInstance"', function()
			assert_equal(type(SingletonClass.getInstance), "function")
		end)
		
		test('which returns a private local instance of the SingletonClass', function()
			assert_true(singletonInstance:instanceOf(SingletonClass))
			assert_equal(singletonInstance.class, SingletonClass)
		end)		
		
	end)

end)
