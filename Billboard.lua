require "oop"
require "camera"
require "screen"
require "render"

require "Pool"

Billboard = class() do

	local base = Billboard

	function base:init(image, frames, width, height, originx, originy, flags)
		width = width or 1
		height = height or 1
		self.width = width
		self.height = height
		self.originx = originx or width / 2
		self.originy = originy or height / 2
		if type(image) == "string" then
			image = love.graphics.newImage(image)
		end
		self.image = image
		self.quads = {}
		for i = 1, frames do
			self.quads[i] = love.graphics.newQuad((i - 1) * width, 0, width, height, width * frames, height)
		end
		self.nonsolid = true		--dont collide with entities
		self.invisible = true	--dont hit with camera raycast
		self.nofog = flags and flags.nofog
	end

	function base:render(x, y, z, animfps)
		local info = {}
		Vector.set(info, x, y, z)
		info.dist, info.scanx = camera:getscreenpoint(x, y, z)
		info.nofog = self.nofog
		info.animfps = animfps or 30
		render.render(self, info)
	end

	function base:draw(info)
		love.graphics.push()
			love.graphics.translate(info.scanx, screen.height / 2)
			love.graphics.scale((screen.height / info.dist) * self.width, (screen.height / info.dist) * self.height)
			local x = -self.originx
			local y = camera.pos.z - info.z - self.originy
			love.graphics.translate(x, y)
			local frame = math.floor((love.timer.getTime() * info.animfps) % #self.quads) + 1
			love.graphics.draw(self.image, self.quads[frame], 0, 0)
		love.graphics.pop()
	end

end
