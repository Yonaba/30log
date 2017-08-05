require 'luacov'
local class = require('30log-plus')

context('mixinsplus', function()

	local aclass
	local chain1, chain2, intercept1, intercept2


	before(function()
		chain1   = {
			ChainTrue = function(self)
				self.a = "C1"
				self.b = "C1"
				return true
			end,
			ChainFalse = function(self)
				self.a = "C1"
				self.b = "C1"
				return false
			end,
			ChainThree = function(self)
				self.d = "C1"
				return false
			end,
			chained = {"ChainTrue","ChainFalse","ChainThree"}
		}
		chain2   = {
			ChainTrue  = function(self)
				self.a = "C2"
				self.b = "C2"
				self.c = "C2"
				return true
			end,
			ChainFalse = function(self)
				self.a = "C2"
				self.b = "C2"
				self.c = "C2"
				return true
			end,
			ChainThree = function(self)
				self.d = "C2"
				return true
			end,
			ChainFour = function(self)
				self.e = "C2"
				return true
			end,
			chained = {"ChainTrue","ChainFalse","ChainThree","ChainFour"}
		}
		intercept1 = {



		}
		mixin_both      = {baz = function() end}
		aclass          = class()

		aclass.ChainTrue = function(self)
			self.a = "AA"
			return true
		end
		aclass.ChainFalse = function(self)
			self.a = "AA"
			self.b = nil
			return false
		end

	end)

	context('Chained methods run in the order their mixins are declared', function()

		context('with varargs', function()

			local instance
			before(function() instance = aclass:with(chain1, chain2)() end)

			test("Mixin's methods run before the correspondent class method", function()
				instance:ChainTrue()
				assert_equal(instance.a, "AA")
				assert_equal(instance.b, "C2")
				assert_equal(instance.c, "C2")
				assert_nil(instance.d)
				assert_nil(instance.e)
			end)

			test("but stop if a mixin's method return false", function()
				instance:ChainFalse()
				assert_equal(instance.a, "C1")
				assert_equal(instance.b, "C1")
				assert_nil  (instance.c)
				assert_nil(instance.d)
				assert_nil(instance.e)
			end)
		end)

		context('or piped methods', function()

			local instance
			before(function() instance = aclass:with(chain1):with(chain2)() end)

			test("Mixin's methods run before the correspondent class method", function()
				instance:ChainTrue()
				assert_equal(instance.a, "AA")
				assert_equal(instance.b, "C2")
				assert_equal(instance.c, "C2")
				assert_nil(instance.d)
				assert_nil(instance.e)
			end)

			test("but stop if a mixin's method return false", function()
				instance:ChainFalse()
				assert_equal(instance.a, "C1")
				assert_equal(instance.b, "C1")
				assert_nil  (instance.c)
				assert_nil(instance.d)
				assert_nil(instance.e)
			end)
		end)
	end)
end)
