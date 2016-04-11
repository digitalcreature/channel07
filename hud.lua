require "player"

hud =  {}

hud.damageflasht = 0
hud.damageflashcolor = color.red

hud.deathmessageflashrate = 1

local heart = love.graphics.newImage("sprite/heart.png")
local bullet = love.graphics.newImage("sprite/bullet.png")

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
	if player.dead then
		local x = (screen.width / 2) - (deadmessage:getWidth() / 2)
		local y = (screen.height / 2) - (deadmessage:getHeight() / 2)
		love.graphics.draw(deadmessage, x, y)
	else
		local w, h = heart:getDimensions()
		for i = 0, player.health - 1 do
			love.graphics.draw(heart, i * w)
		end
		w, h = bullet:getDimensions()
		for i = 0, player.gun.mag -1 do
			love.graphics.draw(bullet, i * w, screen.height - h)
		end
		local x = (screen.width / 2) - (crosshair:getWidth() / 2)
		local y = (screen.height / 2) - (crosshair:getHeight() / 2)
		love.graphics.draw(crosshair, x, y)
	end
end

function hud:damageflash()
	self.damageflasht = 1
end
