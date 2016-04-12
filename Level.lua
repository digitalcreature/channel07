require "oop"
require "physics"
require "render"
require "hud"

require "State"
require "Vector"
require "Tile"
require "Billboard"

Level = subclass(State) do

	local base = Level

	function	base:init(width, height)
		self.domain = physics.Domain(width, height)
	end

	function base:onenter()
		Level.current = self
		physics.Domain.setcurrent(self.domain)
	end

	function base:update(dt)
		hud:update(dt)
		self.domain:update(dt)
	end

	function base:draw()
		love.graphics.clear()
		camera:render()
		player:render()
		for i = 1, #self.domain.entities do
			local entity = self.domain.entities[i]
			if not entity:isinactive() and entity.render then
				entity:render()
			end
		end
		render:draw()
		hud:draw()
	end

	function base:mousepressed(x, y, button)
		return player:mousepressed(x, y, button)
	end

	function base:keypressed(key)
		return player:keypressed(key)
	end

	function Level.load(map, key)
		if type(map) == "string" then
			map = love.image.newImageData(map)
		end
		local w, h = map:getDimensions()
		local level = Level(w, h)
		local pallete = {}
		for i, obj in pairs(key) do
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
					obj = obj(x, y, level)
				end
				if type(obj) == "table" then
					if instanceof(obj, Tile) then
						level.domain:set(x, y, obj)
					end
					if instanceof(obj, physics.Entity) then
						level.domain:addentity(obj)
					end
				else
					level.domain:set(x, y, obj)
				end
			end
		end
		return level
	end


end
