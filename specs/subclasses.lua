require 'luacov'
local class = require '30log'

context('Derivation', function()
  local Window, Frame
    
  before(function()
    Window = class('Window', { width = 100, height = 100 })
    function Window:setSize(w,h) self.width, self.height = w,h end
  end)
  
  context('extends()',function()
  
    test('when called with no argument, returns a subclass',function()
			Frame = Window:extend()
      assert_true(class.isClass(Frame))
      assert_equal(Frame.super, Window)
    end)
		
    test('when called a "name" argument, returns a subclass with a name set',function()
			Frame = Window:extend('Frame')
      assert_true(class.isClass(Frame))
      assert_equal(Frame.super, Window)
      assert_equal(Frame.name, 'Frame')
    end)		
  
    test('it also takes a table with named keys to define new attributes',function()
			Frame = Window:extend('Frame', {color = 'white'})
      assert_true(class.isClass(Frame))
      assert_equal(Frame.super, Window)
      assert_equal(Frame.name, 'Frame')
      assert_equal(Frame.color, 'white')
    end)	
    
  end)
  
  context('a subclass\' superclass can be retrieved',function()
		
		before(function() Frame = Window:extend() end)
		
    test('via its "super" attribute',function()
      assert_equal(Frame.super, Window)
    end)
    
    test('via "getmetatable(), as a superclass is the metatable of its subclasses"',function()
      assert_equal(getmetatable(Frame),Window)
    end)    
    
  end)
  
  context('a subclass',function()
  
		local Window, Frame
		
		before(function()
			Window = class('Window', {w = 100, h = 100})
      Window.__eq = function(a, b) return a.w == b.w and a.h == b.h end
      Window.__le = function(a, b) return a.w * a.h <= b.w * b.h  end
      Window.__lt = function(a, b) return a.w * a.h < b.w * b.h end			
			function Window:init(w, h) Window.setSize(self, w, h) end
			function Window:setSize(w, h) self.w, self.h = w, h end
			Frame = Window:extend()
		end)
		
		test('has an attribute "super" pointing to its superclass', function()
			assert_equal(Frame.super, Window)
		end)
	
    test('can instantiate objects, just as a regular class',function()
      local app1, app2 = Frame:new(), Frame()
      assert_true(class.isInstance(app1))
      assert_true(class.isInstance(app2))
    end)  
    
    test('shares its superclass\' attributes',function()
      assert_equal(Frame.w,100)  
      assert_equal(Frame.h,100)  
    end)
    
    test('shares its superclass\' methods',function()
      local frame = Frame()
			frame:setSize(15,15)
      assert_equal(frame.w,15)  
      assert_equal(frame.h,15)  
    end)
    
    test('shares its superclass\' metamethods', function() 
      local frameA, frameB = Frame(), Frame()
      frameA:setSize(200, 200)
      frameB:setSize(200, 200)
      
      assert_true(frameA == frameB)
      assert_true(frameA <= frameB)
      frameB:setSize(200, 199)      
      assert_true(frameB <= frameA)
      assert_false(frameA <= frameB)   
      assert_true(frameB < frameA)
      assert_false(frameA < frameB)
    end)
    
    test('can override its superclass methods',function()
      function Frame:setSize(size) self.w, self.h = size, size end
			local frame = Frame()
      frame:setSize(30)
      assert_equal(frame.w,30)  
      assert_equal(frame.h,30) 
    end)		
  
    test('but leaves the original superclass method untouched',function()
      local frame = Frame()
			Frame.super.setSize(frame,50,55)
      assert_equal(frame.w,50)  
      assert_equal(frame.h,55) 
    end)
  
  end)
  
  context('In a single inheritance model', function()
    local A, B, C
    before(function()
      A = class()
      function A:init(a)
				self.a = a
			end
			B = A:extend()
      function B:init(a, b)
        B.super.init(self, a)
        self.b = b
      end
      C = B:extend()
      function C:init(a, b, c)
        C.super.init(self, a, b)
        self.c = c
      end
    end)
      
    test('init() class constructor can chain', function()
      local a = A(1)
      local b = B(1,2)
      local c = C(1,2,3)
      assert_equal(a.a,1)
      assert_equal(b.a,1)
      assert_equal(b.b,2)
      assert_equal(c.a,1)
      assert_equal(c.b,2)
      assert_equal(c.c,3)
    end)
    
  end)
  
end)