require 'luacov'
local class = require('30log')
local has_lua_5_2_support = (rawlen and type(rawlen) == 'function')
local has_lua_5_3_support = (string.unpack and type(string.unpack) == 'function')

local Point3D, sPoint3D
local garbage, p1, p2
	
context('Lua 5.1.x metamethods are supported', function()
	
	before(function()
	
		Point3D = class('Point3D', {x = 0, y = 0, z = 0})
		function Point3D:init(x, y, z) self.x, self.y, self.z = x, y, z end
		Point3D.__add = function(a,b) return Point3D(a.x + b.x, a.y + b.y, a.z + b.z) end
		Point3D.__sub = function(a,b) return Point3D(a.x - b.x, a.y - b.y, a.z - b.z) end
		Point3D.__mul = function(a,b) return Point3D(a.x * b.x, a.y * b.y, a.z * b.z) end
		Point3D.__div = function(a,b) return Point3D(a.x / b.x, a.y / b.y, a.z / b.z) end
		Point3D.__mod = function(a,n) return Point3D(a.x % n, a.y % n, a.z % n) end
		Point3D.__pow = function(a,n) return Point3D(a.x ^ n, a.y ^ n, a.z ^ n) end
		Point3D.__unm = function(a) return Point3D(-a.x, -a.y, -a.z) end
		Point3D.__concat = function(a, b) return Point3D(a.x .. b.x, a.y .. b.y, a.z .. b.z) end
		Point3D.__eq = function(a,b) return a.x == b.x and a.y == b.y and a.z == b.z end
		Point3D.__lt = function(a,b) return a.x < b.x and a.y < b.y and a.z < b.z end
		Point3D.__le = function(a,b) return a.x <= b.x and a.y <= b.y and a.z <= b.z end
	
		sPoint3D = Point3D:extend('sPoint3D')
		sPoint3D.__metatable = "sPoint3D class metatable"
		
	end)

	context('by instances of a class', function()
		
		before(function()
			Point3D.__call = function(a) return a.x, a.y, a.z end
			Point3D.__metatable = "Point3D class metatable"
			Point3D.__mode = "k"
			
			p1 = Point3D(1, 3, 5)
			p2 = Point3D(2, 4, 6)
		end)
		
		test('__add is supported', function()
			assert_equal(p1 + p2, Point3D(3, 7, 11))
		end)
		
		test('__sub is supported', function()
			assert_equal(p1 - p2, Point3D(-1, -1, -1))
		end)
		
		test('__mul is supported', function()
			assert_equal(p1 * p2, Point3D(2, 12, 30))
		end)		
		
		test('__div is supported', function()
			assert_equal(p1 / p2, Point3D(1/2, 3/4, 5/6))
		end)		

		test('__mod is supported', function()
			assert_equal(p1 % 2, Point3D(1, 1, 1))
			assert_equal(p2 % 2, Point3D(0, 0, 0))
		end)		

		test('__pow is supported', function()
			assert_equal(p1 ^ 3, Point3D(1, 27, 125))
			assert_equal(p2 ^ 4, Point3D(16, 256, 1296))
		end)
		
		test('__unm is supported', function()
			assert_equal(-p1, Point3D(-1, -3, -5))
			assert_equal(-p2, Point3D(-2, -4, -6))
		end)			
		
		test('__concat is supported', function()
			assert_equal(p1 .. p2, Point3D('12','34','56'))
			assert_equal(p2 .. p1, Point3D('21','43','65'))
		end)
		
		test('__eq is supported', function()
			assert_not_equal(p1, p2)
			assert_equal(p1, Point3D(1, 3, 5))
			assert_equal(p2, Point3D(2, 4, 6))
		end)
		
		test('__lt is supported', function()
			assert_true(p1 < p2)
			assert_false(p2 < p1)
		end)
		
		test('__le is supported', function()
			assert_true(p1 <= p1)
			assert_true(p2 <= p2)
			assert_true(p1 <= p2)
			assert_false(p2 <= p1)
		end)		
		
		test('__call is supported', function()
			local x, y, z = p1()
			assert_equal(x, p1.x)
			assert_equal(y, p1.y)
			assert_equal(z, p1.z)
			
			x, y, z = p2()
			assert_equal(x, p2.x)
			assert_equal(y, p2.y)
			assert_equal(z, p2.z)			
		end)	
		
		test('__metatable is supported', function()
			assert_equal(getmetatable(p1), "Point3D class metatable")
		end)
		
		test('__mode is supported', function()
			p1[{}] = true
			local has_weak_key = false
			for k in pairs(p1) do
				if type(k) == 'table' then has_weak_key = true end
			end
			assert_true(has_weak_key)
			collectgarbage()
			has_weak_key = false
			for k in pairs(p1) do
				if type(k) == 'table' then has_weak_key = true end
			end
			assert_false(has_weak_key)			
		end)
				
	end)
	
	context('by instances of a class\' subclasses, except "__call" and "__mode"', function()
		
		before(function()
			p1 = sPoint3D(1, 3, 5)
			p2 = sPoint3D(2, 4, 6)
		end)
		
		test('__add is supported', function()
			assert_equal(p1 + p2, sPoint3D(3, 7, 11))
		end)
		
		test('__sub is supported', function()
			assert_equal(p1 - p2, sPoint3D(-1, -1, -1))
		end)
		
		test('__mul is supported', function()
			assert_equal(p1 * p2, sPoint3D(2, 12, 30))
		end)		
		
		test('__div is supported', function()
			assert_equal(p1 / p2, sPoint3D(1/2, 3/4, 5/6))
		end)		

		test('__mod is supported', function()
			assert_equal(p1 % 2, sPoint3D(1, 1, 1))
			assert_equal(p2 % 2, sPoint3D(0, 0, 0))
		end)		

		test('__pow is supported', function()
			assert_equal(p1 ^ 3, Point3D(1, 27, 125))
			assert_equal(p2 ^ 4, Point3D(16, 256, 1296))
		end)
		
		test('__unm is supported', function()
			assert_equal(-p1, sPoint3D(-1, -3, -5))
			assert_equal(-p2, sPoint3D(-2, -4, -6))
		end)			
		
		test('__concat is supported', function()
			assert_equal(p1 .. p2, sPoint3D('12','34','56'))
			assert_equal(p2 .. p1, sPoint3D('21','43','65'))
		end)
		
		test('__eq is supported', function()
			assert_not_equal(p1, p2)
			assert_equal(p1, sPoint3D(1, 3, 5))
			assert_equal(p2, sPoint3D(2, 4, 6))
		end)
		
		test('__lt is supported', function()
			assert_true(p1 < p2)
			assert_false(p2 < p1)
		end)
		
		test('__le is supported', function()
			assert_true(p1 <= p1)
			assert_true(p2 <= p2)
			assert_true(p1 <= p2)
			assert_false(p2 <= p1)
		end)		
		
		test('__metatable is supported', function()
			assert_equal(getmetatable(p1), "sPoint3D class metatable")
		end)
					
	end)

end)

