require "oop"
require "camera"
require "screen"
require "render"

require "Pool"

Billboard = class() do

	local base = Billboard

	function base:init(image, frames, width, height, originx, originy)
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
		for i = 0, frames - 1 do
			self.quads[i] = love.graphics.newQuad(i * width, 0, width, height, width * frames, height)
		end
		self.nonsolid = true		--dont collide with entities
		self.invisible = true	--dont hit with camera raycast
	end

	function base:render(x, y, z)
		local info = tablepool:checkout()
		Vector.set(info, x, y, z)
		info.dist, info.scanx = camera:getscreenpoint(x, y, z)
		render.render(self, info)
	end

	function base:draw(info)
		love.graphics.push()
			love.graphics.translate(info.scanx, screen.height / 2)
			love.graphics.scale((screen.height / info.dist) * self.width, (screen.height / info.dist) * self.height)
			local x = -self.originx
			local y = camera.pos.z - info.z - self.originy
			love.graphics.translate(x, y)
			love.graphics.draw(self.image, self.quads[0], 0, 0)
		love.graphics.pop()
	end

end
