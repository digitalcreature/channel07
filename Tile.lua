require "oop"
require "color"
require "camera"

Tile = class() do

	local base = Tile

	function base:init() end

	function base:draw(info)
		love.graphics.push()
			love.graphics.translate(info.scanx, screen.height / 2)
			love.graphics.scale(1, screen.height / info.dist)
			love.graphics.translate(0, - 1 - info.z + camera.pos.z)
			self:shader(info)
		love.graphics.pop()
	end

	function base:shader(info)
		error("tile without shader:", self, "render info: ", info)
	end

end

ColorTile = subclass(Tile) do

	local base = ColorTile

	function base:init(xcolor, ycolor)
		base.super.init(self)
		self.xcolor = xcolor or color.white
		self.ycolor = ycolor or self.xcolor
	end

	function base:shader(info)
		if info.acis == "x" then
			love.graphics.setColor(self.xcolor)
		else
			love.graphics.setColor(self.ycolor)
		end
		love.graphics.rectangle("fill", 0, 0, 1, 1)
	end

end

TextureTile = subclass(Tile) do

	local base = TextureTile

	function base:init(xtex, ytex)
		base.super.init(self)
		if type(xtex) == "string" then
			xtex = love.graphics.newImage(xtex, format)
		end
		if type(ytex) == "string" then
			ytex = love.graphics.newImage(ytex, format)
		end
		self.xtex = xtex
		local xw = xtex:getWidth()
		self.xquadcount = xw
		self.xquads = {}
		for i = 0, xw - 1 do
			self.xquads[i] = love.graphics.newQuad(i, 0, 1, 1, xw, 1)
		end
		if (ytex) then
			self.ytex = ytex
			local yw = ytex:getWidth()
			self.yquadcount = yw
			self.yquads = {}
			for i = 0, yw - 1 do
				self.yquads[i] = love.graphics.newQuad(i, 0, 1, 1, yw, 1)
			end
		else
			self.ytex = xtex
			self.yquadcount = self.xquadcount
			self.yquads = self.xquads
		end
	end

	function base:shader(info)
		if info.axis == "x" then
			local u = info.y - info.j
			if info.sign < 0 then u = 1 - u end
			local quad = self.xquads[math.floor(u * self.xquadcount)]
			love.graphics.draw(self.xtex, quad)
		else
			local u = info.x - info.i
			if info.sign > 0 then u = 1 - u end
			local quad = self.yquads[math.floor(u * self.yquadcount)]
			love.graphics.draw(self.ytex, quad)
		end
	end

end
