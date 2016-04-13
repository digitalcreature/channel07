require "physics"
require "camera"
require "player"
require "util"

require "Vector"
require "entity.Enemy"
require "entity.ParticleExplosion"

TV = subclass(Enemy) do

	local base = TV

	local staticsound = love.audio.newSource("sound/tv-static.wav", "static")
	staticsound:setAttenuationDistances(1, 3)
	staticsound:setLooping(true)
	local deathsound = love.audio.newSource("sound/tv-death.wav", "static")
	deathsound:setVolume(1/2)

	base.neighborradius = 3
	base.avoidfactor = 3
	base.damageradius = 1/4

	base.smileradius = 3/2
	base.attackradius = 1

	base.aggroradius = render.fogend

	local h = 1
	base.framesprite = Billboard("sprite/tv-frame.png", 1, 2/3, 2/3, 1/3, 1/3)
	base.staticsprite = Billboard("sprite/tv-static.png", 8, 2/3, 2/3, 1/3, 1/3, {nofog = true})
	base.smilesprite = Billboard("sprite/tv-smile.png", 8, 2/3, 2/3, 1/3, 1/3, {nofog = true})
	base.screensprite = base.staticsprite

	base.speed = 1
	base.health = 1

	function base:init()
		base.super.init(self, 1/4, 1/4)
		self.z = 0.6
		self.staticsound = staticsound:clone()
		self.deathsound = deathsound:clone()
	end

	local avoid, dpos, temp = util.calln(3, Vector)
	function base:update(dt)
		local dist2 = temp:set(self:center()):dist2(player:center())
		if dist2 <= (self.aggroradius * self.aggroradius) then
			local neighborcount = 0
			avoid:set(Vector:zero())
			for i = 1, #physics.Domain.current.entities do
				local tv = physics.Domain.current.entities[i]
				if instanceof(tv, TV) and not tv.dead then
					local dist = temp:set(self:center()):sub(tv:center()):len()
					if dist < self.neighborradius then
						neighborcount = neighborcount + 1
						temp:scale(self.avoidfactor * (1 - (dist / self.neighborradius)))
						avoid:add(temp)
					end
				end
			end
			avoid:scale(1 / neighborcount)
			if dist2 <= (self.smileradius * self.smileradius) then
				self.screensprite = self.smilesprite
				if dist2 <= (self.attackradius * self.attackradius) then
					player:takedamage()
				end
			else
				self.screensprite = self.staticsprite
			end
			dpos:set(player:center()):sub(self:center()):norm():add(avoid):scale(self.speed * dt)
			self:move(dpos:xy())
			local x, y = self:center()
			self.staticsound:setPosition(x, y)
			self.staticsound:play()
		else
			self.staticsound:stop()
		end
	end

	function base:render()
		self.framesprite:render(self:center())
		self.screensprite:render(self:center())
	end

	local deathparticle = Billboard("sprite/statichit.png", 16, 1/4, 1/4, nil, nil, {nofog = true})

	function base:die()
		base.super.die(self)
		local effect = ParticleExplosion(deathparticle, 40, 1/2, 1, 1, 3, 1, 3, -5):center(self:center()):addtodomain()
		effect.speed = 2
		self.staticsound:stop()
		local x, y = self:center()
		self.deathsound:setPosition(x, y)
		self.deathsound:play()
	end

end
