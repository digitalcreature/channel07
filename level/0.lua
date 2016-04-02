require "level"
require "color"

local player = {name = "player"}
function player.draw()
	love.graphics.setColor(color.blue)
	love.graphics.rectangle("fill", 0, 0, 1, 1)
end

local wall = {name = "wall"}
function wall.draw()
	love.graphics.setColor(color.white)
	love.graphics.rectangle("fill", 0, 0, 1, 1)
end

local key = {
	player,
	wall,
}

return level.loadLevel("level/0.png", key)
