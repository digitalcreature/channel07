require "oop"
require "physics"

require "Billboard"
require "Vector"

Key = subclass(physics.Entity) do

	local base = Key

	base.radius = 1/2

	function base:init()
		base.super.init(self, 1, 1)
	end

	local temp = Vector()
	function base:update(dt)
		if temp:set(self:center()):dist2(player:center()) <= (self.radius * self.radius) then
			player[self.name] = true
			self:removefromdomain()
		end
	end

	function base:render()
		local x, y = self:center()
		local z = (math.sin(love.timer.getTime() * 8) + 1) / 16
		self.billboard:render(x, y, z)
	end

end

Key.Red = subclass(Key) do

	local base = Key.Red

	base.name = "red key"
	base.billboard = Billboard("sprite/key-red.png", 1, 1/2, 2/3, 1/3, 1/3)

end

Key.Green = subclass(Key) do

	local base = Key.Green

	base.name = "green key"
	base.billboard = Billboard("sprite/key-green.png", 1, 1/2, 2/3, 1/3, 1/3)

end

Key.Blue = subclass(Key) do

	local base = Key.Blue

	base.name = "blue key"
	base.billboard = Billboard("sprite/key-blue.png", 1, 1/2, 2/3, 1/3, 1/3)

end
