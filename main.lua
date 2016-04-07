love.graphics.setDefaultFilter("nearest", "nearest")

require "screen"
require "player"
require "color"
require "camera"
require "debug2"
require "pause"

require "State"
require "Level"
require "Billboard"

function love.load(arg)
	screen.load()
	Level.setcurrent(require "level.0")
	player:load()
end

function love.update(dt)
	if not pause.paused then
		State.current:update(dt)
	end
end

function screen.draw()
	State.current:draw()
end

function love.keypressed(key)
	return screen.keypressed(key) or pause.keypressed(key)
end

function love.mousepressed(x, y, button)
	return pause.mousepressed(x, y, button)
end
