require "color"
require "player"

require "Level"
require "Tile"

local tile = Tile(Tile.Material.Texture("level/stone.png"))
local billboard = Billboard("love.png", 2/3, 2/3)
billboard.invisible = true
billboard.nonsolid = true

local key = {
	[1] = player.key,
	[2] = tile,
	[3] = billboard,
	[4] = tile,
	[5] = tile,
}

return Level.load("level/0.png", key)
