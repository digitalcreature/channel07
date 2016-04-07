require "color"
require "player"

require "Level"
require "Tile"

local wall = TextureTile("level/wall.png")
local wall_stripe = TextureTile("level/wall_stripe.png")
local wall_7 = TextureTile("level/wall_7.png")

local plant = Billboard("level/plant.png", 1, 1/2, 1, 1/4, 1)

local key = {
	[1] = player.key,
	[2] = wall,
	[3] = wall_stripe,
	[4] = wall_7,
	[5] = plant,
}

return Level.load("level/0.png", key)
