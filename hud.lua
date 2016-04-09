require "player"

hud =  {}

hud.damageflasht = 0
hud.damageflashcolor = color.red

hud.deathmessageflashrate = 1

local heart = love.graphics.newImage("sprite/heart.png")
local deadmessage = love.graphics.newImage("sprite/deadmessage.png")
local crosshair = love.graphics.newImage("sprite/crosshair.png")

function hud:update(dt)
	if self.damageflasht > 0 then
		self.damageflasht = self.damageflasht - dt / player.damagecooldown
		self.damageflasht = math.clamp(self.damageflasht)
	end
end

function hud:draw()
	love.graphics.setColor(color.lerp(color.clear, self.damageflashcolor, self.damageflasht))
	love.graphics.rectangle("fill", 0, 0, screen.width, screen.height)
	love.graphics.setColor(color.white)
	for i = 0, player.health - 1 do
		love.graphics.draw(heart, i * heart:getWidth())
	end
	if player.dead then
		local x = (screen.width / 2) - (deadmessage:getWidth() / 2)
		local y = (screen.height / 2) - (deadmessage:getHeight() / 2)
		love.graphics.draw(deadmessage, x, y)
	else
		local x = (screen.width / 2) - (crosshair:getWidth() / 2)
		local y = (screen.height / 2) - (crosshair:getHeight() / 2)
		love.graphics.draw(crosshair, x, y)
	end
end

function hud:damageflash()
	self.damageflasht = 1
end
