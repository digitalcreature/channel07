require "color"
require "player"

require "Level"
require "Tile"
require "entity.TV"

local wall = TextureTile("level/wall.png")
local wall_stripe = TextureTile("level/wall_stripe.png")
local wall_7 = TextureTile("level/wall_7.png")

local key = {
	[1] = player:getkey(- math.pi / 2 + .1),
	[2] = wall,
	[3] = wall_stripe,
	[4] = wall_7,
	[5] = TV:getkey(),
}

local level = Level.load("level/0.png", key)

level.floorcolor = {48, 24, 24}
level.ceilingcolor = {32, 32, 32}

return level
