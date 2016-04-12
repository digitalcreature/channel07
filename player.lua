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

player.headheight = 0.5
player.deathheight = 0.15

player.gun = {}
player.gun.magsize = 6
player.gun.cooldown = 1/2
player.gun.reloadtime = 3/2
player.gun.reloadt = nil
player.gun.range = 5

function player:getkey(angle)
	return function (x, y)
		player:center(x + .5, y + .5)
		player.dir = angle or 0
		screen.centercursor()
		player.gun.mag = player.gun.magsize
		player.gun.lastfiretime = 0
		player.health = 5
		player["red key"] = nil
		player["green key"] = nil
		player["blue key"] = nil
		return player
	end
end

local viewbobamp = 1/18
local viewbobfreq = 3
local viewbobt = 0

local dpos = Vector()
function player:update(dt)
	local viewbob
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
		viewbobt = viewbobt + (dpos:len() * dt)
		viewbob = math.sin(viewbobt * viewbobfreq) * viewbobamp
		dpos:rotate2d(self.dir - (math.pi / 2))
		dpos:scale(dt)
		self:move(dpos:xy())
		if self.gun.reloadt then
			self.gun.reloadt = self.gun.reloadt + dt
			if self.gun.reloadt >= self.gun.reloadtime then
				self.gun.reloadt = nil
				self.gun.mag = self.gun.magsize
			end
		end
		local tile = physics.Domain.current:get(self:ijcenter())
		if type(tile) == "string" then
			hud.message = tile
		end
	else
		local ddir = dt * .5
		self.dir = self.dir + ddir
		camera:setangle(self.dir)
	end
	local x, y = self:center()
	camera.pos:set(x, y, self.dead and self.deathheight or (self.headheight + viewbob))
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
			local x, y = enemy:center()
			epos:set(x, y, 0):sub(startpos:xy(0))
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
				if (not nearestdist2 or disttoplayer2 < nearestdist2) and (disttoplayer2 <= (player.gun.range * player.gun.range)) then
					nearestdist2 = disttoplayer2
					nearest = enemy
				end
			end
		end
		if nearest then
			nearest:takedamage(1)
			epos:set(nearest:center())
		else
			epos:set(pos)
		end
		if dist <= player.gun.range then
			local explosion = ParticleExplosion(wallhitsprite, 50, 1/2, 1, 1/10, 1/2, 1, 3):addtodomain():center(epos:xy())
			explosion.z = player.headheight
		end
	end
end

local pos, dir = Vector(), Vector()
function player.gun:fire()
	local time = love.timer.getTime()
	if time - self.lastfiretime >= self.cooldown and self.mag > 0 and not self.reloadt then
		self.lastfiretime = time
		self.mag = self.mag - 1
		physics.Domain.current:raycast(pos:set(player:center()), dir:set(Vector.east()):rotate2d(player.dir), nil, raycasthitprocessor)
	end
end

function player.gun:reload()
	if self.mag < self.magsize then
		self.reloadt = 0
	end
end

function player:mousepressed(x, y, button)
	if button == 1 then
		if not self.dead then
			self.gun:fire()
			return true
		end
	else
		self.gun:reload()
	end
end

function player:keypressed(key)
	if key == "space" then
		self.gun:fire()
		return true
	end
	if key == "r" then
		self.gun:reload()
	end
end

function player:takedamage(damage)
	if self.class.takedamage(self, damage) then
		hud:damageflash()
	end
end

function player:render()
end
