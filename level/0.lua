require "color"
require "player"

require "Level"
require "Tile"

-- local function draw(self)
-- 	love.graphics.setColor(self.color)
-- 	love.graphics.rectangle("fill", 0, 0, 1, 1)
-- end
--
-- local red = {color = color.red, draw = draw}
-- local yellow = {color = color.yellow, draw = draw}
-- local green = {color = color.green, draw = draw}
-- local blue = {color = color.blue, draw = draw}

local key = {
	[1] = player.key,
	[2] = Tile(),
	[3] = Tile(),
	[4] = Tile(),
	[5] = Tile(),
}

return Level.load("level/0.png", key)
