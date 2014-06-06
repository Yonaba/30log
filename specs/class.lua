require 'luacov'
local Class = require '30log'

context('Class', function()
  
  context('When Class is called with no args passed', function()
    test('it returns a new class (regular Lua table)',function()
      assert_equal(type(Class()),'table')
    end)
  end)

  context('Attributes', function()
    local myClass, myClass2
    
    before(function()
      myClass = Class()
      myClass.name = 'myClass'      
      myClass2 = Class {name = 'myClass'}
    end)
    
    test('can be added to classes',function()
      assert_equal(myClass.name,'myClass')
    end)
    
    test('can be passed in a table to Class()',function()
      assert_equal(myClass2.name,'myClass')
    end)      
  end)
  
  context('Methods', function()
    local myClass
    
    before(function()
      myClass = Class()
      myClass.name = 'myClass'
      function myClass:introduce() return self.name end
    end)
  
    test('can be added to classes',function()
      assert_equal(myClass:introduce(),'myClass')
    end)    
  end)
 
  context('Metamethods', function()
    
    test('can be implemented into classes', function()
      local myClass = Class()
      myClass.__add = function(a, b) return a.value + b.value end
      myClass.__sub = function(a, b) return a.value - b.value end
      myClass.__mul = function(a, b) return a.value * b.value end
      myClass.__div = function(a, b) return a.value / b.value end
      
      local a, b = myClass(), myClass()
      a.value, b.value = 20, 10

      assert_equal(a + b,  30)
      assert_equal(a - b,  10)
      assert_equal(a * b, 200)
      assert_equal(a / b,   2)
    end)
    
  end)
  
  context('tostring', function()
    test('classes can be stringified', function()
      local myClass = Class()
      assert_equal(tostring(myClass):match('(.+):<.+>$'), 'class(?)')
    end)
  end)
  
  context('named classes', function()
    test('classes can be named implementing the special attribute __name', function()
      local myClass = Class()
      myClass.__name = 'aClass'
      assert_equal(tostring(myClass):match('(.+):<.+>$'), 'class(aClass)')
    end)
  end)  
  
end)