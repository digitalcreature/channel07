require "player"
require "font"

hud =  {}

hud.damageflasht = 0
hud.damageflashcolor = color.red

hud.noammoflashrate = 1
hud.deathmessageflashrate = 1
hud.winmessageflashrate = 1

local heart = love.graphics.newImage("sprite/heart.png")
local bullet = love.graphics.newImage("sprite/bullet.png")

local noammo = love.graphics.newImage("sprite/noammo.png")
local reloading = love.graphics.newImage("sprite/reloading.png")

local gun = love.graphics.newImage("sprite/gun.png")
local gun_fire = {
	love.graphics.newImage("sprite/gun-fire1.png"),
	love.graphics.newImage("sprite/gun-fire2.png"),
	love.graphics.newImage("sprite/gun-fire3.png"),
	gun,
}

local r1 = love.graphics.newImage("sprite/gun-reload1.png")
local r2 = love.graphics.newImage("sprite/gun-reload2.png")
local r3 = love.graphics.newImage("sprite/gun-reload3.png")
local gun_reload = {
	r1, r2, r3, r3, r3, r3, r3, r3, r3, r3, r3, r3, r2, r1
}

local deadmessage = love.graphics.newImage("sprite/deadmessage.png")
local winmessage = love.graphics.newImage("sprite/winmessage.png")
local crosshair = love.graphics.newImage("sprite/crosshair.png")


local key_red = love.graphics.newImage("sprite/key-red.png")
local key_green = love.graphics.newImage("sprite/key-green.png")
local key_blue = love.graphics.newImage("sprite/key-blue.png")

function hud:update(dt)
	if self.damageflasht > 0 then
		self.damageflasht = self.damageflasht - dt / player.damagecooldown
		self.damageflasht = math.clamp(self.damageflasht)
	end
	self.message = nil
end

function hud:draw()
	if not player.won then
		love.graphics.setColor(color.lerp(color.clear, self.damageflashcolor, self.damageflasht))
		love.graphics.rectangle("fill", 0, 0, screen.width, screen.height)
		love.graphics.setColor(color.white)
		love.graphics.setFont(font.cool)
		if player.dead then
			if love.timer.getTime() % self.deathmessageflashrate < self.deathmessageflashrate / 2 then
				local x = (screen.width / 2) - (deadmessage:getWidth() / 2)
				local y = (screen.height / 3) - (deadmessage:getHeight() / 2)
				love.graphics.draw(deadmessage, x, y)
				love.graphics.setColor(192, 192, 192)
				love.graphics.printf("press f5 to retry", 0, screen.height - 24, screen.width, "center")
			end
		else
			local w, h = heart:getDimensions()
			for i = 0, player.health - 1 do
				love.graphics.draw(heart, i * w)
			end
			if not player.gun.reloadt then
				if player.gun.mag > 0 then
					w, h = bullet:getDimensions()
					for i = 0, player.gun.mag -1 do
						love.graphics.draw(bullet, i * w, screen.height - h)
					end
				else
					if love.timer.getTime() % self.noammoflashrate < self.noammoflashrate / 2 then
						w, h = noammo:getDimensions()
						love.graphics.draw(noammo, 0, screen.height - h)
					end
				end
				local firet = (love.timer.getTime() - player.gun.lastfiretime) / player.gun.cooldown
				if firet >= 1 then
					w, h = gun:getDimensions()
					love.graphics.draw(gun, screen.width - w, screen.height - h)
				else
					local sprite = gun_fire[math.floor(firet * #gun_fire) + 1]
					w, h = sprite:getDimensions()
					love.graphics.draw(sprite, screen.width - w, screen.height - h)
				end
			else
				w, h = reloading:getDimensions()
				love.graphics.draw(reloading, 0, screen.height - h)
				local reloadt = player.gun.reloadt / player.gun.reloadtime
				local sprite = gun_reload[math.floor(reloadt * #gun_reload) + 1]
				w, h = sprite:getDimensions()
				love.graphics.draw(sprite, screen.width - w, screen.height - h)
			end
			local x = (screen.width / 2) - (crosshair:getWidth() / 2)
			local y = (screen.height / 2) - (crosshair:getHeight() / 2)
			love.graphics.draw(crosshair, x, y)
			x = screen.width
			if player["blue key"] then
				x = x - key_blue:getWidth()
				love.graphics.draw(key_blue, x, 0)
			end
			if player["green key"] then
				x = x - key_green:getWidth()
				love.graphics.draw(key_green, x, 0)
			end
			if player["red key"] then
				x = x - key_red:getWidth()
				love.graphics.draw(key_red, x, 0)
			end
			if self.message then
				love.graphics.printf(self.message, 0, 8, screen.width, "center")
			end
		end
	else
		if love.timer.getTime() % self.winmessageflashrate < self.winmessageflashrate / 2 then
			local x = (screen.width / 2) - (winmessage:getWidth() / 2)
			local y = (screen.height / 3) - (winmessage:getHeight() / 2)
			love.graphics.draw(winmessage, x, y)
			love.graphics.setColor(192, 192, 192)
			love.graphics.printf("press f5 to play again", 0, screen.height - 24, screen.width, "center")
		end
	end
end

function hud:damageflash()
	self.damageflasht = 1
end
