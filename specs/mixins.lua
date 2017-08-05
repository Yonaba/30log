require 'luacov'
local class = require('30log-plus')

context('mixins', function()

	local aclass, asubclass
	local instance, sub_instance
	local mixin_foo, mixin_bar, mixin_baz, mixin_mix

	before(function()
		mixin_foo     = {foo = function() end}
		mixin_bar     = {bar = function() end}
		mixin_baz     = {baz = function() end}
		mixin_mix     = {f = function() end, g = true}
		aclass        = class()
		asubclass     = aclass:extend()
		instance      = aclass()
		sub_instance  = asubclass()
	end)

	context('with()', function()

		local instance

		before(function()
				instance = asubclass:with(mixin_mix)()
		end)

		test('adds mixins to classes', function()
			assert_type(instance.f, 'function')
		end)

		test('only functions are included', function()
			assert_nil(instance.g)
			assert_true(mixin_mix.g)
		end)

		test('including a mixin twice raises an error', function()
			local function f() aclass:with(mixin_mix) end
			assert_not_error(f)
			assert_error(f)
		end)

		test('with() can take a vararg of mixins', function()
			local i = aclass:with(mixin_foo, mixin_bar, mixin_baz)()
			assert_type(i.foo, 'function')
			assert_type(i.bar, 'function')
			assert_type(i.baz, 'function')
		end)

		test('or just use chaining', function()
			local i = aclass:with(mixin_foo)
						:with(mixin_bar)
						:with(mixin_baz)()
			assert_type(i.foo, 'function')
			assert_type(i.bar, 'function')
			assert_type(i.baz, 'function')
		end)

 --CPE: Rewritten with the new way :with() works
		test('a previous subclass has no access to the new methods', function()
			aclass:with(mixin_foo, mixin_bar, mixin_baz)
			assert_nil(asubclass.foo)
			assert_nil(asubclass.bar)
			assert_nil(asubclass.baz)
		end)

 --CPE: Rewritten with the new way :with() works
		test('a previous instance has no access to the new methods', function()
			aclass:with(mixin_foo, mixin_bar, mixin_baz)
			assert_nil(instance.foo)
			assert_nil(instance.bar)
			assert_nil(instance.baz)
		end)

	end)

	context('includes', function()

		before(function()
			aclass:with(mixin_foo, mixin_bar, mixin_baz, mixin_mix)
		end)

		test('returns true if a class includes a mixin', function()
			assert_true(aclass:includes(mixin_foo))
			assert_true(aclass:includes(mixin_bar))
			assert_true(aclass:includes(mixin_baz))
			assert_true(aclass:includes(mixin_mix))
		end)

		test('and also when a superclass of the class includes a mixin', function()
			assert_true(asubclass:includes(mixin_foo))
			assert_true(asubclass:includes(mixin_bar))
			assert_true(asubclass:includes(mixin_baz))
			assert_true(asubclass:includes(mixin_mix))
		end)

	end)

	context('without()', function()

		before(function()
			aclass:with(mixin_foo, mixin_bar, mixin_baz, mixin_mix)
		end)

		test('removes a given mixin from a class', function()
			aclass:without(mixin_mix)
			assert_false(aclass:includes(mixin_mix))
			assert_false(asubclass:includes(mixin_mix))
			assert_nil(aclass.f)
			assert_nil(asubclass.f)
			assert_nil(instance.f)
		end)

		test('removing a mixin which is not included raises an error', function()
			local f = function() aclass:without(mixin_mix) end
			assert_not_error(f)
			assert_error(f)
		end)

		test('can also take a vararg of mixin', function()
			aclass:without(mixin_foo, mixin_bar, mixin_baz)
			assert_false(aclass:includes(mixin_foo))
			assert_false(aclass:includes(mixin_bar))
			assert_false(aclass:includes(mixin_baz))
		end)

		test('or just use chaining', function()
			aclass:without(mixin_foo)
						:without(mixin_bar)
						:without(mixin_baz)
			assert_false(aclass:includes(mixin_foo))
			assert_false(aclass:includes(mixin_bar))
			assert_false(aclass:includes(mixin_baz))
		end)

	end)

end)
