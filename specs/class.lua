_G.Class = require '30log'

print('Assuming the returned value when requiring "30log" \nis held in variable named Class')

context('Class()', function()
  
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
 
end)