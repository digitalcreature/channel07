require "Level"
require "color"
require "player"

local function draw(self)
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", 0, 0, 1, 1)
end

local red = {color = color.red, draw = draw}
local yellow = {color = color.yellow, draw = draw}
local green = {color = color.green, draw = draw}
local blue = {color = color.blue, draw = draw}


local key = {
	[1] = player.key,
	[2] = red,
	[3] = yellow,
	[4] = green,
	[5] = blue,
}

return Level.load("level/0.png", key)
