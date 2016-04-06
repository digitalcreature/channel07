require "oop"
require "camera"
require "screen"
require "render"

Billboard = class() do

	local base = Billboard

	function base:init(image, width, height, originx, originy)
		self.width = width or 1
		self.height = height or 1
		self.originx = originx or self.width / 2
		self.originy = originy or self.height / 2
		if type(image) == "string" then
			image = love.graphics.newImage(image)
		end
		self.image = image
		image:setWrap("clampzero", "clampzero")
		self.quad = love.graphics.newQuad(0, 0, image:getWidth(), image:getHeight(), self.width, self.height)
	end

	function base:render(pos)
		local dist = camera:getdist(pos)
		local scanx = camera:getscanx(pos, dist)
		render.render(self, pos, dist, scanx)
	end

	function base:draw(pos, dist, scanx, i, j, axis)
		love.graphics.push()
			love.graphics.translate(scanx, screen.height / 2)
			love.graphics.scale((screen.height / dist) * self.width, (screen.height / dist) * self.height)
			local x = -self.originx
			local y = camera.pos.z - pos.z - self.originy
			love.graphics.translate(x, y)
			love.graphics.draw(self.image, self.quad, 0, 0)
		love.graphics.pop()
	end

end
