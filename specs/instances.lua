require 'luacov'
local class = require '30log'

context('Instantiation', function()
	local Window, window
	
	before(function()
		Window = class('Window', {size = 100})
		function Window:setSize(size) self.size = size end
		window = Window:new()
	end)
	
	test('instances are created via new()',function()
		assert_true(class.isInstance(window))
		assert_true(class.isInstance(window, Window))
	end)
	
	test('or via a class call, as a function',function()
		local window = Window()
		assert_true(class.isInstance(window))
		assert_true(class.isInstance(window, Window))
	end)
	
	test('instances can access their class attributes',function()
		assert_equal(window.size,100)
	end)
	
	test('they also access their class methods',function()
		window:setSize(50)
		assert_equal(window.size, 50)
	end)    

	test('instances cannot instantiate new instances', function()
		local function should_err() local win_new = window:new() end
		local function should_err2() local win_new = window() end
		assert_error(should_err)
		assert_error(should_err2)
	end)
	
end)

context('init() method, when provided',function()
	local Window, window
	
	before(function()
		Window = class {size = 100}
		function Window:init(size) Window.setSize(self,size) end
		function Window:setSize(size) self.size = size end
	end)
	
	test('is used as an initialization function when instantiating with new(...)',function()
		window = Window:new(75)
		assert_equal(window.size,75)
	end)     
	
	test('is used as an initialization function when instantiating via a class call',function()
		window = Window(90)
		assert_equal(window.size,90)
	end)
	
end)

context('init can also be a table',function()
	local Window, window
	
	before(function()
		Window = class()
		Window.init = {size = 200}
	end)
	
	test('its keys will be copied into the new instance',function()
		window = Window:new()
		assert_equal(window.size, 200)
	end)  
	
end)
 
context('tostring(instance) returns a string representing an instance', function()

		local instance_named_class, instance_unnamed_class

		before(function()
			instance_named_class = class('class')() 
			instance_unnamed_class = class()()
		end)
	
		test('it works for instances from named classes', function() 
			assert_type(tostring(instance_named_class),'string')
		end)
		
		test('and also for instances from unnamed classes', function()
			assert_type(tostring(instance_unnamed_class),'string')
		end)

end)

context('attributes',function()

	local aclass, instance
	
	before(function() 
		aclass = class('aclass', {attr = 'attr', value = 0})
		instance = aclass()
	end)
	
	test('instances have access to their class attributes', function()
		assert_equal(instance.attr, 'attr')
		assert_equal(instance.value, 0)
	end)
	
	test('but they can override their class attributes', function()
		instance.attr, instance.value = 'instance_attr', 1
		assert_equal(instance.attr, 'instance_attr')
		assert_equal(instance.value, 1)
	end)
	
	test('without affecting the class attributes', function()
		assert_equal(aclass.attr, 'attr')
		assert_equal(aclass.value, 0)	
	end)

end)

context('methods',function()

	local aclass, instance
	
	before(function() 
		aclass = class()
		function aclass:say(something) return something end
		instance = aclass()
	end)
	
	test('instances have access to their class methods', function()
		assert_equal(instance:say('hi!'), 'hi!')
	end)
	
	test('instances cannot call new(), as it raises an error', function()
		assert_error(function() return instance:new() end)
		assert_error(function() return instance() end)
	end)

	test('instances cannot call extends(), as it raises an error', function()
		assert_error(function() return instance:extends() end)
	end)
	
	test('instances cannot call include(), as it raises an error', function()
		assert_error(function() return instance:include({}) end)
	end)
	
	test('instances cannot call has(), as it raises an error', function()
		assert_error(function() return instance:has({}) end)
	end)

	test('instances cannot call classOf(), as it raises an error', function()
		assert_error(function() return instance:classOf(aclass) end)
	end)
	
	test('instances cannot call subclassOf(), as it raises an error', function()
		assert_error(function() return instance:subclassOf(aclass) end)
	end)	
	
end)
