require 'luacov'
local class = require('30log')

context('mixins', function()

	local aclass, asubclass, esubclass
	local instance, createdinstance, einstance
	local mixin, emixin

	before(function()
		mixin = {init = function(obj)
					obj.attr = 'attr'
					obj.value = 0
					obj.tab = {}
				end}
		aclass = class()
		asubclass = aclass:extend():with(mixin)
		asubclass.init = function(obj)
					obj.value2 = 0
				end
		instance = asubclass()
		createdinstance = asubclass:create()

		emixin = {init = function()
			error('Should not be called')
		end}
		esubclass = aclass:extend():with(emixin)
		einstance = esubclass:create()
	end)

	test('instances run by default their mixin.init methods', function()
		assert_equal(instance.attr, 'attr')
		assert_equal(instance.value, 0)
	end)

	test("but create() instances don't", function()
		assert_nil(createdinstance.value2)
		assert_nil(createdinstance.attr)
		assert_nil(createdinstance.value)
	end)

	test('mixin.init should not override class.init', function()
		assert_equal(instance.value2, 0)
	end)

	test('these attributes are independant copies', function()
		instance.attr, instance.value = 'instance_attr', 1
		instance.tab.v = 1
		assert_equal(instance.attr, 'instance_attr')
		assert_equal(instance.value, 1)
		assert_equal(instance.tab.v, 1)
	end)

	test('modifying them will not affect the class attributes', function()
		assert_equal(asubclass.attr, 'attr')
		assert_equal(asubclass.value, 0)
		assert_nil(asubclass.tab.v)
	end)

end)
