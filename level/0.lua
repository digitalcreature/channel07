require "color"
require "player"

require "Level"
require "Tile"
require "Door"
require "entity.TV"
require "entity.Key"

local wall_red = TextureTile("level/wall-red.png")
local wall_red_stripe = TextureTile("level/wall-red-stripe.png")
local wall_red_07 = TextureTile("level/wall-red-07.png")
local wall_green = TextureTile("level/wall-green.png")
local wall_green_stripe = TextureTile("level/wall-green-stripe.png")
local wall_green_07 = TextureTile("level/wall-green-07.png")
local wall_blue = TextureTile("level/wall-blue.png")
local wall_blue_stripe = TextureTile("level/wall-blue-stripe.png")
local wall_blue_07 = TextureTile("level/wall-blue-07.png")
local door_wall = TextureTile("level/door-wall.png")

local key = {
	player:getkey(- math.pi / 2 + .1),
	wall_red,
	wall_red_stripe,
	wall_red_07,
	wall_green,
	wall_green_stripe,
	wall_green_07,
	wall_blue,
	wall_blue_stripe,
	wall_blue_07,
	Door.Red:getkey(),
	Door.Green:getkey(),
	Door.Blue:getkey(),
	door_wall,
	Key.Red:getkey(),
	Key.Green:getkey(),
	Key.Blue:getkey(),
	TV:getkey(),
}

return function ()
	local level = Level.load("level/0.png", key)
	level.floorcolor = {32, 32, 32}
	level.ceilingcolor = {32, 32, 32}
	return level
end
