require "player"

ui =  {}

ui.damageflasht = 0
ui.damageflashtime = 1
ui.damageflashcolor = color.red

ui.deathmessageflashrate = 1

local heart = love.graphics.newImage("sprite/heart.png")
local deadmessage = love.graphics.newImage("sprite/deadmessage.png")

function ui:update(dt)
	if self.damageflasht > 0 then
		self.damageflasht = self.damageflasht - dt / self.damageflashtime
		self.damageflasht = math.clamp(self.damageflasht)
	end
end

function ui:draw()
	love.graphics.setColor(color.lerp(color.clear, self.damageflashcolor, self.damageflasht))
	love.graphics.rectangle("fill", 0, 0, screen.width, screen.height)
	love.graphics.setColor(color.white)
	for i = 0, player.health - 1 do
		love.graphics.draw(heart, i * heart:getWidth())
	end
	if player.dead then
		love.graphics.draw(deadmessage, 0, 0)
	end
end

function ui:damageflash()
	self.damageflasht = 1
end
