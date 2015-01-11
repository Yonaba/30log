require 'luacov'
local class = require '30log'

context('class()', function()
	
	local named_class, unnamed_class 
	
	before(function()
		named_class = class('class') 
		unnamed_class = class()
	end)
	
	test('returns a class', function()
		assert_type(named_class, 'table')
		assert_type(unnamed_class, 'table')
		assert_true(class.isClass(named_class))
		assert_true(class.isClass(unnamed_class))
	end)
	
	context('tostring(class) returns a string representing a class', function()
		
		test('it works for named classes', function() 
			assert_type(tostring(named_class),'string')
		end)
		
		test('and also for unnamed classes', function()
			assert_type(tostring(unnamed_class),'string')
		end)

	end)
	
end)

context('a class implements these methods', function()

	local aclass
	
	before(function()
		aclass = class()
	end)
	
	test('a method named "new"', function() 
		assert_type(aclass.new, 'function')
	end)
	
	test('a method named "extend"', function() 
		assert_type(aclass.extend, 'function')
	end)
	
	test('a method named "extends"', function() 
		assert_type(aclass.extends, 'function')
	end)
	
	test('a method named "include"', function() 
		assert_type(aclass.include, 'function')
	end)
	
	test('a method named "includes"', function() 
		assert_type(aclass.includes, 'function')
	end)
	
end)

context('a class also implements some attributes', function()

	local aclass 
	
	before(function() aclass = class('aclass') end)
	
	test('an attribute "name" which gives the class name', function()
		assert_equal(aclass.name, 'aclass')
	end)
	
	test('yet it can be nil in case the class is unnamed', function()
		assert_nil(class().name)
	end)
	
	test('it also have a private attribute "mixins" which lists included mixins', function()
		assert_type(aclass.mixins, 'table')
	end)
	
	test('and some private metamethods meant for its instances', function()
		assert_type(aclass.__tostring, 'function')
		assert_type(aclass.__index, 'table')
		assert_type(aclass.__call, 'function')
	end)
	
end)

context('attributes can be defined', function()
	local aclass, anotherclass
	
	before(function()
		aclass = class('aclass', {attr = 'attr', value = 0, name = 'aclass1'})
		aclass2 = class(nil, {name = 'aclass2'})
		anotherclass = class()
		anotherclass.attr = 'attr'
	end)
	
	test('after initialization',function()
		assert_equal(anotherclass.attr,'attr')
	end)
	
	test('or while creating them',function()
		assert_equal(aclass.attr,'attr')
		assert_equal(aclass.value, 0)
	end)
	
	test('passed-in attributes set the class name if not provided', function()
		assert_equal(aclass2.name, 'aclass2')
	end)
	
	test('but cannot override the name argument', function()
		assert_equal(aclass.name, 'aclass')
	end)
		
	test('subclasses also have access to their superclass attributes', function()
		local subclass = aclass:extend()
		assert_equal(subclass.attr, 'attr')
		assert_equal(subclass.value, 0)
	end)
	
	test('and they also have their own copy of their superclass attributes', function()
		local subclass = aclass:extend()
		subclass.attr, subclass.value = 'subclass_attr', 1
		assert_equal(subclass.attr, 'subclass_attr')
		assert_equal(subclass.value, 1)
		assert_equal(aclass.attr, 'attr')
		assert_equal(aclass.value, 0)
	end)
	
end)

context('methods can also be defined', function()
	local aclass, anotherclass
	
	before(function()
		aclass = class('aclass')
		function aclass:greet() return 'hi!' end
	end)
	
	test('they are set as function member within the class', function()
		assert_type(aclass.greet, 'function')
		assert_not_error(aclass.greet)
	end)
		
	test('subclasses also have access to their superclass methods', function()
		local subclass = aclass:extend()
		assert_equal(subclass:greet(), 'hi!')
	end)
	
	test('but they can override their superclass methods', function()
		local subclass = aclass:extend()
		function subclass:greet(someone) return 'hello ' .. someone ..'!' end
		assert_equal(subclass:greet('world'), 'hello world!')
		assert_equal(aclass:greet(), 'hi!')
	end)
	
end)

context('classes supports metamethods', function()
	
	local aclass
	
	before(function() 
		aclass = class('aclass', {x = 0})
		function aclass:init(x) self.x = x end
		
		aclass.__add = function(a,b) return a.x + b.x end
		aclass.__sub = function(a,b) return a.x - b.x end
		aclass.__mul = function(a,b) return a.x * b.x end
		aclass.__div = function(a,b) return a.x / b.x end
		aclass.__mod = function(a,b) return a.x % b.x end
		aclass.__pow = function(a,b) return a.x ^ b.x end
		aclass.__unm = function(a,b) return -(a.x) end
		aclass.__concat = function(a,b) return a.x ..':'.. b.x end
		aclass.__eq = function(a,b) return a.x == b.x end
		aclass.__lt = function(a,b) return a.x < b.x end
		aclass.__le = function(a,b) return a.x <= b.x end
	end)
	
	test('instances of class can access those metamethods', function()
		local instance1, instance2 = aclass(5), aclass(5)	
		assert_equal(instance1 + instance2, 10) 
		assert_equal(instance1 - instance2, 0) 
		assert_equal(instance1 * instance2, 25) 
		assert_equal(instance1 / instance2, 1) 
		assert_equal(instance1 % instance2, 0) 
		assert_equal(instance1 ^ instance2, 3125) 
		assert_equal(-instance1, -5) 		
		assert_equal(instance1 .. instance2, '5:5')			
		assert_true(instance1 == instance2)
		assert_false(instance1 < instance2)
		assert_true(instance1 <= instance2) 
	end)
	
	test('instances of subclasses can also access those metamethods', function()
		local subclass = aclass:extend()
		function subclass:init(x) subclass.super.init(self, x) end
		local instance1, instance2 = subclass(5), subclass(5)	
		assert_equal(instance1 + instance2, 10) 
		assert_equal(instance1 - instance2, 0) 
		assert_equal(instance1 * instance2, 25) 
		assert_equal(instance1 / instance2, 1) 
		assert_equal(instance1 % instance2, 0) 
		assert_equal(instance1 ^ instance2, 3125) 
		assert_equal(-instance1, -5) 
		assert_equal(instance1 .. instance2, '5:5')
		assert_true(instance1 == instance2)
		assert_false(instance1 < instance2)
		assert_true(instance1 <= instance2)
	end)
	
end)
  
