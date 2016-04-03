require "level"
require "color"
require "player"

local wall = {name = "wall", color = color.blue}
function wall.draw()
	love.graphics.setColor(255, 255, 255, 64)
	love.graphics.rectangle("fill", 0, 0, 1, 1)
end

local key = {
	[1] = player.key,
	[2] = wall,
}

return level.loadLevel("level/0.png", key)
