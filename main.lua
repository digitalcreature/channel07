love.graphics.setDefaultFilter("nearest", "nearest")

require "screen"
require "player"
require "color"
require "camera"
require "debug2"
require "pause"

require "Level"

function love.load(arg)
	screen.load()
	Level.setcurrent(require "level.0")
	player:load()
end

function love.update(dt)
	if not pause.paused then
		player:update(dt)
	end
end

function screen.draw()
	love.graphics.clear()
	camera:draw()
end

-- function debug.draw()
-- 	local scale = 10
-- 	love.graphics.push()
-- 		love.graphics.scale(scale, scale)
-- 		for x = 0, level.current.width - 1 do
-- 			for y = 0, level.current.height - 1 do
-- 				local obj = level.current[x][y]
-- 				if obj then
-- 					love.graphics.push()
-- 						love.graphics.translate(x, y)
-- 						obj:draw()
-- 					love.graphics.pop()
-- 				end
-- 			end
-- 		end
-- 		player:draw()
-- 	love.graphics.pop()
-- end

function love.keypressed(key)
	return screen.keypressed(key) or pause.keypressed(key)
end

function love.mousepressed(x, y, button)
	return pause.mousepressed(x, y, button)
end
