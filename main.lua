require "screen"
require "level"
require "player"

function love.load(arg)
	screen.load()
	level.current = require "level.0"
end

function love.update(dt)
	player:update(dt)
end

local _lovedraw = love.draw

function love.draw()
	_lovedraw()
	love.graphics.push()
		love.graphics.scale(24, 24)
		love.graphics.clear()
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
	love.graphics.pop()
end

function love.keypressed(key)
	screen.keypressed(key)
end
