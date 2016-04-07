require "oop"
require "physics"
require "render"

require "State"
require "Vector"
require "Billboard"

Level = subclass(State) do

	local base = Level

	function	base:init(width, height)
		self.domain = physics.Domain(width, height)
	end

	function base:update(dt)
		player:update(dt)
	end

	function base:draw()
		love.graphics.clear()
		camera:render()
		self:renderbillboards()
		render:draw()
	end

	local pos = Vector()
	function base:renderbillboards()
		for x = 0, self.domain.width - 1 do
			for y = 0, self.domain.height - 1 do
				local obj = self.domain[x][y]
				if type(obj) == "table" and obj.class == Billboard then
					obj:render(x + .5, y + .5, 0)
				end
			end
		end
	end

	function Level.setcurrent(level)
		Level.current = level
		State.setcurrent(level)
		physics.Domain.setcurrent(level.domain)
	end

	function Level.load(map, key)
		if type(map) == "string" then
			map = love.image.newImageData(map)
		end
		local w, h = map:getDimensions()
		local level = Level(w, h)
		local pallete = {}
		for i, obj in ipairs(key) do
			local pixel = {map:getPixel(i - 1, 0)}
			pallete[pixel] = obj
		end
		local yoffset = math.floor(#key / w) + 1
		h = h - yoffset
		for x = 0, w - 1 do
			for y = 0, h - 1 do
				local pixel = {map:getPixel(x, y + yoffset)}
				local obj = nil
				for c, o in pairs(pallete) do
					if color.equals(pixel, c, true) then
						obj = o
						break
					end
				end
				if type(obj) == "function" then
					obj = obj(x, y)
				end
				if type(obj) == "table" then
					if not obj.nontile then
						level.domain:set(x, y, obj)
					end
				else
					level.domain:set(x, y, obj)
				end
			end
		end
		return level
	end

end
