require 'luacov'
local class = require '30log'

context('Introspection', function()
  
  context('class.isClass(class, superclass)', function()
	
		local superclass, aclass, notaclass
		
		before(function() 
			superclass = class()
			aclass = superclass:extend()
			notaclass = {}
		end)
	
    test('returns true if "class" is a class',function()
			assert_true(class.isClass(aclass))
			assert_false(class.isClass(notaclass))
    end)
		
    test('and false if it is not',function()
			assert_false(class.isClass(notaclass))
    end)		
		
    test('returns true if "class" is a subclass of "superclass"',function()
			assert_true(class.isClass(aclass, superclass))
			assert_false(class.isClass(superclass, aclass))
    end)
		
    test('and false if it is not',function()
			assert_false(class.isClass(superclass, aclass))
    end)		
		
		test("class.super returns the direct superclass too",function()
			assert_equal(aclass.super, superclass)
		end)

	end)

  context('class.isInstance(instance, class)', function()
	
		local aclass, instance, notaninstance
		
		before(function() 
			aclass = class()
			instance = aclass()
			notaninstance = {}
		end)
	
    test('returns true if it is an instance',function()
			assert_true(class.isInstance(instance))
			assert_false(class.isInstance(notaninstance))
    end)
		
    test('and false if it is not',function()
			assert_false(class.isInstance(notaninstance))
    end)
		
    test('returns true if "class" is the class of "instance"',function()
			assert_true(class.isInstance(instance, aclass))
    end)
		
    test('and false if it is not',function()
			assert_false(class.isInstance(aclass, instance))
    end)		

		test("instance.class returns the class of an instance too",function()
			assert_equal(instance.class, aclass)
		end)

	end)
	
	context('extends()', function()
		
		local A, AA, AAA
		
		before(function()
			A = class()
			AA = A:extend()
			AAA = AA:extend()
		end)
		
		test('returns true if a passed-in class inherits from a class', function()
			assert_true(AA:extends(A))
			assert_true(AAA:extends(A))
			assert_true(AAA:extends(AA))
		end)
	
		test('and false if not', function()
			assert_false(A:extends(AA))
			assert_false(A:extends(AAA))
			assert_false(AA:extends(AAA))
		end)
		
	end)
	
end)