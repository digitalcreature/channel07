require "screen"
require "level"
require "player"
require "color"
require "vector"
require "camera"

function love.load(arg)
	screen.load()
	level.current = require "level.0"
end

function love.update(dt)
	player:update(dt)
end

function screen.draw()
	love.graphics.clear()
end

function debugdraw()
	local scale = 24
	love.graphics.push()
		love.graphics.scale(scale, scale)
		for x = 0, level.current.width - 1 do
			for y = 0, level.current.height - 1 do
				local obj = level.current[x][y]
				if obj then
					love.graphics.push()
						love.graphics.translate(x, y)
						obj:draw()
					love.graphics.pop()
				end
			end
		end
		player:draw()
		love.graphics.setLineWidth(1 / scale)
		camera:draw()
	love.graphics.pop()
end

function love.keypressed(key)
	screen.keypressed(key)
end
