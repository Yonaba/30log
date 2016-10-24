require 'luacov'
local class = require('30log')

context('Instantiation', function()
	local Window, win1, win2, win3
	local should_err, should_err2
	
	before(function()
		Window = class('Window', {size = 100})
		function Window:init(size) self.size = size end
		function Window:setSize(size) self.size = size end
		win1 = Window:new(10)
		win2 = Window(15)
		win3 = Window:create(25)
		
		should_err = function() local win_new = win1:new() end
		should_err2 = function() local win_new = win1() end		
	end)
	
	test('instances are created via new()',function()
		assert_true(class.isInstance(win1))
		assert_true(win1:instanceOf(Window))
	end)
	
	test('or via a class call, as a function',function()
		assert_true(class.isInstance(win2))
		assert_true(win2:instanceOf(Window))
	end)
	
	test('an instance can also be created via create()',function()
		assert_true(class.isInstance(win3))
		assert_true(win3:instanceOf(Window))
	end)

	test('calling new() or a function call triggers init() function',function()
		assert_equal(win1.size, 10)
		assert_equal(win2.size, 15)
	end)
	
	test('but create() allocates an instance without calling init() function',function()
		assert_not_equal(win3.size, 25)
		assert_equal(win3.size, 100)
	end)	
	
	test('instances have access to their class methods',function()
		win1:setSize(50)
		assert_equal(win1.size, 50)
	end)    

	test('instances cannot instantiate new instances', function()
		assert_error(should_err)
		assert_error(should_err2)
	end)
	
end)

context('init() method',function()
	local Window, window, Win_no_init
	
	before(function()
		Window = class {size = 100}
		Win_no_init = class()
		function Window:init(size) Window.setSize(self,size) end
		function Window:setSize(size) self.size = size end
	end)
	
	test('is not mandatory', function()
		local win_no_init = Win_no_init()
		assert_equal(win_no_init.class, Win_no_init)
	end)
	
	test('is used as an initialization function when instantiating with new(...)',function()
		window = Window:new(75)
		assert_equal(window.size,75)
	end)     
	
	test('or via a class call',function()
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
		aclass = class('aclass', {attr = 'attr', value = 0, tab = {}})
		instance = aclass()
	end)
	
	test('instances takes by default their class attributes values', function()
		assert_equal(instance.attr, 'attr')
		assert_equal(instance.value, 0)
	end)
	
	test('these attributes are independant copies', function()
		instance.attr, instance.value = 'instance_attr', 1
		instance.tab.v = 1
		assert_equal(instance.attr, 'instance_attr')
		assert_equal(instance.value, 1)
		assert_equal(instance.tab.v, 1)		
	end)
	
	test('modifying them will not affect the class attributes', function()
		assert_equal(aclass.attr, 'attr')
		assert_equal(aclass.value, 0)	
		assert_nil(aclass.tab.v)		
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
	
	context('but instances cannot call some class methods, such as', function()
	
		test('new()', function()
			assert_error(function() return instance:new() end)
			assert_error(function() return instance() end)
		end)
		
		test('create()', function()
			assert_error(function() return instance:create() end)
		end)		
		
		test('extend()', function()
			assert_error(function() return instance:extend() end)
		end)

		test('classOf()', function()
			assert_error(function() return instance:classOf(aclass) end)
		end)
		
		test('subclassOf()', function()
			assert_error(function() return instance:subclassOf(aclass) end)
		end)	
		
		test('subclasses()', function()
			assert_error(function() return instance:subclasses() end)
		end)
		
		test('instances()', function()
			assert_error(function() return instance:instances() end)
		end)
		
		test('with()', function()
			assert_error(function() return instance:with() end)
		end)		
		
		test('includes()', function()
			assert_error(function() return instance:includes() end)
		end)

		test('without()', function()
			assert_error(function() return instance:without() end)
		end)		
	
	end)
	
end)
