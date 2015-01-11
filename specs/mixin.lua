require 'luacov'
local class = require '30log'

context('mixins', function()

	local aclass, amixin, asubclass
	
	before(function()
    mixin_foo = {foo = function() end}
    mixin_bar = {bar = function() end}
    mixin_baz = {baz = function() end}
		mixin_mix = {f = function() end, g = true}
		aclass = class()
		asubclass = aclass:extend()
	end)
	
  test('are included using include()', function()
    aclass:include(mixin_foo)
    assert_type(aclass.foo, 'function')
  end)
	
  test('it only includes functions found in the mixin', function()
    aclass:include(mixin_mix)
    assert_type(aclass.f, 'function')
    assert_nil(aclass.g)
  end)	
	
  test('include() supports chaining', function()
    aclass:include(mixin_bar):include(mixin_baz)
    assert_type(aclass.bar, 'function')
    assert_type(aclass.baz, 'function')
  end)

	context('includes()', function()
	
		test('returns true if a class includes a given mixin', function()
			aclass:include(mixin_foo)
			assert_true(aclass:includes(mixin_foo))
		end)
	
		test('and also true if a superclass includes the given mixin', function()
			asubclass:include(mixin_foo)
			assert_true(asubclass:includes(mixin_foo))
		end)
		
		test('because this subclass includes access to the mixin functionnalities', function()
			asubclass:include(mixin_foo)
			assert_type(asubclass.foo, 'function')
		end)
		
		test('it returns false if the class does not include the given mixin', function()
			assert_false(aclass:includes({}))
			assert_false(asubclass:includes({}))
		end)
		
	end)
  
end)
  
