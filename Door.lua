require "oop"
require "physics"
require "player"
require "hud"

require "Tile"
require "Vector"

Door = subclass(TextureTile) do

	local base = Door

	base.opent = 0
	base.openrate = 0
	base.transparent = true
	base.radius = 1.5
	base.opentime = 1/2

	function base:init(key, xtex, ytex)
		base.super.init(self, xtex, ytex)
		self.key = key
	end

	local temp = Vector()
	function base:update(dt)
		self.opent = self.opent + self.openrate * dt
		self.opent = math.clamp(self.opent)
		if self.opent == 0 or self.opent == 1 then self.openrate = 0 end
		self.nonsolid = self.opent >= player.w
		if temp:set(self.entity:center()):dist2(player:center()) <= (self.radius * self.radius) then
			if not self.key or player[self.key] then
				self:open()
			else
				hud.message = "need "..self.key
			end
		else
			self:close()
		end
	end

	function base:open()
		self.openrate = 1 / self.opentime
	end

	function base:close()
		self.openrate = -1 / self.opentime
	end

	function base:shader(info)
		local quads
		local quadcount
		local tex
		local u
		if info.axis == "x" then
			u = info.y - info.j
			if info.sign < 0 then u = 1 - u end
			quads = self.xquads
			quadcount = self.xquadcount
			tex = self.xtex
		else
			u = info.x - info.i
			if info.sign > 0 then u = 1 - u end
			quads = self.yquads
			quadcount = self.yquadcount
			tex = self.ytex
		end
		if u < (1 - self.opent) / 2 then
			u = u + 1/2 * self.opent
		elseif u > (1 + self.opent) / 2 then
			u = u - 1/2 * self.opent
		else
			u = nil
		end
		if u and u >= 0 and u < 1 then
			local quad = quads[math.floor(u * quadcount)]
			love.graphics.draw(tex, quad)
		end
	end

	function Door:getkey()
		return function (x, y, level)
			local door = self()
			local entity = door:Entity(x, y):addtodomain(level.domain)
			return door, entity
		end
	end

	Door.Entity = subclass(physics.Entity) do

		local base = Door.Entity

		function base:init(door, x, y)
			base.super.init(self, 1, 1)
			self.x, self.y = x, y
			self.door = door
			door.entity = self
		end

		function base:update(dt)
			self.door:update(dt)
		end

	end

end

Door.Red = subclass(Door) do

	local base = Door.Red

	function base:init()
		base.super.init(self, "red key", "level/door-red.png")
	end

end

Door.Green = subclass(Door) do

	local base = Door.Green

	function base:init()
		base.super.init(self, "green key", "level/door-green.png")
	end

end

Door.Blue = subclass(Door) do

	local base = Door.Blue

	function base:init()
		base.super.init(self, "blue key", "level/door-blue.png")
	end

end
