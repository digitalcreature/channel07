require "oop"
require "camera"
require "screen"
require "render"

require "Pool"

Billboard = class() do

	local base = Billboard
	local firsttime = love.timer.getTime()

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
		self.animfps = 30 or flags and flags.animfps
		self.animmode = flags and flags.animmode or "loop"
		self.nofog = flags and flags.nofog
	end

	function base:render(x, y, z, animstarttime)
		local info = {}
		Vector.set(info, x, y, z)
		info.dist, info.scanx = camera:getscreenpoint(x, y, z)
		info.nofog = self.nofog
		info.animstarttime = animstarttime or firsttime
		render.render(self, info)
	end

	function base:draw(info)
		love.graphics.push()
			love.graphics.translate(info.scanx, screen.height / 2)
			love.graphics.scale((screen.height / info.dist) * self.width, (screen.height / info.dist) * self.height)
			local x = -self.originx
			local y = camera.pos.z - info.z - self.originy
			love.graphics.translate(x, y)
			local framei = ((love.timer.getTime() - info.animstarttime) * self.animfps)
			if self.animmode == "loop" then
				framei = framei % #self.quads
			elseif self.animmode == "clamp" then
				framei = math.clamp(framei, #self.quads - 1)
			else
				error("invalid animmode \""..self.animmode.."\"")
			end
			local frame = math.floor(framei) + 1
			love.graphics.draw(self.image, self.quads[frame], 0, 0)
		love.graphics.pop()
	end

end
