require "color"
require "player"

require "Level"
require "Tile"
require "entity.TV"

local wall = TextureTile("level/wall.png")
local wall_stripe = TextureTile("level/wall_stripe.png")
local wall_7 = TextureTile("level/wall_7.png")

local key = {
	player:getkey(- math.pi / 2 + .1),
	wall,
	wall_stripe,
	wall_7,
	TV:getkey(),
	nil,
	nil,
	nil,
	nil,
	"hello!",
}

return function ()
	local level = Level.load("level/0.png", key)
	level.floorcolor = {48, 24, 24}
	level.ceilingcolor = {32, 32, 32}
	return level
end