if has_lua_5_2_support then	
	load([[
		require 'luacov'
		local class = require('30log-clean')
		local function same(t1, t2)
			for k, v in pairs(t1) do
				if v ~= t2[k] then return false end
			end
			for k, v in pairs(t2) do
				if v ~= t1[k] then return false end
			end
			return true
		end

		local Point3D, sPoint3D
		local garbage, p1, p2
			
		context('Lua 5.2.x metamethods are supported', function()
			
			before(function()
			
				Point3D = class('Point3D', {x = 0, y = 0, z = 0})
				function Point3D:init(x, y, z) self.x, self.y, self.z = x, y, z end

				Point3D.iterate = function(a)
					local k, v
					return function()
						k, v = next(a, k)
						return k, v
					end
				end
				
				Point3D.__len =function (a) return 3 end
				Point3D.__pairs = function(a)
					local fields = {x = a.x, y = a.y, z = a.z}
					local k, v
					return function()
						k, v = next(fields, k)
						return k, v
					end
				end
				Point3D.__ipairs = function(a)
					local fields = {a.x, a.y, a.z}
					local k, v
					return function()
						k, v = next(fields, k)
						return k, v
					end
				end
			
				sPoint3D = Point3D:extend('sPoint3D')
				sPoint3D.__metatable = "sPoint3D class metatable"
				
			end)

			context('by instances of a class', function()
				
				before(function()
					p1 = Point3D(1, 3, 5)
					p2 = Point3D(2, 4, 6)
				end)
				
				test('__len is supported', function()
					assert_equal(#p1, 3)
					assert_equal(#p2, 3)
				end)
				
				test('__pairs is supported', function()
					local _pairs = {x = 1, y = 3, z = 5}
					local _ipairs = _pairs
					for k, v in pairs(p1) do
						assert_equal(_pairs[k], v)
					end
				end)

				test('__ipairs is supported', function()
					local _ipairs = {2, 4, 6}
					for k, v in ipairs(p2) do
						assert_equal(_ipairs[k], v)
					end
				end)				
						
			end)
			
			context('by instances of a class\' subclasses', function()
				
				before(function()
					p1 = sPoint3D(1, 3, 5)
					p2 = sPoint3D(2, 4, 6)
				end)
				
				test('__len is supported', function()
					assert_equal(#p1, 3)
					assert_equal(#p2, 3)
				end)
				
				test('__pairs is supported', function()
					local _pairs = {x = 1, y = 3, z = 5}
					local _ipairs = _pairs
					for k,v in pairs(p1) do
						assert_equal(_pairs[k], v)
					end
				end)
				
				test('__ipairs is supported', function()
					local _ipairs = {2, 4, 6}
					for k, v in ipairs(p2) do
						assert_equal(_ipairs[k], v)
					end
				end)				
						
			end)

		end)
	]],nil, nil, _ENV)()
end

if has_lua_5_3_support then
	load([[
		require 'luacov'
		local class = require('30log-clean')

		local Point3D, sPoint3D
		local garbage, p1, p2

		context('Lua 5.3.x metamethods are supported', function()
			
			before(function()
			
				Point3D = class('Point3D', {x = 0, y = 0, z = 0})
				function Point3D:init(x, y, z) self.x, self.y, self.z = x, y, z end
				Point3D.__eq = function(a,b) return a.x == b.x and a.y == b.y and a.z == b.z end					
				Point3D.__gc = function(a) garbage = a end
				Point3D.__band = function(a,n) return Point3D(a.x & n, a.y & n, a.z & n) end
				Point3D.__bor = function(a,n) return Point3D(a.x | n, a.y | n, a.z | n) end
				Point3D.__bxor = function(a,n) return Point3D(a.x ~ n, a.y ~ n, a.z ~ n) end
				Point3D.__shl = function(a,n) return Point3D(a.x << n, a.y << n, a.z << n) end
				Point3D.__shr = function(a,n) return Point3D(a.x >> n, a.y >> n, a.z >> n) end
				Point3D.__bnot = function(a) return Point3D(~a.x, ~a.y, ~a.z) end
				Point3D.__idiv = function(a, n) return Point3D(a.x // n, a.y // n, a.z // n) end
			
				sPoint3D = Point3D:extend('sPoint3D')
				sPoint3D.__metatable = "sPoint3D class metatable"
				
			end)

			context('by instances of a class', function()
				
				before(function()			
					p1 = Point3D(1, 3, 5)
					p2 = Point3D(2, 4, 6)
				end)
					
				test('__band is supported', function()
					assert_equal(p1 & 1, Point3D(1, 1, 1))
					assert_equal(p2 & 1, Point3D(0, 0, 0))
				end)		

				test('__bor is supported', function()
					assert_equal(p1 | 1, Point3D(1, 3, 5))
					assert_equal(p2 | 1, Point3D(3, 5, 7))
				end)
				
				test('__bxor is supported', function()
					assert_equal(p1 ~ 1, Point3D(0, 2, 4))
					assert_equal(p2 ~ 1, Point3D(3, 5, 7))
				end)
				
				test('__shl is supported', function()
					assert_equal(p1 << 1, Point3D(2, 6, 10))
					assert_equal(p2 << 1, Point3D(4, 8, 12))
				end)

				test('__shr is supported', function()
					assert_equal(p1 >> 1, Point3D(0, 1, 2))
					assert_equal(p2 >> 1, Point3D(1, 2, 3))
				end)

				test('__bnot is supported', function()
					assert_equal(~p1, Point3D(-2, -4, -6))
					assert_equal(~p2, Point3D(-3, -5, -7))
				end)

				test('__idiv is supported', function()
					assert_equal(p1 // 2, Point3D(0, 1, 2))
					assert_equal(p2 // 2, Point3D(1, 2, 3))
				end)
				
				test('__gc is supported', function()
					collectgarbage()
					p1 = nil
					collectgarbage()
					assert_true(garbage ~= nil)
				end)

			end)

			context('by instances of a class\' subclasses, except "__call" and "__mode"', function()
				
				before(function()
					p1 = sPoint3D(1, 3, 5)
					p2 = sPoint3D(2, 4, 6)
				end)

				test('__band is supported', function()
					assert_equal(p1 & 1, sPoint3D(1, 1, 1))
					assert_equal(p2 & 1, sPoint3D(0, 0, 0))
				end)		
					
				test('__bor is supported', function()
					assert_equal(p1 | 1, sPoint3D(1, 3, 5))
					assert_equal(p2 | 1, sPoint3D(3, 5, 7))
				end)
				
				test('__bxor is supported', function()
					assert_equal(p1 ~ 1, sPoint3D(0, 2, 4))
					assert_equal(p2 ~ 1, sPoint3D(3, 5, 7))
				end)
				
				test('__shl is supported', function()
					assert_equal(p1 << 1, sPoint3D(2, 6, 10))
					assert_equal(p2 << 1, sPoint3D(4, 8, 12))
				end)

				test('__shr is supported', function()
					assert_equal(p1 >> 1, sPoint3D(0, 1, 2))
					assert_equal(p2 >> 1, sPoint3D(1, 2, 3))
				end)

				test('__bnot is supported', function()
					assert_equal(~p1, sPoint3D(-2, -4, -6))
					assert_equal(~p2, sPoint3D(-3, -5, -7))
				end)

				test('__idiv is supported', function()
					assert_equal(p1 // 2, sPoint3D(0, 1, 2))
					assert_equal(p2 // 2, sPoint3D(1, 2, 3))
				end)
				
				test('__gc is supported', function()
					collectgarbage()
					p1 = nil
					collectgarbage()
					assert_true(garbage ~= nil)
				end)	
				
			end)

		end)		
		
	]], nil, nil, _ENV)()
end
