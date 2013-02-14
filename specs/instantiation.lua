_G.Class = require '30log'

context('Instances (Objects)',function()

  context('When a class is created', function()
    local Window
    
    before(function()
      Window = Class {size = 100}
      function Window:setSize(size) self.size = size end
    end)
    
    test('new objects can be created via Class:new()',function()
      assert_equal(type(Window:new()),'table')
    end)
    
    test('new objects can be created calling the class as a function',function()
      assert_equal(type(Window()),'table')
    end)
    
    test('new objects share their class attributes',function()
      assert_equal((Window()).size,100)
    end)
    
    test('new objects share their class methods',function()
      local win = Window()
      win:setSize(10)
      assert_equal(win.size,10)
    end)    
  end)

  context('Providing an :__init() method to classes',function()
    local Window
    
    before(function()
      Window = Class {size = 100}
      function Window:setSize(size) self.size = size end
      function Window:__init(size) self.size = size end
    end)
    
    test('Overrides instantiation scheme with Class:new()',function()
      local window = Window:new(25)
      assert_equal(window.size,25)
    end)
    
    test('Overrides instantiation scheme with Class()',function()
      local window = Window(90)
      assert_equal(window.size,90)
    end)      
    
  end)
	
  context('.__init can also be a table of named args for static instantiation',function()
    local Window
    
    before(function()
      Window = Class()
      function Window:setSize(size) self.size = size end
      Window.__init = {size = 25}
    end)
    
    test('Overrides instantiation scheme with Class:new()',function()
      local window = Window:new(100)
      assert_equal(window.size,25)
    end)
    
    test('Overrides instantiation scheme with Class()',function()
      local window = Window(90)
      assert_equal(window.size,25)
    end)      
    
  end)
	
	context('tostring', function()
	
		test('objects can be stringified', function()
			local myClass = Class()
			assert_equal(tostring(myClass()):match('(.+):%s<.+>$'), 'object (of Unnamed)')
		end)

		test('the output takes into account the mother class name can be stringified', function()
			local myClass = Class()
			myClass.__name = 'aClass'
			assert_equal(tostring(myClass()):match('(.+):%s<.+>$'), 'object (of aClass)')
		end)		
		
	end)
  
end)