_G.Class = require '30log'

context('Derivation (Inheritance)',function()
  local Window
    
  before(function()
    Window = Class { width = 100, height = 100 }
    function Window:setSize(w,h) self.width, self.height = w,h end
  end)
  
  context('Class can be derived from a superclass',function()
  
    test('Via "extends()" method',function()
      local Frame = Window:extends()
      assert_equal(type(Frame),'table')
    end)
  
    test('With extra-arguments passed to method "extends()" as a table',function()
      local Frame = Window:extends {ID = 1}
      assert_equal(Frame.ID,1)
    end)
    
  end)
  
  context('A derived class still points to its superclass',function()
  
    test('Via its "super" key',function()
      local Frame = Window:extends()
      assert_equal(Frame.super,Window)
    end)
    
    test('Via "getmetatable()" function',function()
      local Frame = Window:extends()
      assert_equal(getmetatable(Frame),Window)  
    end)    
    
  end)
  
  context('A derived class',function()
  
    test('can instantiate objects',function()
      local Frame = Window:extends()
      function Frame:setSize(size) self.width, self.height = size,size end
      local app = Frame()
      local app2 = Frame:new()
      assert_equal(type(app),'table')  
      assert_equal(type(app2),'table')
    end)  
    
    test('shares its superclass attributes',function()
      local Frame = Window:extends()
      assert_equal(Frame.width,100)  
      assert_equal(Frame.height,100)  
    end)
    
    test('shares its superclass methods',function()
      local Frame = Window:extends()
      Frame:setSize(15,15)
      assert_equal(type(Frame.setSize),'function')  
      assert_equal(Frame.width,15)  
      assert_equal(Frame.height,15)  
    end)
    
    test('can reimplement its superclass methods',function()
      local Frame = Window:extends()
      function Frame:setSize(size) self.width, self.height = size,size end
      Frame:setSize(30)
      assert_equal(Frame.width,30)  
      assert_equal(Frame.height,30) 
    end)
  
    test('Yet, it still has access to the original superclass method',function()
      local Frame = Window:extends()
      function Frame:setSize(size) self.width, self.height = size,size end
      Frame.super.setSize(Frame,50,55)
      assert_equal(Frame.width,50)  
      assert_equal(Frame.height,55) 
    end)     
    
  end)
  
 end)