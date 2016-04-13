require "oop"
require "physics"

require "Vector"

Item = subclass(physics.Entity) do

	local base = Item

	base.radius = 1/2

	function base:init()
		base.super.init(self, 1, 1)
		if self.class.sound then
			self.sound = self.class.sound:clone()
		end
	end

	local temp = Vector()
	function base:update(dt)
		if self:canbetaken() and temp:set(self:center()):dist2(player:center()) <= (self.radius * self.radius) then
			self:ontaken()
			self:removefromdomain()
			if self.sound then
				local x, y = self:center()
				self.sound:setPosition(x, y)
				self.sound:play()
			end
		end
	end

	function base:render()
		local x, y = self:center()
		local z = (math.sin(love.timer.getTime() * 8) + 1) / 16
		self.billboard:render(x, y, z)
	end

	function base:canbetaken() return true end
	function base:ontaken() end

end
