require "oop"

Vector = class() do

	local base = Vector

	function Vector.one() return 1, 1, 1 end
	function Vector.zero() return 0, 0, 0 end
	function Vector.north() return 0, -1, 0 end
	function Vector.south() return 0, 1, 0 end
	function Vector.east() return 1, 0, 0 end
	function Vector.west() return -1, 0, 0 end
	function Vector.up() return 0, 0, 1 end
	function Vector.down() return 0, 0, -1 end

	local function args(x, y, z)
		if type(x) == "table" then
			return x.x, x.y, x.z
		else
			return x, y, z
		end
	end

	function base:init(x, y, z)
		self:set(x, y, z)
	end

	function base:set(x, y, z)
		x, y, z = args(x, y, z)
		self.x = x or self.x or 0
		self.y = y or self.y or 0
		self.z = z or self.z or 0
		return self
	end

	function base:xy()
		return self.x, self.y
	end

	function base:xyz()
		return self.x, self.y, self.z
	end

	function base:add(x, y, z)
		local x, y, z = args(x, y, z)
		self.x = self.x + x
		self.y = self.y + y
		self.z = self.z + z
		return self
	end

	function base:scale(x, y, z)
		local x, y, z = args(x, y, z)
		y = y or x
		z = z or x
		self.x = self.x * x
		self.y = self.y * y
		self.z = self.z * z
		return self
	end

	function base:dot(x, y, z)
		local x, y, z = args(x, y, z)
		return self.x * x + self.y * y + self.z * z
	end

	function base:cross(x, y, z)
		local x, y, z = args(x, y, z)
		return
			self.y * z - self.z * y,
			self.z * x - self.x * z,
			self.x * y - self.y * x
	end

	function base:len2()
		return self:dot(self)
	end

	function base:len()
		return math.sqrt(self:len2())
	end

	function base:__tostring()
		return "<"..self.x..", "..self.y..", "..self.z..">"
	end

	function base.__eq(a, b)
		return
			a.x == b.x and
			a.y == b.y and
			a.z == b.z
	end

	function base:rotate2d(r)
		local x, y = self.x, self.y
		self.x = x * math.cos(-r) - y * math.sin(-r)
		self.y = x * math.sin(-r) + y * math.cos(-r)
		return self
	end

	function base:angle2d()
		return - math.atan2(self.y, self.x)
	end

	function base:norm()
		return self:scale(1 / self:len())
	end

	function base:projectscalar(x, y, z)
		local x, y, z = args(x, y, z)
		local len = math.sqrt(x * x + y * y + z * z)
		return self:dot(x, y, z) / len
	end

end
