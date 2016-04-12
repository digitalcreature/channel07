require "player"
require "font"

hud =  {}

hud.damageflasht = 0
hud.damageflashcolor = color.red

hud.noammoflashrate = 1
hud.deathmessageflashrate = 1

local heart = love.graphics.newImage("sprite/heart.png")
local bullet = love.graphics.newImage("sprite/bullet.png")

local noammo = love.graphics.newImage("sprite/noammo.png")
local reloading = love.graphics.newImage("sprite/reloading.png")

local gun = love.graphics.newImage("sprite/gun.png")
local gun_fire = love.graphics.newImage("sprite/gun-fire.png")
local gun_reload = love.graphics.newImage("sprite/gun-reload.png")

local deadmessage = love.graphics.newImage("sprite/deadmessage.png")
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
	love.graphics.setColor(color.lerp(color.clear, self.damageflashcolor, self.damageflasht))
	love.graphics.rectangle("fill", 0, 0, screen.width, screen.height)
	love.graphics.setColor(color.white)
	if player.dead then
		if love.timer.getTime() % self.deathmessageflashrate < self.deathmessageflashrate / 2 then
			local x = (screen.width / 2) - (deadmessage:getWidth() / 2)
			local y = (screen.height / 2) - (deadmessage:getHeight() / 2)
			love.graphics.draw(deadmessage, x, y)
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
			if (love.timer.getTime() - player.gun.lastfiretime) / player.gun.cooldown > 2/3 then
				w, h = gun:getDimensions()
				love.graphics.draw(gun, screen.width - w, screen.height - h)
			else
				w, h = gun_fire:getDimensions()
				love.graphics.draw(gun_fire, screen.width - w, screen.height - h)
			end
		else
			w, h = reloading:getDimensions()
			love.graphics.draw(reloading, 0, screen.height - h)
			w, h = gun_reload:getDimensions()
			love.graphics.draw(gun_reload, screen.width - w, screen.height - h)
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
			love.graphics.setFont(font.cool)
			love.graphics.printf(self.message, 0, 8, screen.width, "center")
		end
	end
end

function hud:damageflash()
	self.damageflasht = 1
end
