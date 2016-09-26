require 'luacov'
local class = require('30log')

local function revert_and_count(t)
	local _t, n = {}, 0
	for _, v in pairs(t) do
		_t[v] = true
		n = n + 1
	end
	_t.n = n
	return _t
end

context('Introspection', function()
	
	context('class.isClass(class)', function()
	
		local aclass, notaclass
		
		before(function() 
			aclass = class()
			instance = aclass()
		end)
	
		test('returns true if given a class',function()
			assert_true(class.isClass(aclass))
		end)	
		
		test('and false if given an instance or anything else',function()
			assert_false(class.isClass(instance))
			assert_false(class.isClass({}))
			assert_false(class.isClass(function() end))
			assert_false(class.isClass(class))
		end)

	end)

	context('class.isInstance(instance)', function()
	
		local aclass, instance
		
		before(function() 
			aclass = class()
			instance = aclass()
		end)
	
		test('returns true if given an instance from any class',function()
			assert_true(class.isInstance(instance))
		end)
		
		test('and false if given a class or anything else',function()
			assert_false(class.isInstance(aclass))
			assert_false(class.isInstance({}))
			assert_false(class.isInstance(function() end))
			assert_false(class.isInstance(class))
		end)

	end)
	
	local A, AA, AAA, AAAA
	local a, aa, aaa, aaaa
		
	context('class/instances relationships can be inspected', function()
		
		before(function()
			A = class('A')
			AA = A:extend('AA')
			AAA = AA:extend('AAA')
			AAAA = AAA:extend('AAAA')
			a = A()
			aa = AA()
			aaa = AAA()
			aaaa = AAAA()				
		end)		
		
		context('classOf()', function()
			
			test('returns true if the argument is a direct subclass', function()
				assert_true(A:classOf(AA))
				assert_true(AA:classOf(AAA))
				assert_true(AAA:classOf(AAAA))
			end)
		
			test('Or the subclass of any of its subclasses', function()
				assert_true(A:classOf(AAA))
				assert_true(A:classOf(AAAA))
				assert_true(AA:classOf(AAAA))
			end)
			
		end)
		
		context('subclassOf()', function()
			
			test('returns true if the argument is a direct superclass', function()
				assert_true(AAAA:subclassOf(AAA))
				assert_true(AAA:subclassOf(AA))
				assert_true(AA:subclassOf(A))
				assert_true(AA:subclassOf(A))
			end)
		
			test('Or the superclass of any of any of its superclasses ', function()
				assert_true(AAAA:subclassOf(AA))
				assert_true(AAAA:subclassOf(A))
				assert_true(AAA:subclassOf(A))
			end)
			
		end)

		context('instanceOf()', function()
			
			test('returns true if the argument is a direct class', function()
				assert_true(a:instanceOf(A))
				assert_true(aa:instanceOf(AA))
				assert_true(aaa:instanceOf(AAA))
				assert_true(aaaa:instanceOf(AAAA))
			end)
		
			test('Or any superclass of its direct class ', function()
				assert_true(aa:instanceOf(A))
				assert_true(aaa:instanceOf(A))
				assert_true(aaaa:instanceOf(A))
				assert_true(aaa:instanceOf(AA))
				assert_true(aaaa:instanceOf(AA))
				assert_true(aaaa:instanceOf(AAA))
			end)
			
		end)
		
	end)
	
	context('subclasses()', function()
		
		local subA, subAA, subAAA, filter_subA
		
		before(function()
			subA = revert_and_count(A:subclasses())
			subAA = revert_and_count(AA:subclasses())
			subAAA = revert_and_count(AAA:subclasses())
			subAAAA = revert_and_count(AAAA:subclasses())
			filter_subA = revert_and_count(A:subclasses(function(subclass)
				return subclass.super == A
			end))
		end)
		
		test('returns the full list of a class\'s subclasses', function()
			assert_equal(subA.n, 3)
			assert_equal(subAA.n, 2)
			assert_equal(subAAA.n, 1)
			assert_equal(subAAAA.n, 0)
			
			assert_true(subA[AA])
			assert_true(subA[AAA])
			assert_true(subA[AAAA])
			
			assert_true(subAA[AAA])
			assert_true(subAA[AAAA])
			assert_true(subAAA[AAAA])
		end)
		
		test('can also receive an optional filter', function()
			assert_equal(filter_subA.n, 1)
			assert_true(filter_subA[AA])
		end)
			
	end)
	
	context('instances()', function()
		
		local instA, instAA, instAAA, instAAAA, filter_instA
		
		before(function()
			instA = revert_and_count(A:instances())
			instAA = revert_and_count(AA:instances())
			instAAA = revert_and_count(AAA:instances())
			instAAAA = revert_and_count(AAAA:instances())
			filter_instA = revert_and_count(A:instances(function(instance)
				return instance.class == A
			end))
		end)
		
		test('returns the full list of class\'s instances', function()
			assert_equal(instA.n, 4)
			assert_equal(instAA.n, 3)
			assert_equal(instAAA.n, 2)
			assert_equal(instAAAA.n, 1)
			
			assert_true(instA[a])
			assert_true(instA[aa])
			assert_true(instA[aaa])
			assert_true(instA[aaaa])
			
			assert_true(instAA[aa])			
			assert_true(instAA[aaa])			
			assert_true(instAA[aaaa])			

			assert_true(instAAA[aaa])
			assert_true(instAAA[aaaa])
			
			assert_true(instAAAA[aaaa])
		end)

		test('can also receive an optional filter', function()
			assert_equal(filter_instA.n, 1)
			assert_true(filter_instA[a])
		end)
	
	end)
	
end)