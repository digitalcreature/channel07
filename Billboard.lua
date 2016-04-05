require "oop"

Billboard = class() do

	local base = Billboard

	function base:init(image, w, h, ox, oy)
		self.width = w or 1
		self.height = h or 1
		self.ox = ox or .5
		self.oy = oy or .5
		if type(image) == "string" then
			image = love.graphics.newImage(image)
		end
		self.image = image
		self.quad = love.graphics.newQuad(0, 0, image:getWidth(), image:getHeight(), w, h)
	end

	function base:render(pos, dist, scanx, i, j, axis)
		if dist > 0 then
			love.graphics.push()
				love.graphics.translate(scanx, screen.height / 2)
				love.graphics.scale((screen.height / dist) * self.width, (screen.height / dist) * self.height)
				love.graphics.translate(0, pos.z - 1)
			love.graphics.pop()
		end
	end

end
