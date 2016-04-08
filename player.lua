require "oop"
require "color"
require "physics"
require "camera"
require "screen"

require "Billboard"
require "Vector"

player = physics.Entity(0, 0, 1/3, 1/3)

--facing direction
player.dir = 0
--move speed
player.spdx = 2
player.spdy = 2
--keyboard look speed (rad/s)
player.lookspd = 1.5
--mouselook sensitivity
player.sensitivity = .003

player.headheight = 0.6
player.deathheight = 0.15

player.health = 5
player.damagecooldown = 3/4

function player:load()
	screen.centercursor()
end

function player:getkey(angle)
	return function (x, y)
		player:center(x + .5, y + .5)
		player.dir = angle or 0
		return player
	end
end

local dpos = Vector()
function player:update(dt)
	if not self.dead then
		local ddir = 0
		if love.keyboard.isDown("left") then ddir = ddir + self.lookspd * dt end
		if love.keyboard.isDown("right") then ddir = ddir - self.lookspd * dt end
		if love.window.hasFocus() then
			local mousex = love.mouse.getX()
			local center = love.window.getMode() / 2
			ddir = ddir - (mousex - center) * self.sensitivity
			love.mouse.setVisible(false)
			screen.centercursor()
		end
		self.dir = self.dir + ddir
		camera:setangle(self.dir)
		dpos:set(0, 0)
		if love.keyboard.isDown("w", "up") then dpos.y = dpos.y - self.spdy end
		if love.keyboard.isDown("s", "down") then dpos.y = dpos.y + self.spdy end
		if love.keyboard.isDown("a") then dpos.x = dpos.x - self.spdx end
		if love.keyboard.isDown("d") then dpos.x = dpos.x + self.spdx end
		dpos:rotate2d(self.dir - (math.pi / 2))
		dpos:scale(dt)
		self:move(dpos:xy())
	else
		local ddir = dt * .5
		self.dir = self.dir + ddir
		camera:setangle(self.dir)
	end
	local x, y = self:center()
	camera.pos:set(x, y, self.dead and self.deathheight or self.headheight)
end

local function raycasthitprocessor(startpos, dir, pos, dist, obj, hitindex, axis, sign, i, j, ...)
	if hitindex == 0 then
		BulletHit(pos:xy()):addtodomain()
	end
end

local pos, dir = Vector(), Vector()
function player:fireweapon()
	local x, y = self:center()
	physics.Domain.current:raycast(pos:set(self.x, self.y), dir:set(Vector.east()):rotate2d(self.dir), nil, raycasthitprocessor)
end

function player:mousepressed(x, y, button)
	if button == 1 then
		self:fireweapon()
		return true
	end
end

function player:keypressed(key)
	if key == "space" then
		self:fireweapon()
		return true
	end
end

local lastdamagetime = 0
function player:takedamage()
	if not self.dead then
		local time = love.timer.getTime()
		if time - lastdamagetime >= self.damagecooldown then
			lastdamagetime = time;
			hud:damageflash()
			self.health = self.health - 1
			if self.health <= 0 then
				self:die()
			end
		end
	end
end

function player:die()
	self.dead = true
end

function player:render()
end

BulletHit = subclass(physics.Entity) do

	local base = BulletHit

	local sprite = Billboard("sprite/hit.png", 1, 1/2, 1/2)

	function base:init(x, y)
		base.super.init(self, 0, 0, .1, .1)
		self:center(x, y)
		self.cooldown = 3
	end

	function base:update(dt)
		self.cooldown = self.cooldown - dt
		if self.cooldown <= 0 then
			self:removefromdomain()
		end
	end

	function base:render()
		local x, y = self:center()
		sprite:render(x, y, player.headheight)
	end

end
