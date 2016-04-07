require "physics"
require "camera"
require "player"

require "Vector"

TV = subclass(physics.Entity) do

	local base = TV

	local tvs = {}
	local neighborradius = 3
	local avoidfactor = 3

	base.framesprite = Billboard("sprite/tv-frame.png", 1, 2/3, 2/3, 1/3, 1/3)
	base.staticsprite = Billboard("sprite/tv-static.png", 8, 2/3, 2/3, 1/3, 1/3)
	base.smilesprite = Billboard("sprite/tv-smile.png", 8, 2/3, 2/3, 1/3, 1/3)
	base.staticsprite.nofog = true

	base.speed = 1

	function base:init(x, y)
		base.super.init(self, 0, 0, 1/4, 1/4)
		table.insert(tvs, self)
	end

	local avoid, dpos, temp = Vector(), Vector(), Vector()
	function base:update(dt)
		local neighborcount = 0
		avoid:set(Vector:zero())
		for i = 1, #tvs do
			local tv = tvs[i]
			local dist = temp:set(self:center()):sub(tv:center()):len()
			if dist < neighborradius then
				neighborcount = neighborcount + 1
				temp:scale(avoidfactor * (1 - (dist / neighborradius)))
				avoid:add(temp)
			end
		end
		avoid:scale(1 / neighborcount)
		dpos:set(player:center()):sub(self:center()):norm():add(avoid):scale(self.speed * dt)
		self:move(dpos:xy())
	end

	function base:render()
		local x, y = self:center()
		local z = .6
		self.framesprite:render(x, y, z)
		local dist = camera:getscreenpoint(x, y, 0)
		if dist < 1 then
			self.smilesprite:render(x, y, z)
		else
			self.staticsprite:render(x, y, z)
		end
	end

end
