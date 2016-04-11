require "oop"
require "color"
require "physics"
require "camera"
require "screen"
require "util"

require "Billboard"
require "Vector"
require "LivingEntity"
require "ParticleExplosion"

player = LivingEntity(1/3, 1/3)
player.health = 5
player.damagecooldown = 3/4

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
		local mousex = love.mouse.getX()
		local center = love.window.getMode() / 2
		ddir = ddir - (mousex - center) * self.sensitivity
		love.mouse.setVisible(false)
		screen.centercursor()
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

local wallhitsprite = Billboard("sprite/wallhit.png", 1, 1/5, 1/5)

local line, epos = util.calln(2, Vector)
local function raycasthitprocessor(startpos, dir, pos, dist, obj, hitindex, axis, sign, i, j, ...)
	if hitindex == 0 then
		local nearest, nearestdist2
		for i = 1, #Enemy.all do
			local enemy = Enemy.all[i]
			local dist
			line:set(pos:xy(0)):sub(startpos:xy(0))
			epos:set(enemy:center()):sub(startpos:xy(0))
			local len2 = line:len2()
			if len2 == 0 then
				dist = epos:len()
			else
				local t = math.clamp(epos:dot(line) / len2)
				local proj = line:scale(t)
				dist = proj:dist(epos)
			end
			if dist <= enemy.damageradius then
				local disttoplayer2 = epos:set(enemy:center()):dist2(player:center())
				if not nearestdist2 or disttoplayer2 < nearestdist2 then
					nearestdist2 = disttoplayer2
					nearest = enemy
				end
			end
		end
		if nearest then
			nearest:takedamage()
		else
			local explosion = ParticleExplosion(wallhitsprite, 50, 1/2, 1, 1/10, 1/2, -20):addtodomain():center(pos:xy())
			explosion.z = player.headheight
		end
	end
end

local pos, dir = Vector(), Vector()
function player:fireweapon()
	local x, y = self:center()
	physics.Domain.current:raycast(pos:set(self:center()), dir:set(Vector.east()):rotate2d(self.dir), nil, raycasthitprocessor)
end

function player:mousepressed(x, y, button)
	if button == 1 then
		if not self.dead then
			self:fireweapon()
			return true
		end
	else
		self:takedamage()
	end
end

function player:keypressed(key)
	if key == "space" then
		self:fireweapon()
		return true
	end
end

function player:takedamage(damage)
	if self.class.takedamage(self, damage) then
		hud:damageflash()
	end
end

function player:render()
end
