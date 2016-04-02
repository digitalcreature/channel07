require "level"
require "color"
require "player"

local wall = {name = "wall"}
function wall.draw()
	love.graphics.setColor(color.white)
	love.graphics.rectangle("fill", 0, 0, 1, 1)
end

local key = {
	player.key,
	wall,
}

return level.loadLevel("level/0.png", key)
