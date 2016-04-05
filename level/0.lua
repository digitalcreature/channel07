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

local tile = Tile(Tile.Material.Texture("level/stone.png"))

local key = {
	[1] = player.key,
	[2] = tile,
	[3] = Tile(Tile.Material.Texture("level/block.png")),
	[4] = tile,
	[5] = tile,
}

return Level.load("level/0.png", key)
