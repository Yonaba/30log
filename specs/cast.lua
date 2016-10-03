require 'luacov'
local class = require('30log')

context(':cast() method', function()
	
	local A, B, a, b
	local cast_was_made, watch_init
	
	before(function()
		A = class('A')
		B = class('B')
		function A:init(a) 
			self.a = a
			if cast_was_made then watch_init = true end
		end
		function B:init(b) 
			self.b = b 
			if cast_was_made then watch_init = true end			
		end
		function A:methodA() return 'method from class A' end		
		function B:methodB() return 'method from class B' end		
		a = A('a')
		b = B('b')
		a:cast(B)
		b:cast(A)
		cast_was_made = true
		watch_init = false
	end)
	
	test('cannot be called from a class', function()
		assert_error(A.cast)
		assert_error(B.cast)
	end)

	test('when called from an instance, it expects a class as argument', function()
		assert_error(function() a:cast() end)
		assert_error(function() b:cast() end)		
		assert_not_error(function() a:cast(A) end)
		assert_not_error(function() b:cast(B) end)
	end)
	
	test('it does not call :init()', function()
		assert_false(watch_init)
	end)	
	
	context('When a cast is made, it changes the instance\'s superclass', function()
	
		test('instance.class points to the new class', function()
			assert_equal(a.class, B)
			assert_equal(b.class, A)
		end)
		
		test('as well as instance:instanceOf()', function()
			assert_false(a:instanceOf(A))
			assert_false(b:instanceOf(B))
			assert_true(a:instanceOf(B))
			assert_true(b:instanceOf(A))
		end)	
		
		test('and also getmetatable', function()
			assert_equal(getmetatable(a), B)
			assert_equal(getmetatable(b), A)
		end)

		test('instance looses access to its old class methods', function()
			assert_error(a.methodA)
			assert_error(b.methodB)
		end)	

		test('but it has access to its new class methods', function()
			assert_equal(a:methodB(), 'method from class B' )
			assert_equal(b:methodA(), 'method from class A')
		end)

		test('cast() will not affect an instance attributes, though', function()
			assert_equal(a.a, 'a')
			assert_equal(b.b, 'b')
		end)			
	
	end)
	
end)