require "physics"
require "camera"

TV = subclass(physics.Entity) do

	local base = TV

	base.framesprite = Billboard("sprite/tv-frame.png", 1, 2/3, 2/3, 1/3, 1/3)
	base.staticsprite = Billboard("sprite/tv-static.png", 8, 2/3, 2/3, 1/3, 1/3)
	base.smilesprite = Billboard("sprite/tv-smile.png", 8, 2/3, 2/3, 1/3, 1/3)
	base.staticsprite.nofog = true

	function base:init(x, y)
		base.super.init(self, 0, 0, 1/4, 1/4)
	end

	-- local function 

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
