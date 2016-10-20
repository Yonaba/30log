require 'luacov'
local class = require('30log')

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

context('a class should have the following methods', function()

	local aclass
	
	before(function()
		aclass = class()
	end)
	
	test('a method named "new"', function() 
		assert_type(aclass.new, 'function')
	end)
	
	test('a method named "create"', function() 
		assert_type(aclass.create, 'function')
	end)
	
	test('a method named "extend"', function() 
		assert_type(aclass.extend, 'function')
	end)		
	
	test('a method named "classOf"', function() 
		assert_type(aclass.classOf, 'function')
	end)
	
	test('a method named "subclassOf"', function() 
		assert_type(aclass.subclassOf, 'function')
	end)		
	
	test('a method named "instanceOf"', function() 
		assert_type(aclass.instanceOf, 'function')
	end)
	
	test('a method named "cast"', function() 
		assert_type(aclass.cast, 'function')
	end)	
	
	test('a method named "subclasses"', function() 
		assert_type(aclass.subclasses, 'function')
	end)
	
	test('a method named "instances"', function() 
		assert_type(aclass.instances, 'function')
	end)		
	
	test('a method named "with"', function() 
		assert_type(aclass.with, 'function')
	end)	

	test('a method named "includes"', function() 
		assert_type(aclass.includes, 'function')
	end)	
	
	test('a method named "without"', function() 
		assert_type(aclass.without, 'function')
	end)
	
end)

context('a class also implements some attributes', function()

	local aclass 
	
	before(function() aclass = class('aclass') end)
	
	test('an attribute "name" which gives the class name', function()
		assert_equal(aclass.name, 'aclass')
	end)
			
	test('yet it returns nil in case the class is unnamed', function()
		assert_nil(class().name)
	end)
	
	test('it also has an attribute "super" which is nil by default', function()
		assert_nil(aclass.super)
	end)

	test('but holds a reference to the superclass of a class', function()
		local asubclass = aclass:extend()
		assert_equal(asubclass.super, aclass)
	end)		
	
	test('it also has some private attributes', function()
		assert_type(aclass.mixins, 'table')
		assert_type(aclass.__subclasses, 'table')
		assert_type(aclass.__instances, 'table')
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
	
	test('passed-in attributes can be used to set the class name', function()
		assert_equal(aclass2.name, 'aclass2')
	end)
	
	test('but they will not override the name argument if supplied', function()
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
	
	test('but they can redefine their own implementation', function()
		local subclass = aclass:extend()
		function subclass:greet(someone) return 'hello ' .. someone ..'!' end
		assert_equal(subclass:greet('world'), 'hello world!')
		assert_equal(aclass:greet(), 'hi!')
	end)
	
end)
	