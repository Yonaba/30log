require 'luacov'
local class = require('30log-plus')

context('mixinsplus', function()

	local varChain, pipeChain, chainTests

	local aclass
	local chain1, chain2, intercept1, intercept2

	print(1)

	before(function()
		print("b1")
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

		varChain  = function(instance) instance = aclass:with(chain1, chain2)() end
		pipeChain = function(instance) instance = aclass:with(chain1):with(chain2)() end

		chainTests =  function(func)

			local instance
			before(func(instance))

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
		end

		print("a")
	end)

	context('Chained methods run in the order their mixins are declared', function()

		print("1.1")

		context('with varargs', function(instance)
			print("1.1.1")
			chainTests(varChain)
		end)

		context('or piped methods', function(instance)
			print("1.1.2")
			chainTests(pipeChain)
		end)
	end)
end)
