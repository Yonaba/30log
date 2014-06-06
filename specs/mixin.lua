require 'luacov'
local Class = require '30log'

context('Mixins', function()

  test('are set of functions that can be imported into a class', function()
    local mixin = { 
      foo = function() end,
      bar = function() end,
      baz = function() end
    }
    
    local theClass = Class()
    
    assert_nil(theClass.foo)
    assert_nil(theClass.bar)
    assert_nil(theClass.baz)
    
    theClass:include(mixin)
    
    assert_equal(type(theClass.foo), 'function')
    assert_equal(type(theClass.bar), 'function')
    assert_equal(type(theClass.baz), 'function')  
  
  end)
  
  test('can be chained', function()
    local mixinA = {foo = function() end}
    local mixinB = {bar = function() end}
    local mixinC = {baz = function() end}
    
    local theClass = Class()      
    theClass:include(mixinA):include(mixinB):include(mixinC)
    
    assert_equal(type(theClass.foo), 'function')
    assert_equal(type(theClass.bar), 'function')
    assert_equal(type(theClass.baz), 'function')  
  
  end)    
  
  test('objects can use methods from mixins as class methods', function()
    local mixin = {foo = function(self) return self end}
    local theClass = Class()      
    theClass:include(mixin)
    local instance = theClass()
    assert_equal(instance:foo(), instance)  
  end)
  
end)
  
